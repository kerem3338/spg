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

## *Command Line*
A command line have two parts a `command_name` and `argument`.
command name and argument is needs to be seperated by a `:`

**valid commands for version 0.1 is listed below**

| Commmand Name | Argument Required       | Information                                   |
| ------------- | ----------------------- | --------------------------------------------- |
| setblock      | Yes, a valid block name | For starting the 'content setting' of a block |
| endblock      | Yes, a valid block name | For ending the 'content setting' of a block   |
| writeblock    | Yes, a valid block name | For writing content of a block to output      |

## Output Types

**valid output types for version 0.1 is listed below**

| Type Name | extension(s)     | Information   |
| --------- | ---------------- | ------------- |
| MARKDOWN  | .md, .md.spg     | Markdown      |
| HTML      | .html, .html.spg | HTML          |
| TXT       | .txt, .txt.spg   | Text Document |