# DOCUMENTATION

SPG uses '*blocks*' for holding predefined text sources

## Predefined Blocks

| Block Name   | Information |
| ------------ | ----------- |
| `__info__`   | Contains information about SPG Generator (version etc.) **Content Changes for output type**|
| `__version__`| Contains version information

When generating document output SPG goes each line for determining *line mode*
if a line starts with '\*' and ends with '\*\*' line is interpreted as a *command line*
a *command line* should always return a string to generated documents source.
 if the line is not a *command line*, the content of the line is written to document output

## *Comment Line*
A Comment line is a line starts with `--` and the line content is not written into document output

## *Magic Line*
A Magic Line is a line that starts with the % character. Any magic expressions within the line are converted based on the document’s output format.

For example:

In HTML output, `{hr}` is converted to `<hr>`.

In TXT output, the same expression becomes `---`.

The Magic Line mechanism allows flexible formatting depending on the output type.


## *Command Line*
A command line have two parts a `command_name` and `argument`.
command name and argument is needs to be seperated by a `:`

**valid commands for version 0.12 is listed below**

| Commmand Name  | Argument Required       | Information                                   |
| -------------- | ----------------------- | --------------------------------------------- |
| setblock       | Yes, a valid block name | For starting the 'content setting' of a block |
| endblock       | Yes, a valid block name | For ending the 'content setting' of a block   |
| writeblock     | Yes, a valid block name | For writing content of a block to output      |
| nothing        | No                      | Does nothing.                                 |
| writeallblocks | Optional, a seperator   | Writes all defined block names                |
## Output Types

**valid output types for version 0.12 is listed below**

| Type Name | extension(s)     | Information   |
| --------- | ---------------- | ------------- |
| MARKDOWN  | .md, .md.spg     | Markdown      |
| HTML      | .html, .html.spg | HTML          |
| TXT       | .txt, .txt.spg   | Text Document |

## Magics

**valid magics for version 0.12 is listed below**

| Magic Value    | Description            | Supported Output Types |
| -------------- | ---------------------- | ---------------------- |
| {hr}           | Horizontal Line        | MARKDOWN,HTML,TXT      |
| {big_text}     | Header-like text begin | MARKDOWN,HTML,TXT      |
| {big_text_end} | Header-like text end   | MARKDOWN,HTML,TXT      |
| {bold}         | Bold text begin        | MARKDOWN,HTML,TXT      |
| {bold_end}     | Bold text end          | MARKDOWN,HTML,TXT      |
| {nw}           | New Line               | MARKDOWN,HTML,TXT      |
| {italic}       | Italic text begin      | MARKDOWN,HTML,TXT      |
| {italic_end}   | Italic text end        | MARKDOWN,HTML,TXT      |