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
* Writing to 3 diffrent output type. 

## Planned Features
- [ ] variables
- [ ] importing blocks from another file

## Example Syntax

    *setblock:title**
    <h1>Navigation</h1>
    *endblock:title**
    
    *writeblock:title**


For better documentation please check [DOCUMENTATION.md](DOCUMENTATION.md) 
For more examples you can check the [examples](./examples) folder