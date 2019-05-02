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
[LUA vs Ruby](http://lua-users.org/wiki/LuaComparison)
[Other tools for example Cobaltstrike](https://www.cobaltstrike.com/help-malleable-c2)
[Other tools for example Encripto](https://www.encripto.no/en/downloads-2/tools/)

## Goals

1. Make extension which gives back what it gets in methods

1. Make extension load before initial connection 

2. Compile and test LUA outside of meterpreter

# Meterpreter

In order to include the malleable communication modifications on the Meterpreter where necessary. There are two major changes to the default Meterpreter, the initial config and a new transport.

[Meterpreter HTTPS Communication](https://blog.rapid7.com/2011/06/29/meterpreter-httphttps-communication/)
[Meterpreter detection by IPS](https://security.stackexchange.com/questions/147737/meterpreter-https-detected-by-ips)
[Domain Fronting with Meterpreter](https://beyondbinary.io/articles/domain-fronting-with-metasploit-and-meterpreter/)
[OJ Reeves Meterpreter Twitch tutorial](https://www.twitch.tv/ojreeves/videos)
[Staged vs stageless handlers](https://buffered.io/posts/staged-vs-stageless-handlers/)

## Communication

### Wireshark decrypting

[Display filters](https://wiki.wireshark.org/DisplayFilters)
[Wireshark SSL decrypting](https://wiki.wireshark.org/SSL)

### TLVs

[Explanation what are TLVs](https://buffered.io/posts/tlv-traffic-obfuscation/)
[Traffic obfuscation with TLVs](https://buffered.io/posts/tlv-traffic-obfuscation/)

### Malleable

`TODO`

## Initial config

In the file `config.h` is the structure of the config defined. Part of the config are parameters which are important for the initial connection to the client (e.g. transports(URL, Proxy), malleable_script).
The config structure is packed in a certain way through the command `#pragma pack(push, 1)` and `#pragma pack(pop)`. 
These commands have the effect, that `TODO`. (Byte alignment on stack, also Character encoding with bytes and stuff)
While the structure of the data is defined within Meterpreter itself, the config data is defined during the generation of the Meterpreter in the client.

## Malleable transport

[Multiple transports in meterpreter](https://ionize.com.au/multiple-transports-in-a-meterpreter-payload/)
[The in and outs of Meterpreter Transport](https://github.com/rapid7/metasploit-framework/wiki/The-ins-and-outs-of-HTTP-and-HTTPS-communications-in-Meterpreter-and-Metasploit-Stagers)

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

[Metasploit Framework Dev environment](https://github.com/rapid7/metasploit-framework/wiki/Setting-Up-a-Metasploit-Development-Environment)
[Logging in Metasploit](https://github.com/rapid7/metasploit-framework/wiki/How-to-log-in-Metasploit)

## Debugging

[Debugging Metasploit-Framework with ruby-debug-ide (source)](https://rubygems.org/gems/ruby-debug-ide/versions/0.6.0)
[How to debug Metasploit](http://www.andrej-mohar.com/debugging-metasploit-with-visual-studio-code-on-linux)

## LUA in Metasploit

[Rufus github](https://github.com/jmettraux/rufus-lua)
[Rufus-Win Github](https://github.com/ukoloff/rufus-lua-win)
[Ruby-Lua github](https://github.com/glejeune/ruby-lua)

## Building payloads with custom files

`TODO`

## Building handler with custom files

`TODO`

## Resource Script

[Rapid7 Blog about resource scripts](https://metasploit.help.rapid7.com/docs/resource-scripts)

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


## Meterpreter and Reverse Proxy

[How to reverse proxy and meterpreter](https://medium.com/@truekonrads/reverse-https-meterpreter-behind-apache-or-any-other-reverse-ssl-proxy-e898f9dfff54)
[Configuring Meterpreter with a https reverse proxy](https://ionize.com.au/reverse-https-meterpreter-and-empire-behind-nginx/)

### Encryption

[How to create encryption key](https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl)

### Use cases

`TODO`

### Usage

[Meterpreter reverse proxies](https://ionize.com.au/reverse-https-meterpreter-and-empire-behind-nginx/)

## LUA script en-/decoding Traffic

Script requirements for encoding and decoding traffic can be found [here](#LUA-scripting-for-malleable-traffic)

[Issue and example for NGINX buffers](https://github.com/openresty/lua-nginx-module/issues/1092#issuecomment-309081761)
[Openresty code examples](https://dchua.com/2017/01/01/supercharge-your-nginx-with-openresty-and-lua/)
[Header filter example NGINX](https://gist.github.com/ejlp12/b3949bb40e748ae8367e17c193fa9602)
[LUA response bodies with great Graphic!!!](https://jkzhao.github.io/2018/05/03/Lua-OpenResty%E4%BF%AE%E6%94%B9response-body/)


## NGINX

### Openresty

[Openresty Github](https://github.com/openresty/docker-openresty)
[LuaJT (used by openresty)](http://luajit.org/luajit.html)

### NGINX settings

[Digital ocean set up encryption on nginx](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-18-04)
[Cipher list for nginx settings (as seen in digital ocen doc)](https://cipherli.st/)
[Official NGINX Docs configuring servers](http://nginx.org/en/docs/http/configuring_https_servers.html)
[NGINX example server](https://www.nginx.com/resources/wiki/start/topics/examples/fullexample2/)
[Setting up NGINX reverse proxy](https://chase-seibert.github.io/blog/2011/12/21/nginx-ssl-reverse-proxy-tutorial.html#)

### NGINX Filter model / directives

[Openresty nginx directive diagram](https://github.com/openresty/lua-nginx-module#directives)

### NGINX Decoding pitfalls

`TODO` 

### NGINX Encoding pitfalls

`TODO` 

### LUA scripting for malleable traffic

[Cammel_case SnakeCase](https://www.reddit.com/r/lua/comments/1shtsg/is_camelcase_or_snake_case_more_common_in_lua/)

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
[LuaUnit - LUA testing framework which I use](https://github.com/bluebird75/luaunit)
[Property based testing](https://medium.com/criteo-labs/introduction-to-property-based-testing-f5236229d237)

The Meterpreter LUA script needs to implement a Encode and a Decode function. The OpenResty Decode function needs to be able to decode the output of the Meterpreter Encode Method. The OpenResty Encode function needs to return a value which the Meterpreter LUA script can decode.

### Directory Structure

/home/timo/Projects/bachelor/lua-testing/unit-tests/luaunit/timoTests/malleable_testing.lua
/home/timo/Projects/bachelor/lua-testing/unit-tests/luaunit/timoTests/openresty_malleable.lua

/home/timo/Projects/bachelor/lua-testing/unit-tests/luaunit/timoTests/scripts/ee5_base64.lua
/home/timo/Projects/bachelor/lua-testing/unit-tests/luaunit/timoTests/scripts/meterpreter_malleable.lua
/home/timo/Projects/bachelor/lua-testing/unit-tests/luaunit/timoTests/scripts/openresty_decode.lua
/home/timo/Projects/bachelor/lua-testing/unit-tests/luaunit/timoTests/scripts/openresty_encode.lua

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

### Misc sources

[C wcsdup (wide char string duplication)](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/strdup-wcsdup-mbsdup?view=vs-2019)
[Rapid7 developer diaries](https://www.rapid7.com/research/report/metasploit-development-diaries-q1-2019/)
[Python extension](https://github.com/rapid7/metasploit-framework/wiki/Python-Extension)
[Write a metasploit post module](https://github.com/rapid7/metasploit-framework/wiki/How-to-get-started-with-writing-a-post-module)
[Writing meterpreter extensions](https://www.scriptjunkie.us/2011/08/writing-meterpreter-extensions/)
[Evil NGINX alternative to openresty NGINX](https://github.com/kgretzky/evilginx2)
[TLV Traffic obfuscation](https://buffered.io/posts/tlv-traffic-obfuscation/)
[LUA docs (overview of functions)](http://pgl.yoyo.org/luai/i/luaL_loadstring)
[WINHTTP API Docs](https://docs.microsoft.com/en-us/windows/desktop/api/winhttp/nf-winhttp-winhttpsendrequest)
[Domain fronting with Meterpreter](https://beyondbinary.io/articles/domain-fronting-with-metasploit-and-meterpreter/)
[LUA string library examples](http://lua-users.org/wiki/StringLibraryTutorial)
[Meterpreter transport controll (Everything about transports)](https://github.com/rapid7/metasploit-framework/wiki/Meterpreter-Transport-Control)
[LUA Base64 decode example code](https://stackoverflow.com/questions/34618946/lua-base64-encode)
[LUA Base64 library I use](https://github.com/ErnieE5/ee5_base64)
[Nmap Base64 LUA implementation](https://github.com/nmap/nmap/blob/master/nselib/base64.lua)
[Microsoft Docs](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/strinc-wcsinc-mbsinc-mbsinc-l?view=vs-2019)

-----

# Word explanations

Server -> Meterpreter
Client -> Metasploit-Framework