# Ask an LLM to tell the story of the decorated outputs

Sends the deck's tables to the chosen LLM provider and returns a
structured narrative: a \`summary\` section (for the front of the deck)
and a \`conclusions\` section (for the end). Each section is a list of
slides, and each slide has a \`layout\`, a \`title\` and a character
vector of \`bullets\`.

## Usage

``` r
get_ai_story(
  outputs,
  allowed_layouts,
  platform = "deepseek",
  base_url = "https://api.deepseek.com",
  api_key = get_deepseek_key(),
  model = "deepseek-chat",
  max_slides = 4L
)
```

## Arguments

- outputs:

  A named \`list\` of decorated outputs (see \[decorate_outputs()\]).

- allowed_layouts:

  Character vector of permitted layouts. Any layout the model returns
  outside this set is clamped to \`"Title and Content"\`.

- platform, base_url, api_key, model:

  Passed to \[get_ellmer_chat()\] to build the chat connection.

- max_slides:

  Integer cap on slides per section.

## Value

A \`list\` with two elements, \`summary\` and \`conclusions\`, each a
list of slides (\`list(layout, title, bullets)\`).
