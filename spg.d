/*
Simple Page Generator


MIT License

Copyright (c) 2025 Kerem ATA

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
import std.stdio;
import std.string;
import std.file;
import std.array;
import core.stdc.stdlib;
import std.algorithm.searching;
import std.conv;
import std.path : stripExtension,baseName,buildPath,dirName;
import spg_lib;

void print_help(string run_name){
	writef(`SPG version %.3f
	
Usage: %s source [arguments]

Arguments:
	--help: Prints this text and exits
	--savedir: Saves output file to actual source files directory
	--version: Writes version of SPG and exits
	--write: Writes generated output to stdout instead of output file
	--output_type: Sets output generation format
		VALID: 'MARKDOWN','HTML','TXT'
		DEFAULT: Automatically (if the type isn't detected, it assumes it's an TXT file).
	--output_file: Sets output file path
		DEFAULT: result`,__version__,run_name);
}

void main(string[] args) {
  	if (args.length == 1){
		print_help(args[0]);
		exit(0);
	}
	
	string output_file = "result";
	OutputType output_type = default_output_type;
	string source_arg = args[1];
	string source_content;
	
	// Arguments
	bool help_text_arg = get_arg("--help",args);
	bool save_dir_arg = get_arg("--savedir",args);
	bool version_text_arg = get_arg("--version",args);
	bool write_stdout_arg = get_arg("--write",args);
	string output_file_arg = get_value_arg("--output_file",args);
	string output_type_arg = get_value_arg("--output_type",args);

	// Argument handling
	if (help_text_arg) {
		print_help(args[0]);
		exit(0);
	}

	if (version_text_arg) {
	  writef("SPG Version %.3f\n\n%s",__version__,generate_info(OutputType.TXT));
	  exit(0);
	}
	
	if (output_file_arg != "") {
		output_file = output_file_arg;
	}
	
    
	if (source_arg.startsWith("\"") && source_arg.endsWith("\"")){
		source_content = source_arg[1..$-1];
	} else {
		try {
			source_content = readText(source_arg);
		} catch (Exception e){
			error(format("Unable to read file '%s': %s",source_arg,e.msg));
		}

		output_type = get_output_type(source_arg);
		if (output_file_arg == "") {
		  output_file = stripExtension(baseName(source_arg));
		}
	}

	if (output_type_arg != "") {
		try {
		output_type = to!OutputType(output_type_arg);
		} catch (Exception e){
			error(format("Unable to set output type '%s': %s",output_type_arg,e.msg));
		}
	}

	if (save_dir_arg) {
	  output_file = buildPath(dirName(source_arg),output_file);
	}

	// Document generation.
	
    Document doc = new Document(source_content);
	string generated_doc = doc.generate(output_type);
    
	string output = doc.generate(output_type);
	
	if (write_stdout_arg) {
		write(output);
	} else {
		std.file.write(output_file,output);
	}
}
