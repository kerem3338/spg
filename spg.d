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

enum OutputType {
	MARKDOWN,
	HTML,
	TXT
}

const OutputType default_output_type = OutputType.TXT;
const float __version__ = 0.1;
const string __author__ = "Zoda (kerem3338)";
OutputType[string] output_type_extensions = [
   ".md": OutputType.MARKDOWN,
   ".md.spg": OutputType.MARKDOWN,
   ".html": OutputType.HTML,
   ".html.spg": OutputType.HTML,
   ".txt": OutputType.TXT,
   ".txt.spg": OutputType.TXT
];

const string __info__ = format(`{big_text}SPG{big_text_end}

SPG Version '%.3f', {bold}Simple Page Generator{bold_end} is a simple page generation tool from Zoda (https://github.com/kerem3338)
License: MIT (https://mit-license.org)`,
	__version__);

OutputType get_output_type(string filename){
  foreach (extension,type; output_type_extensions){
	if (filename.endsWith(extension)){
	  return type;
	}
  }
  return default_output_type;
}
void error(string message, int exit_code = 1) {
    writeln(message);
    exit(exit_code);
}

void line_error(string message, int line){
	string _message = format("[At Line %d] %s",line,message);
	error(_message);
}

string replace_all(string input, string[string] replace_array) {
    foreach (key, value; replace_array) {
        input = input.replace(key, value);
    }
    return input;
}
string generate_info(OutputType output_type){
	string new_info = __info__;
	switch (output_type){
		case OutputType.MARKDOWN, OutputType.TXT:
			string[string] replacements = [
				"{big_text}": "# ",
				"{big_text_end}": "",
				"{bold}": "**",
				"{bold_end}": "**",
			];
			new_info = replace_all(new_info,replacements);
			break;
		case OutputType.HTML:
			string[string] replacements = [
				"{big_text}": "<h1>",
				"{big_text_end}": "</h1>",
				"{bold}": "<b>",
				"{bold_end}": "</b>"
			];
			new_info = replace_all(new_info,replacements);
			break;
		default:
			error(format("Output type '%s' is not a valid type (as we know).",output_type));
			break;
	}
	return new_info;
}
void check_empty_arg(string command_name, string arg, int line) {
    if (strip(arg).length == 0) {
        error(format("[At Line %d ] Command '%s' requires non-empty argument content", line + 1, command_name));
    }
}

struct Block {
    string content;
    bool can_append = false;
    bool ended = false;
}

class Document {
    public string source;
    private Block[string] blocks;
    private string[] lines;
    private string current_block = "";
	
    this(string source) {
        this.source = source;
        this.lines = source.splitLines();
    }

    string handle_command(int c_line, string command_str) {
        if (command_str.length < 4) {
            error("Invalid Command Format");
        }
        string full_command = command_str[1..$-2];

        string[] command_parts = full_command.split(":");
        if (command_parts.length < 2) {
            error("No Argument Given");
        }

        string command_name = command_parts[0];
        string argument = command_parts[1];

        switch (command_name) {
            case "setblock":
                check_empty_arg("setblock", argument, c_line);
                blocks[argument] = Block("", true);
                current_block = argument;
                return "";
            case "endblock":
                check_empty_arg("endblock", argument, c_line);
                if (!(argument in blocks)) {
                    line_error(format("endblock: block '%s' is not defined before", argument), c_line);
                }
                blocks[argument].can_append = false;
                blocks[argument].ended = true;
                current_block = "";
                return "";
			
			case "writeblock":
                check_empty_arg("writeblock", argument, c_line);
                if (!(argument in blocks)) {
                    line_error(format("writeblock: block '%s' is not defined before", argument), c_line);
                }
                return blocks[argument].content;
            default:
                line_error(format("Undefined Command '%s'", command_name), c_line);
        }
        return "";
    }

    string generate(OutputType output_type = default_output_type) {
        string _out = "";
		
		// Predefined blocks
		blocks["__info__"] = Block(generate_info(output_type));
		blocks["__version__"] = Block(__version__.to!string);
		
        int c_line = 0;
        while (c_line < lines.length) {
            string line_content = this.lines[c_line];
            string safe_line = strip(line_content);

            if (safe_line.startsWith("*") && safe_line.endsWith("**")) {
                _out ~= handle_command(c_line, safe_line);
            } else {
                if (current_block.length > 0 && blocks[current_block].can_append) {
                    blocks[this.current_block].content ~= line_content ~ "\n";
                } else {
                    _out ~= line_content ~ "\n";
                }
            }
            c_line++;
        }
        return _out;
    }
}

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
string get_value_arg(string arg_name,string[] args){
	foreach(string arg; args){
		if (arg.startsWith(arg_name) && arg[arg_name.length] == '='){
			return arg[arg_name.length + 1..$];
		}
	}
	return "";
}
bool get_arg(string arg_name,string[] args){
	foreach(string arg; args){
		if (arg == arg_name){
			return true;
		}
	}
	
	return false;
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

	
	if (output_type_arg != "") {
		try {
		output_type = to!OutputType(output_type_arg);
		} catch (Exception e){
			error(format("Unable to set output type '%s': %s",output_type_arg,e.msg));
		}
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
