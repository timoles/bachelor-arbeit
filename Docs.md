# Meterpreter

In order to include the malleable communication modifications on the Meterpreter where necessary. There are two major changes to the default Meterpreter, the initial config and a new transport.

## Malleable communication

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

## NGINX Filter model

`TODO` 

## NGINX Decoding pitfalls

`TODO` 

## NGINX Encoding pitfalls

`TODO` 

# LUA scripting for malleable traffic

`TODO` 

## Basic structure (required default methods)

# Decisions

## Extension vs Transport

`TODO` 

# Lookahead

* Make it look like legitimate website

* Scripting engine/language

-----

# Word explanations

Server -> Meterpreter
Client -> Metasploit-Framework