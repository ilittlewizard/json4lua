# json4lua
 A flexible, lightweight, and high-performance JSON library for lua

## Advantages
* Highly compatible: Could be executed with any Lua version
* Tiny: Around 130~ sloc, 3.4 KB
* Flexible: Provided options for user to controls the program's behavior
* Free and Free: A free library that can be used, modified and distributed freely

## Features
* Encode Lua tables into JSON (JavaScript Object Notation) representation
* Decode JSON (JavaScript Object Notation) representation into Lua tables (Coming soon)

## Usage
```
friend1 = {}
friend1.name = "Sam"
friend1.age = 13

friend2 = {}
friend2.name = "Ben"
friend2.age = 12

person = {}
person.name = "Tom"
person.age = 12
person.friends = {friend1, friend2}

json = json4lua.encode(person)
print(json) -- {"name":"Tom","age":12,"friends":[{"name":"Sam","age":13},{"name":"Ben","age":12}]}
```
## Docs: Overview
`json4lua`: A table that contains all the functions for this library

`json4lua.config`: A table that contains all the configs for this library

`json4lua.internal`: A table that contains all the internal functions for this library

### Docs: `json4lua`
`json4lua.encode(obj)`: A function used to encode Lua tables into JSON representation

### Docs: `json4lua.config`
`json4lua.config.ignore_unsupported_datatypes`: Determine whether the program should ignore (skip) values that cannot be encoded into JSON representation. 

`json4lua.config.ignore_nonstring_keys`: Determine whether the program should ignore (skip) non-string keys. 

`json4lua.config.ignore_nontable_inputs`: Determine whether the program should return `nil` if a non-table value is passed into `json4lua.encode(obj)`
