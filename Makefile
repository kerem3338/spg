# Makefile for SPG

ifeq ($(OS), Windows_NT)
	executable_name = spg.exe
	server_executable_name = spg_server.exe
	delete_command = del
	delete_command_arg = /p

else
# Assume it's a Unix-like system
	executable_name = spg.exe
	server_executable_name = spg_server.exe
	delete_command = rm
	delete_command_arg = -i
endif

build:
	dmd spg_lib.d spg.d -of=$(executable_name) -I.

build_server:
	dmd spg_lib.d spg_server.d -of=$(server_executable_name) -I.

build_all: build build_server

clean:
# Not the best way to do.
	$(delete_command) $(executable_name)
	$(delete_command) $(server_executable_name)

	$(delete_command) $(delete_command_arg) *.obj
