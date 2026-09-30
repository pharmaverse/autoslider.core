# Insert AI story slides into an open deck

Inserts the \`summary\` slides at the front of the deck (in order) and
the \`conclusions\` slides at the end. This is pure \`officer\` work
with no network access, so it can be unit-tested with a hand-written
\`story\`.

## Usage

``` r
add_story_slides(ppt, story)
```

## Arguments

- ppt:

  An \`officer::rpptx\` object holding the generated content deck.

- story:

  A story \`list\` with \`summary\` and \`conclusions\` elements, each a
  list of slides (see \[get_ai_story()\]).

## Value

The modified \`officer::rpptx\` object.
