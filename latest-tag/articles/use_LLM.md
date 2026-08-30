# Generating AI-Powered speaker notes

## Overview

This guide explains how to use the
[`get_ai_notes()`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_notes.md)
function to automatically add analytical annotations and summaries to
your slides using an AI tool.

## Prerequisite

Before you begin, ensure you have the following ready:

- A Prompt File (`prompt.yml`) containing the instructions for the AI
  model.

- Access to a local LLM instance.

Please see `autoslideR.Rmd` for some readily available spec and filter
examples and detailed instructions on how to use them. If you do not
have an LLM model installed yet, see appendix on how to deploy your own
local LLM.

## The Workflow

The process involves three main steps: generating the initial slide
data, adding the AI footnotes, and then creating the final PowerPoint
file.

### Step 1: Initial Slide Generation

First, generate the core slide outputs from your specification file.
This process reads your spec, filters it for the desired programs, and
generates the basic table and plot objects.

`spec`` ``<-`` `[`read_spec`](https://pharmaverse.github.io/autoslider.core/reference/read_spec.md)`(``"path/to/your/spec.yml"``)`` ``filters``::`[`load_filters`](https://rdrr.io/pkg/filters/man/load_filters.html)`(``"path/to/your/filter.yml"``)`` ``prompt_list`` ``<-`` `[`get_prompt_list`](https://pharmaverse.github.io/autoslider.core/reference/get_prompt_list.md)`(``"path/to/your/prompt.yml"``)`` `` ``# Generate the initial outputs`` ``outputs`` ``<-`` ``spec`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`filter_spec`](https://pharmaverse.github.io/autoslider.core/reference/filter_spec.md)`(``program`` `[`%in%`](https://rdrr.io/r/base/match.html)` `[`c`](https://rdrr.io/r/base/c.html)`(``"t_dm_slide"``)``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`generate_outputs`](https://pharmaverse.github.io/autoslider.core/reference/generate_outputs.md)`(``datasets ``=`` ``my_datasets``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`decorate_outputs`](https://pharmaverse.github.io/autoslider.core/reference/decorate_outputs.md)`(``)`

### Step 2: Adding AI Footnotes

Next, pass the outputs object to the
[`get_ai_notes()`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_notes.md)
function. This function iterates through your outputs, and for each one
that has a corresponding prompt, it communicates with the specified LLM
model to generate a response in the form of a speaker note.

You can configure the function to point to different AI platforms.

#### Example: Using a Local LLM

This is ideal for local development. It assumes you have Ollama on your
local machine and is developing in a Docker container.

`outputs_ai`` ``<-`` `[`get_ai_notes`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_notes.md)`(`` `` outputs ``=`` ``outputs``,`` `` prompt_list ``=`` ``prompt_list``,`` `` platform ``=`` ``"ollama"``,`` `` base_url ``=`` ``"http://host.docker.internal:11434"``, ``# URL for Ollama if R in a Docker container`` `` model ``=`` ``"deepseek-r1:1.5b"`` ``# The LLM model name`` ``)`

The parameters you pass in might depend on your specific situation. In
general:

- `platform`: Set to `ollama`.

- `base_url`: Points to where your `Ollama` instance is running.

- `model`: The name of a model you have pulled in `Ollama.`

### Step 3: Create the Final PowerPoint File

Finally, take the modified `outputs_ai` object and pass it to
[`generate_slides()`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md)
to create the presentation. The footnotes will be automatically included
on the relevant slides.

`outputs_ai`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`generate_slides`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md)`(``outfile ``=`` ``"My_AI_Presentation.pptx"``)`

This will produce a PowerPoint file with your tables and plots, and
enhanced with AI generated analysis.

## Appendix

### Running Your Local LLM

First of all, we need to download the Ollama tool at
<https://ollama.com/download>. Once Ollama is installed, you can run any
model from its library with a single command. For this example, we’ll
use deepseek-r1:1.5b.

Open your command-line tool (e.g., Terminal, Windows PowerShell).

Type the following command and press Enter. Ollama will automatically
download the model, which may take a few minutes.

``` bash
$ ollama run deepseek-r1:1.5b
```

After the process completes, you will see a success message and a new
prompt, like this:

``` bash
$ >>> Send a message (/? for help)
```

This means you have successfully installed and are now running a local
LLM. Feel free to start a conversation and play around with some
prompts!
