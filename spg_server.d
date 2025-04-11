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
module spg_server;

import spg_lib;
import std.socket;
import std.format;
import std.stdio;
import std.array;
import std.string;
import std.conv;
import core.stdc.stdlib;
import std.path;
import std.utf;
import std.encoding;
import core.exception;

import std_file = std.file;

const __server_info__ = `SPG (Simple Page Generator) Server

You can navigate files with making a GET request to file's path.
SPG automatically selects output type and generates content based on source file.

Running At: %s:%s
`;

string return_http_result(string status_code_str, string content, string content_type = "text/html"){
	return format("HTTP/1.1 %s\r\nContent-Type: %s\r\nConnection: close\r\n\r\n%s",status_code_str,content_type,content);
}
string[string] get_request_info(char[] buffer) {
	string[string] request;


	string request_text;
	try {
		request_text = to!string(buffer);
	} catch (Exception e) {
		return request;
	}


	string[] lines = request_text.split("\r\n");

	if (lines.length > 0) {
		string[] fline_parts = lines[0].split();
		if (fline_parts.length >= 2) {
			request["method"] = fline_parts[0];
			request["path"] = fline_parts[1];
		}
		
		// Process headers
		foreach (string line; lines[1 .. $]) {
			if (line.length == 0) break;

			string[] parts = line.split(":");
			if (parts.length > 1) {
				request[parts[0].strip()] = parts[1].strip();
			}
		}
	}

	return request;
}

string generate_from_file(OutputType output_type,string filepath) {
	Document document = new Document(std_file.readText(filepath));
	return document.generate(output_type);	
}

struct ServerSettings {
	bool list_dir = true;

	OutputType force_output_type;
	bool force_output_type_flag = false;

	string force_content_type;
	bool force_content_type_flag = false; 
}

class SPGServer {
	TcpSocket server;
	ServerSettings server_settings;
	InternetAddress internet_address;
	int max_pending = 1;
	string serve_dir;

	this(InternetAddress internet_address,string serve_dir){
		this.server = new TcpSocket();
		this.internet_address = internet_address; 
		this.server.bind(internet_address);
		this.server.listen(this.max_pending);

		this.serve_dir = serve_dir;
	}

	void stop() {
		server.close();
		writeln("Server is closed.");
	}

	void start() {
		std.stdio.writeln(format("Server Started, Address: %s,Port: %s",internet_address.addrToString(this.internet_address.addr),internet_address.port));

		while (true) {
			auto client = server.accept();
			char[1024] buffer;
			auto received = client.receive(buffer[]);

			if (received <= 0) {
				client.close();
				continue;
			}
			string[string] request_info = get_request_info(buffer);
			string return_content = "";
			string status_code = "200 OK";
			string content_type = "text/plain";
			string requested_path = request_info["path"][1..$];

			OutputType output_type = default_output_type;
			
			if (!("path" in request_info) && !("method" in request_info)) {
				client.close();
				continue;
			}

			if (requested_path == ""){
				requested_path = "index.spg";
			}


			if (server_settings.force_content_type_flag) content_type = server_settings.force_content_type;
			if (server_settings.force_output_type_flag) output_type = server_settings.force_output_type;


			std.stdio.write(format("[%s] %s <%s>",request_info["method"], request_info["path"], output_type));

			

			if (request_info["path"]=="/__server_info__") {
				return_content = format(__server_info__,internet_address.addrToString(this.internet_address.addr),internet_address.port);
				content_type = "text/plain";
			} else {
				if (std_file.exists(requested_path) && std_file.isFile(requested_path)){
					string file_ext = get_file_extension(baseName(requested_path));

					

					if (file_ext in output_type_extensions){
						output_type = output_type_extensions[file_ext];
					}


					if (file_ext in output_type_content_types) {
						content_type = output_type_content_types[file_ext];
						write(content_type);
					}

					return_content = generate_from_file(output_type,requested_path);

				} else if(std_file.exists(requested_path) && std_file.isDir(requested_path)){
					return_content = format("Directory %s\n\n",requested_path);
					if(server_settings.list_dir){
						foreach (std_file.DirEntry entry; std_file.dirEntries(requested_path, std_file.SpanMode.shallow)) {
							return_content ~= entry.name ~ "\n";
						}
					}
				} else {
					return_content = "Requested File is not founded";
					status_code = "404 NOT FOUND";
				}
			}

			std.stdio.write(" - ",status_code,"\n");
			client.send(return_http_result(status_code,return_content,content_type));
			client.close();
		}
	}

	~this() {
		this.stop();
	}
}

void print_help(string run_name) {
	writef(`SPG Server (SPG version %.4f)

Usage: %s [arguments]

Arguments:
	--help: Prints this text and exits
	--serve-dir: Directory to serve files
	--port: Server Port value
	--output-type: Forces given resource to generated as selected output type
	--content-type: Forces Content-Type header in HTTP Result to given input`,__version__,run_name);
}

void main(string[] args){
	ushort port = 80;
	string serve_dir = ".";

	bool help_text_arg = get_arg("--help",args);
	string serve_dir_arg = get_value_arg("--serve-dir",args);
	string output_type_arg = get_value_arg("--output-type",args);
	string content_type_arg = get_value_arg("--content-type",args);

	if (serve_dir_arg != "") {
		serve_dir = serve_dir_arg;
	}

	if (check_value_arg("--port",args)){
		ushort port_arg = get_value_arg("--port",args).to!ushort;
	} else {
		ushort port_arg = 0;
	}	

	if (help_text_arg) {
		print_help(args[0]);
		exit(0);
	}


	SPGServer spg_server = new SPGServer(new InternetAddress(port),serve_dir);
	
	if (output_type_arg != "") {
		try {
			spg_server.server_settings.force_output_type_flag = true;
			spg_server.server_settings.force_output_type = to!OutputType(output_type_arg);
		} catch (Exception e){
			error(format("Unable to set output type '%s': %s",output_type_arg,e.msg));
		}
	}

	if (content_type_arg != "") {
		spg_server.server_settings.force_content_type_flag = true;
		spg_server.server_settings.force_content_type = content_type_arg;
	}

	spg_server.start();
}
