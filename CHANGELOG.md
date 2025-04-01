# CHANGELOG

## Version 0.13 - 02/04/2025

### Added
* Added `--output-type`, `--content-type` arguments to SPG Server.
* Added `argument_seperator` const string to spg_lib.d
* Added `loadfile` command.
* Added `{code}` and `{code_end}` magics.
* Added `{scroll}` and `{scroll_end}` magics.

### Changed
* SPG Server now prints output type of resource to stdout.
* `__version__` variable changed to `0.13` in spg_lib.d
* `check_exact_arg_count` function added to spg_lib.d
* Informations on DOCUMENTATION.md file.
* Argument parsing is changed, from now on commands can have ':' in their arguments. If a command is requies multiple arguments you can use ',,' to seperate arguments.
* `examples/showcase.spg` is modified for better.

### Removed
* Unused `Error` struct is removed from spg_lib.d

## Version 0.12 - 24/03/2025

### Added
* SPG Server (spg_server.d) changes the response's content type according to the MIME type if the file extension is recognized. If no MIME type is found for the file extension, `text/plain` is sent.
* `output_type_content_types` Added to spg_lib.d
* `get_file_extension` Added to spg_lib.d
* `stop()` function Added to spg_server.d/SPGServer class.
* `LineType` enum Added to spg_lib.d
* `replace_magics` Added to spg_lib.d
* Added comment line support in spg_lib.d
* Added magic line support in spg_lib.d
* Added `nothing` command.
* Added File *examples/showcase.spg*
* *Conditional commands* Added to Planned Features / Things

### Changed
* `build_server` rule doesn't require `build` rule
* Informations on DOCUMENTATION.md file.

### Fixed
* SPGServer now returns correct content type
* spg.d `--output_type` argument is working

## Version 0.11 - 24/03/2025

### Added
* Web Server Added
* CHANGELOG.md Added
* `build_all` `just_build_server` `build_server` rules added Makefile

### Changed
* Fixed typos in README.md, and added information about new web server
* `clean` rule now deletes *.obj files 

### Fixed
* Non-working examples `test.md.spg` and `test.txt.spg` is fixed.
