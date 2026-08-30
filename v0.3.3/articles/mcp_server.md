# Using autoslider.core via MCP

## Overview

`autoslider.core` ships an [MCP (Model Context
Protocol)](https://modelcontextprotocol.io/) server that exposes the
entire slide-generation pipeline as a set of tools any MCP-compatible AI
client can call. This means you can drive slide creation
conversationally — no manual R scripting required.

The server lives at `inst/mcp/autoslider_mcp_server.R` and registers
these tools:

| Tool              | What it does                                    |
|-------------------|-------------------------------------------------|
| `list_programs`   | Discover available TLG programs                 |
| `load_spec`       | Load a `spec.yml` and `filters.yml`             |
| `show_spec`       | Inspect the loaded spec                         |
| `run_pipeline`    | Run the full TLG pipeline against your datasets |
| `add_ai_notes`    | Generate speaker notes with an LLM              |
| `generate_slides` | Assemble outputs into a `.pptx` file            |
| `reset`           | Clear session state                             |

## Prerequisites

Install the required R packages:

[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"mcptools"``)`` ``# MCP server runtime`` ``# ellmer and autoslider.core are already in your renv/library`

Locate the server script. In a package checkout it is at:

    inst/mcp/autoslider_mcp_server.R

After installation you can find it with:

[`system.file`](https://rdrr.io/r/base/system.file.html)`(``"mcp/autoslider_mcp_server.R"``, package ``=`` ``"autoslider.core"``)`

------------------------------------------------------------------------

## Example 1: Claude Code as the MCP client

[Claude Code](https://claude.ai/code) is a terminal-based AI agent from
Anthropic. Once the autoslider MCP server is registered, Claude Code can
call all the tools above in a natural language conversation.

### Step 1 — Find the server script path

Run this in R to get the absolute path to the server script:

[`system.file`](https://rdrr.io/r/base/system.file.html)`(``"mcp/autoslider_mcp_server.R"``, package ``=`` ``"autoslider.core"``)`

Copy the result — you will paste it into the configuration below.

### Step 2 — Register the server

> **Important:** Claude Code does **not** read MCP servers from
> `.claude/settings.json`. That file is only for permissions, hooks, and
> environment variables. MCP servers are registered with the
> `claude mcp add` command (which writes to `~/.claude.json`) or via a
> `.mcp.json` file. Do not put an `mcpServers` block in `settings.json`
> — it will be silently ignored.

The **recommended approach** is to register the server at *user* scope
so it is available in every session, regardless of which directory you
open Claude Code in. Run this in your terminal:

``` bash
claude mcp add autoslider --scope user -- Rscript /absolute/path/to/autoslider_mcp_server.R
```

Replace the path with the one you found in Step 1. The `--` separates
Claude Code’s own flags from the command it should run.

The three scopes:

| Scope | Flag | Where it is stored | Availability |
|----|----|----|----|
| User | `--scope user` | `~/.claude.json` (top level) | Every directory (recommended) |
| Local | `--scope local` (default) | `~/.claude.json` (per project) | Only the directory you ran it in |
| Project | `--scope project` | `.mcp.json` in the repo | Anyone who checks out the repo |

For a team-shareable setup checked into the package repo, use
`--scope project`, which creates a `.mcp.json`:

``` json
{
  "mcpServers": {
    "autoslider": {
      "command": "Rscript",
      "args": ["/absolute/path/to/autoslider_mcp_server.R"]
    }
  }
}
```

> **API keys:** No `ANTHROPIC_API_KEY` is required to register or use
> the server. It is only needed if you call `add_ai_notes` with
> `provider = "anthropic"`. Add it later with
> `--env ANTHROPIC_API_KEY=sk-...` on the `claude mcp add` command, or
> omit it entirely if you use a local model (Ollama) or another
> provider.

> **WSL users:** Use a single leading slash in paths — `/mnt/c/...`, not
> `//mnt/c/...`.

### Step 3 — Verify the server is registered

Restart Claude Code, then type `/mcp` in the session — you should see
`autoslider` listed with a connected status. You can also list servers
from the terminal:

``` bash
claude mcp list
```

If it shows an error or does not appear, run `claude doctor` (it flags
config files that failed validation) and check:

- The path is the exact output of `system.file(...)` from Step 1.
- `Rscript` is on your `PATH` (test with `which Rscript`).
- The `mcptools` R package is installed
  (`install.packages("mcptools")`).

### Step 4 — Drive the pipeline conversationally

Open a Claude Code session and ask it to generate slides. Claude Code
will invoke the MCP tools automatically.

**Example conversation:**

    User:
      Generate demographic slides using the example data and save
      them to /tmp/study_slides.pptx. Add AI speaker notes using
      Claude Haiku.

    Claude Code:
      I'll use the autoslider MCP tools to do this step by step.

      [calls list_programs]
      → t_dm_slide, t_ae_slide, g_km_slide, ...

      [calls load_spec with spec_path="default", filters_path="default",
             program_filter="t_dm_slide", suffix_filter=""]
      → Spec loaded: 2 output(s).

      [calls run_pipeline with dataset_paths="example"]
      → Pipeline complete: 2 succeeded, 0 failed.

      [calls add_ai_notes with provider="anthropic",
             model="claude-haiku-4-5", api_key="", prompt_path="default",
             base_url=""]
      → AI notes added to 2 output(s): t_dm_slide_FAS, t_dm_slide_SE

      [calls generate_slides with outfile="/tmp/study_slides.pptx",
             template="default"]
      → Slides written to: /tmp/study_slides.pptx

      Done! The file is at /tmp/study_slides.pptx. It contains 2
      demographic slides with AI-generated speaker notes.

Claude Code decides the tool call sequence, reads your intent, and
handles errors automatically. You can iterate in plain English:

    User:
      Also add the adverse event slides for the FAS population.

    Claude Code:
      [calls reset]
      [calls load_spec with program_filter="t_dm_slide,t_ae_slide",
             suffix_filter="FAS"]
      [calls run_pipeline ...]
      [calls add_ai_notes ...]
      [calls generate_slides ...]

### Step 5 — Use your own data

Replace `"example"` with your actual datasets in the `run_pipeline`
call:

    User:
      Use adsl=/data/trial/adsl.rds and adae=/data/trial/adae.rds

Claude Code will pass
`dataset_paths="adsl=/data/trial/adsl.rds,adae=/data/trial/adae.rds"` to
`run_pipeline`.

------------------------------------------------------------------------

## Example 2: Ollama local model (DeepSeek) for AI notes

If you prefer to keep data on-premise or want to avoid cloud API costs,
you can use a local model running in [Ollama](https://ollama.com) for
the `add_ai_notes` step. The MCP server itself still runs locally as an
`Rscript` process; only the note-generation step changes.

### Step 1 — Install Ollama and pull a model

Download Ollama from <https://ollama.com/download> and install it. Then
pull DeepSeek:

``` bash
ollama pull deepseek-r1:1.5b   # ~1 GB, fast on CPU
# or a larger variant:
ollama pull deepseek-r1:7b
```

Verify it is running:

``` bash
ollama list
# NAME                    ID              SIZE    MODIFIED
# deepseek-r1:1.5b        ...             1.1 GB  ...
```

Ollama listens on `http://localhost:11434` by default. No API key is
needed.

### Step 2 — Register the server (no API key required)

Register it exactly as in Example 1 — the server is the same; only the
note-generation provider changes at call time:

``` bash
claude mcp add autoslider --scope user -- \
  Rscript /absolute/path/to/autoslider_mcp_server.R
```

No API key is needed because Ollama is local and unauthenticated.

### Step 3 — Ask for Ollama-backed notes

In a Claude Code session (or any MCP client), tell it to use Ollama:

    User:
      Generate demographic slides with the example data, write speaker
      notes using the local DeepSeek model in Ollama, and save to
      /tmp/slides_local.pptx.

    Claude Code:
      [calls load_spec with spec_path="default", filters_path="default",
             program_filter="t_dm_slide", suffix_filter=""]

      [calls run_pipeline with dataset_paths="example"]

      [calls add_ai_notes with provider="ollama",
             model="deepseek-r1:1.5b", api_key="",
             prompt_path="default", base_url=""]
      → AI notes added to 2 output(s).

      [calls generate_slides with outfile="/tmp/slides_local.pptx",
             template="default"]
      → Slides written to: /tmp/slides_local.pptx

### Running R in a Docker container?

If your R session is inside a container, Ollama runs on the host, so
`localhost` resolves to the container itself. Use the Docker host
address instead:

    base_url = "http://host.docker.internal:11434"

Pass this in your conversation:

    User:
      Use the local DeepSeek model. My R is running in Docker so
      point Ollama at http://host.docker.internal:11434.

Claude Code will pass `base_url="http://host.docker.internal:11434"` to
`add_ai_notes`.

### Calling the R functions directly

If you prefer to skip the MCP layer and call the functions directly from
R, the underlying workflow is the same — only the
[`get_ai_notes()`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_notes.md)
call changes:

[`library`](https://rdrr.io/r/base/library.html)`(`[`autoslider.core`](https://github.com/pharmaverse/autoslider.core)`)`` `[`library`](https://rdrr.io/r/base/library.html)`(`[`dplyr`](https://dplyr.tidyverse.org)`)`` `[`library`](https://rdrr.io/r/base/library.html)`(``filters``)`` `` ``filters``::`[`load_filters`](https://rdrr.io/pkg/filters/man/load_filters.html)`(`` `` `[`system.file`](https://rdrr.io/r/base/system.file.html)`(``"filters.yml"``, package ``=`` ``"autoslider.core"``)``,`` `` overwrite ``=`` ``TRUE`` ``)`` `` ``outputs`` ``<-`` `[`read_spec`](https://pharmaverse.github.io/autoslider.core/reference/read_spec.md)`(`[`system.file`](https://rdrr.io/r/base/system.file.html)`(``"spec.yml"``, package ``=`` ``"autoslider.core"``)``)`` ``|>`` `` `[`filter_spec`](https://pharmaverse.github.io/autoslider.core/reference/filter_spec.md)`(``program`` `[`%in%`](https://rdrr.io/r/base/match.html)` ``"t_dm_slide"``, verbose ``=`` ``FALSE``)`` ``|>`` `` `[`generate_outputs`](https://pharmaverse.github.io/autoslider.core/reference/generate_outputs.md)`(`` `` datasets ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(`` `` adsl ``=`` ``eg_adsl`` ``|>`` `[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html)`(``FASFL ``=`` ``SAFFL``)``,`` `` adae ``=`` ``eg_adae`` `` ``)``,`` `` verbose_level ``=`` ``0`` `` ``)`` ``|>`` `` `[`decorate_outputs`](https://pharmaverse.github.io/autoslider.core/reference/decorate_outputs.md)`(``)`` `` ``prompt_list`` ``<-`` `[`get_prompt_list`](https://pharmaverse.github.io/autoslider.core/reference/get_prompt_list.md)`(`` `` `[`system.file`](https://rdrr.io/r/base/system.file.html)`(``"prompt.yml"``, package ``=`` ``"autoslider.core"``)`` ``)`` `` ``# Ollama / DeepSeek — no API key, runs fully offline`` ``outputs_ai`` ``<-`` `[`get_ai_notes`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_notes.md)`(`` `` outputs ``=`` ``outputs``,`` `` prompt_list ``=`` ``prompt_list``,`` `` platform ``=`` ``"ollama"``,`` `` model ``=`` ``"deepseek-r1:1.5b"``,`` `` base_url ``=`` ``"http://localhost:11434"`` ``)`` `` `[`generate_slides`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md)`(``outputs_ai``, outfile ``=`` ``"slides_local.pptx"``)`

------------------------------------------------------------------------

## Choosing a provider

| Scenario | `provider` | `model` example | Notes |
|----|----|----|----|
| Cloud, best quality | `"anthropic"` | `"claude-haiku-4-5"` | Requires `ANTHROPIC_API_KEY` |
| Fully local, offline | `"ollama"` | `"deepseek-r1:1.5b"` | No key; install Ollama first |
| OpenAI-compatible API | `"openai"` | `"gpt-4o-mini"` | Requires `OPENAI_API_KEY` |
| DeepSeek cloud API | `"deepseek"` | `"deepseek-chat"` | Requires `DEEPSEEK_API_KEY` |

The `base_url` parameter lets you point any provider at a custom
endpoint — useful for local proxies, enterprise gateways, or self-hosted
models.
