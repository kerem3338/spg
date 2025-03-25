# CHANGELOG

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
