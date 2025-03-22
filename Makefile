# Makefile for SPG

ifeq ($(OS), Windows_NT)
	executable_name = spg.exe
	delete_command = del
else
# Assume it's a Unix-like system
	executable_name = spg
	delete_command = rm
endif

build:
	dmd spg.d -of=$(executable_name)

clean:
# Not the best way to do.
	$(delete_command) $(executable_name)
