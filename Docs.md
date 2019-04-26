# Bachelor Docs

# TOC
<!-- MarkdownTOC -->

- [Idea](#idea)
- [Goals](#goals)
- [Meterpreter](#meterpreter)
- [Communication](#communication)
	- [TLVs](#tlvs)
	- [Malleable](#malleable)
- [Initial config](#initial-config)
- [Malleable transport](#malleable-transport)
- [DLL injection](#dll-injection)
- [Debugging](#debugging)
- [Building Meterpreter](#building-meterpreter)
- [Handling/Implementing LUA scripts in a robust way](#handlingimplementing-lua-scripts-in-a-robust-way)
- [Meterpreter detection through communication](#meterpreter-detection-through-communication)
- [Metasploit-Framework](#metasploit-framework)
- [Building payloads with custom files](#building-payloads-with-custom-files)
- [Building handler with custom files](#building-handler-with-custom-files)
- [Resource Script](#resource-script)
- [Implementation of the LUA script setting](#implementation-of-the-lua-script-setting)
	- [Implementing options](#implementing-options)
	- [Bugfix Bufferoverflow](#bugfix-bufferoverflow)
	- [Changing the datastructure to be able to add a LUA script](#changing-the-datastructure-to-be-able-to-add-a-lua-script)
	- [Max config size workaround](#max-config-size-workaround)
- [Reverse Proxy](#reverse-proxy)
- [Meterpreter and Reverse Proxy](#meterpreter-and-reverse-proxy)
	- [Use cases](#use-cases)
	- [Usage](#usage)
- [LUA script en-/decoding Traffic](#lua-script-en-decoding-traffic)
- [NGINX Filter model / directives](#nginx-filter-model--directives)
- [NGINX Decoding pitfalls](#nginx-decoding-pitfalls)
- [NGINX Encoding pitfalls](#nginx-encoding-pitfalls)
- [LUA scripting for malleable traffic](#lua-scripting-for-malleable-traffic)
- [Basic structure \(required default methods\)](#basic-structure-required-default-methods)
	- [Example Meterpreter `encode` function which returns the input buffer unchanged](#example-meterpreter-encode-function-which-returns-the-input-buffer-unchanged)
	- [Example Meterpreter `decode` function which returns the input buffer unchanged](#example-meterpreter-decode-function-which-returns-the-input-buffer-unchanged)
- [Decisions](#decisions)
- [Extension vs Transport](#extension-vs-transport)
- [Similar products on the market](#similar-products-on-the-market)
- [Lookahead](#lookahead)
- [Word explanations](#word-explanations)

<!-- /MarkdownTOC -->


## Idea

[Meterpreter wishlist](https://github.com/rapid7/metasploit-framework/wiki/Meterpreter-Wishlist#communications-evasion)

## Goals

1. Make extension which gives back what it gets in methods

1. Make extension load before initial connection 

2. Compile and test LUA outside of meterpreter

# Meterpreter

In order to include the malleable communication modifications on the Meterpreter where necessary. There are two major changes to the default Meterpreter, the initial config and a new transport.

## Communication

`TODO`

### TLVs

[Explanation what are TLVs](https://buffered.io/posts/tlv-traffic-obfuscation/)

### Malleable

`TODO`

## Initial config

In the file `config.h` is the structure of the config defined. Part of the config are parameters which are important for the initial connection to the client (e.g. transports(URL, Proxy), malleable_script).
The config structure is packed in a certain way through the command `#pragma pack(push, 1)` and `#pragma pack(pop)`. 
These commands have the effect, that `TODO`. (Byte alignment on stack, also Character encoding with bytes and stuff)
While the structure of the data is defined within Meterpreter itself, the config data is defined during the generation of the Meterpreter in the client.

## Malleable transport

An additional transport which implements the logic for malleable transport was created. This newly implemented transport is used as soon as the server recieves a malleable URL. A malleable URL is identified by the URLs scheme http(s)m (e.g. httpm://mogwailabs.de, httpsm://mogwailabs.de). During the transport creation the URL is normalized to a typical http protocol, as defined in ISO `TODO`, scheme  Generally speaking the malleable transport has a lot of similarities to the already implemented and established `server_transport_winhttp.h`. It's main differences are the implementation of a LUA library and an encode/decode function for communication packages. The encode/decode functions implement a transport package transformation via a LUA script. 
These malleable functions are called just before the WinAPI call to send out the package.

## DLL injection

`TODO` 

## Debugging


`TODO` 

## Building Meterpreter

In order to use the modified Meterpreter within the client it needs to be compiled. Compilation specifications can be seen on the official Metasploit Rapid7 documentation. 
The during the compilation created `.dll` files need to be placed within the source of the Metasploit-Framework in order to generate a Meterpreter payload with the modifications.

## Handling/Implementing LUA scripts in a robust way

`TODO` 

## Meterpreter detection through communication
 
`TODO`

# Metasploit-Framework

`TODO`

## Building payloads with custom files

`TODO`

## Building handler with custom files

`TODO`

## Resource Script

`TODO`

## Implementation of the LUA script setting

`TODO` difficulties, what do we need to do?

### Implementing options

`TODO`

### Bugfix Bufferoverflow

`TODO`

### Changing the datastructure to be able to add a LUA script

`TODO`

### Max config size workaround

`TODO`

# Reverse Proxy

`TODO` 

## Meterpreter and Reverse Proxy

### Use cases

`TODO`

### Usage

[Meterpreter reverse proxies](https://ionize.com.au/reverse-https-meterpreter-and-empire-behind-nginx/)

## LUA script en-/decoding Traffic

Script requirements for encoding and decoding traffic can be found [here](#LUA-scripting-for-malleable-traffic)

## NGINX Filter model / directives

[Openresty nginx directive diagram](https://github.com/openresty/lua-nginx-module#directives)

## NGINX Decoding pitfalls

`TODO` 

## NGINX Encoding pitfalls

`TODO` 

# LUA scripting for malleable traffic

`TODO` 

## Basic structure (required default methods)

The LUA script which is used in the Meterpreter is __required__ to implement at least an encode and a decode function. These functions need to at least return a `nil`.

The LUA script submitted to the Meterpreter cannot be longer then 4096 characters long.

### Example Meterpreter `encode` function which returns the input buffer unchanged

```lua
function encode(s)
	return s
end
```

### Example Meterpreter `decode` function which returns the input buffer unchanged

```lua
function decode(s)
	return s
end
```

-----

An additional LUA script is needed for the OpenResty reverse Proxy. The `decode.lua` and `encode.lua` are respective counterparts to the `encode` and `decode` functions. Therefore they need to be coded in a way so identical objects are going in and out -- TODO describe better

## Unit Tests

[LUA test suite docs](http://www.lua.org/tests/)

# Decisions

## Extension vs Transport

### Transport which uses Malleable Extension

| Pro  | Con  |
|---|---|
| LUA Library is external dependency | Need to rewrite/change existing HTTP transport |
| Easy LUA script setting (directly build for it)  | Harded to do for initial transport (what is loaded first)  |
| Extended functionality easily implementable  |  |
| more logical from developer (system architecture) and user view || 

### Pure transport

| Pro  | Con  |
|---|---|
| Distinct isolation malleable/normal | Need to rewrite transport add/change functionality in client and server in order to add malleable script|
| Can use already implemented transport fallback | Dynamic script setting not working|
| Everything handled through transport interface (intuitive) | LUA library is always sent|

# Similar products on the market

* [Cobaltstrike mallable](https://www.cobaltstrike.com/help-malleable-c2)

* [Maligno tool](https://www.encripto.no/en/downloads-2/tools/)

* [Rapid7 mettle](https://github.com/rapid7/mettle)

# Lookahead

* Integrate event handling system in meterpreter where  we can hook specific functions (like in apache2). (e.g function systemcall or function sendOutgoingpackage) Queues with event priorities and so on

* What happens if extension is unloaded in the middle of beeing used, normaly then meterpreter connection would cut out. Would need backup transport for that

* "Real" usable web application with reverse proxy for extra stealth

* Scripting engine/language

-----

# Word explanations

Server -> Meterpreter
Client -> Metasploit-Framework