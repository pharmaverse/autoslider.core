#!/usr/bin/env Rscript
# Autoslider MCP Server
#
# Exposes the autoslider.core pipeline as MCP tools so Claude can orchestrate
# slide generation conversationally via Claude Desktop or the Claude API.
#
# Usage:
#   Rscript inst/mcp/autoslider_mcp_server.R
#
# Register in Claude Desktop — see inst/mcp/claude_desktop_config_snippet.json
#
# Requirements:
#   install.packages("mcptools")        # on CRAN
#   # ellmer and autoslider.core already in your renv/library

suppressPackageStartupMessages({
  library(mcptools)
  library(ellmer)
  library(autoslider.core)
  library(filters)
  library(dplyr)
})

# ---- session state ----------------------------------------------------------
# Holds spec and outputs across tool calls within one Claude session.
.state <- new.env(parent = emptyenv())
.state$spec    <- NULL
.state$outputs <- NULL

# ---- helpers ----------------------------------------------------------------
stop_if <- function(cond, msg) if (cond) stop(msg, call. = FALSE)
require_spec    <- function() stop_if(is.null(.state$spec),    "No spec loaded. Call load_spec first.")
require_outputs <- function() stop_if(is.null(.state$outputs), "No outputs generated. Call run_pipeline first.")

# ---- tool functions ---------------------------------------------------------

fn_list_programs <- function() {
  spec_file <- system.file("spec.yml", package = "autoslider.core")
  spec      <- read_spec(spec_file)
  programs  <- sort(unique(vapply(spec, `[[`, character(1), "program")))
  paste(programs, collapse = "\n")
}

fn_load_spec <- function(spec_path, filters_path, program_filter, suffix_filter) {
  if (spec_path == "default") {
    spec_path <- system.file("spec.yml", package = "autoslider.core")
  }
  if (filters_path == "default") {
    filters_path <- system.file("filters.yml", package = "autoslider.core")
  }

  filters::load_filters(yaml_file = filters_path, overwrite = TRUE)
  spec <- read_spec(spec_path)

  if (nzchar(program_filter)) {
    progs <- trimws(strsplit(program_filter, ",")[[1]])
    spec  <- filter_spec(spec, program %in% progs, verbose = FALSE)
  }

  if (nzchar(suffix_filter)) {
    suffs <- trimws(strsplit(suffix_filter, ",")[[1]])
    spec  <- filter_spec(spec, suffix %in% suffs, verbose = FALSE)
  }

  .state$spec    <- spec
  .state$outputs <- NULL

  sprintf(
    "Spec loaded: %d output(s).\n%s",
    length(spec),
    paste(names(spec), collapse = "\n")
  )
}

fn_show_spec <- function() {
  require_spec()
  df <- data.frame(
    output  = vapply(.state$spec, `[[`, character(1), "output"),
    program = vapply(.state$spec, `[[`, character(1), "program"),
    suffix  = vapply(.state$spec, function(s) if (!is.null(s$suffix)) s$suffix else "", character(1)),
    paper   = vapply(.state$spec, `[[`, character(1), "paper"),
    stringsAsFactors = FALSE
  )
  paste(capture.output(print(df, row.names = FALSE)), collapse = "\n")
}

fn_run_pipeline <- function(dataset_paths) {
  require_spec()

  if (dataset_paths == "example") {
    datasets <- list(
      adsl = autoslider.core::eg_adsl %>% mutate(FASFL = SAFFL),
      adae = autoslider.core::eg_adae
    )
  } else {
    pairs    <- trimws(strsplit(dataset_paths, ",")[[1]])
    datasets <- lapply(pairs, function(p) {
      parts <- strsplit(p, "=")[[1]]
      stop_if(length(parts) != 2, sprintf("Invalid entry '%s'. Use name=/path/to/file.rds", p))
      readRDS(trimws(parts[2]))
    })
    names(datasets) <- trimws(vapply(pairs, function(p) strsplit(p, "=")[[1]][1], character(1)))
  }

  outputs <- tryCatch(
    generate_outputs(.state$spec, datasets = datasets, verbose_level = 0),
    error = function(e) stop("Pipeline error: ", e$message, call. = FALSE)
  )
  outputs <- decorate_outputs(outputs)

  .state$outputs <- outputs

  errors    <- vapply(outputs, inherits, logical(1), "autoslider_error")
  ok_names  <- names(outputs)[!errors]
  err_names <- names(outputs)[errors]

  msg <- sprintf("Pipeline complete: %d succeeded, %d failed.", sum(!errors), sum(errors))
  if (length(ok_names))  msg <- paste0(msg, "\nOK:     ", paste(ok_names,  collapse = ", "))
  if (length(err_names)) msg <- paste0(msg, "\nFailed: ", paste(err_names, collapse = ", "))
  msg
}

fn_add_ai_notes <- function(api_key, model, prompt_path) {
  require_outputs()
  if (!nzchar(api_key)) api_key <- Sys.getenv("ANTHROPIC_API_KEY")
  stop_if(!nzchar(api_key), "Provide api_key or set ANTHROPIC_API_KEY environment variable.")

  if (prompt_path == "default") {
    prompt_path <- system.file("prompt.yml", package = "autoslider.core")
  }

  prompt_list  <- get_prompt_list(prompt_path)
  chat         <- ellmer::chat_anthropic(
    system_prompt = get_system_prompt(),
    api_key       = api_key,
    model         = model
  )

  names_outputs <- names(.state$outputs)
  updated <- lapply(names_outputs, function(nm) {
    out <- .state$outputs[[nm]]
    if (inherits(out, "autoslider_error") || !(nm %in% names(prompt_list))) return(out)
    base_prompt    <- prompt_list[[nm]]$prompt
    current_prompt <- integrate_prompt(base_prompt, out@tbl)
    raw_response   <- chat$chat(current_prompt)
    clean_response <- sub(".*?</think>\\s*", "", raw_response)
    out@usernotes  <- paste("claude", model, "generated notes:", clean_response)
    out
  })
  names(updated)  <- names_outputs
  .state$outputs  <- updated

  noted <- intersect(names_outputs, names(prompt_list))
  sprintf("AI notes added to %d output(s): %s", length(noted), paste(noted, collapse = ", "))
}

fn_generate_slides <- function(outfile, template) {
  require_outputs()
  if (template == "default") {
    template <- file.path(system.file(package = "autoslider.core"), "theme/basic.pptx")
  }
  outfile <- normalizePath(outfile, mustWork = FALSE)
  tryCatch(
    generate_slides(.state$outputs, outfile = outfile, template = template),
    error = function(e) stop("Slide generation error: ", e$message, call. = FALSE)
  )
  sprintf("Slides written to: %s", outfile)
}

fn_reset <- function() {
  .state$spec    <- NULL
  .state$outputs <- NULL
  "Session state cleared."
}

# ---- register tools with ellmer::tool() ------------------------------------

tools <- list(

  tool(
    fun = fn_list_programs,
    name = "list_programs",
    description = paste(
      "List all TLG program names available in the autoslider.core package.",
      "Call this first to discover what slide types can be generated",
      "(e.g. t_dm_slide, t_ae_slide, g_km_slide)."
    ),
    arguments = list()
  ),

  tool(
    fun = fn_load_spec,
    name = "load_spec",
    description = paste(
      "Load a spec.yml file (which defines what slides to generate) and a",
      "filters.yml file (which defines clinical population filters like FAS, SE).",
      "Optionally narrow the spec to specific programs or suffixes.",
      "Must be called before run_pipeline."
    ),
    arguments = list(
      spec_path = type_string(
        'Path to spec.yml. Use "default" for the built-in package spec.'
      ),
      filters_path = type_string(
        'Path to filters.yml. Use "default" for the built-in package filters.'
      ),
      program_filter = type_string(
        'Comma-separated program names to include, e.g. "t_dm_slide,t_ae_slide". Empty string = include all.'
      ),
      suffix_filter = type_string(
        'Comma-separated population suffixes to include, e.g. "FAS,SE". Empty string = include all.'
      )
    )
  ),

  tool(
    fun = fn_show_spec,
    name = "show_spec",
    description = "Show the currently loaded spec as a table (output name, program, suffix, paper size).",
    arguments = list()
  ),

  tool(
    fun = fn_run_pipeline,
    name = "run_pipeline",
    description = paste(
      "Run the autoslider pipeline: apply filters to datasets, call each TLG program,",
      "and decorate the outputs with titles and footnotes from the spec.",
      "Must call load_spec first.",
      'Pass dataset_paths as comma-separated name=path pairs, e.g.',
      '"adsl=/data/adsl.rds,adae=/data/adae.rds".',
      'Use "example" to use the built-in example CDISC datasets.'
    ),
    arguments = list(
      dataset_paths = type_string(
        'Comma-separated name=path.rds pairs, or "example" for built-in data.'
      )
    )
  ),

  tool(
    fun = fn_add_ai_notes,
    name = "add_ai_notes",
    description = paste(
      "Generate AI speaker notes for each slide output using Claude.",
      "Reads prompts from prompt.yml and calls the Anthropic API.",
      "Must call run_pipeline first."
    ),
    arguments = list(
      api_key = type_string(
        'Anthropic API key. Leave empty ("") to use the ANTHROPIC_API_KEY environment variable.'
      ),
      model = type_string(
        'Claude model ID, e.g. "claude-opus-4-8" or "claude-haiku-4-5".'
      ),
      prompt_path = type_string(
        'Path to prompt.yml. Use "default" for the built-in package prompts.'
      )
    )
  ),

  tool(
    fun = fn_generate_slides,
    name = "generate_slides",
    description = paste(
      "Assemble the generated outputs into a PowerPoint (.pptx) file.",
      "Must call run_pipeline first.",
      "Returns the absolute path to the written file."
    ),
    arguments = list(
      outfile = type_string(
        'Output file path for the .pptx, e.g. "/tmp/study_slides.pptx".'
      ),
      template = type_string(
        'Path to a .pptx template file. Use "default" for the built-in basic.pptx theme.'
      )
    )
  ),

  tool(
    fun = fn_reset,
    name = "reset",
    description = "Clear the session state (loaded spec and generated outputs). Useful to start a fresh run.",
    arguments = list()
  )

)

# ---- start server -----------------------------------------------------------

mcp_server(tools = tools)
