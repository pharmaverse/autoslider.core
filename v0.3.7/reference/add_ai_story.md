# Add an AI-generated story to a generated deck

Post-processes an already-generated \`.pptx\`: loads it, asks an LLM to
tell the story of the decorated outputs (see \[get_ai_story()\]), and
inserts the narrative as real content slides – a summary section at the
front and a conclusions section at the end – then writes the deck back
out.

## Usage

``` r
add_ai_story(
  outputs,
  infile,
  outfile = infile,
  platform = "deepseek",
  base_url = "https://api.deepseek.com",
  api_key = get_deepseek_key(),
  model = "deepseek-chat",
  max_slides = 4L
)
```

## Arguments

- outputs:

  A named \`list\` of decorated outputs (see \[decorate_outputs()\]),
  used as the data the story is told from.

- infile:

  Path to the generated \`.pptx\` to read.

- outfile:

  Path to write the augmented deck to. Defaults to \`infile\` (overwrite
  in place).

- platform, base_url, api_key, model:

  Passed to \[get_ellmer_chat()\].

- max_slides:

  Integer cap on slides per section.

## Value

Invisibly, the path written (\`outfile\`).

## Details

Unlike \[get_ai_notes()\], which hides the LLM response in speaker
notes, this produces slides that are visible in presentation mode.
