# SPG

**Simple Page Generator**

## Requirements
* Latest DMD (Digital Mars Compiler)
* Gnu Make

## Installing

```shell
git clone https://github.com/kerem3338/spg
make build

spg --version
```

## Features
* Defining blocks
* Writing to 3 different output type.
* Somewhat useful web server

## Using The Server
### Building
```shell
make build_server
```
or
```shell
make just_build_server
```
if you already builded spg executable

### Running
simply run the server executable.

    spg_server.exe
    
**To check server information you can visit `/__server_info__`**

*NOTE*: If requested file is contains errors server will be closed with error code.
*NOTE*: Server is designed for debugging or small testing.

## Planned Features / Things
- [ ] Variables
- [ ] Importing blocks from another file
- [ ] The web server should not exit entirely when an error occurs.

## Example Syntax

    *setblock:title**
    <h1>Navigation</h1>
    *endblock:title**
    
    *writeblock:title**


For better documentation please check [DOCUMENTATION.md](DOCUMENTATION.md) 
For more examples you can check the [examples](./examples) folder