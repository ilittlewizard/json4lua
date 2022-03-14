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
