# BA Timo

# Goals

Meterpreter output in base64 encoded encrypted "viewstate"

## Debugging

Copy new dlls into metasploit directory
```
rm ~/Tools/bachelor_metasploit/metasploit-framework/data/meterpreter/*.dll; cp /mnt/hgfs/Shared_Folder/bachelor/vs_output/x64/* ~/Tools/bachelor_metasploit/metasploit-framework/data/meterpreter/; ./msfconsole -r ~/Projects/bachelor/msf.rc
```

Run metasploit auto create payload and start handlers
```bash
 ./msfconsole -r ~/Projects/bachelor/msf.rc 
```

Write .dll(s) into `/home/timo/Tools/bachelor_metasploit/metasploit-framework/data/meterpreter`
When creating payload it uses the ones in this directory first

# Links

[Maligno tool](https://www.encripto.no/en/downloads-2/tools/)

[Meterpreter wishlist](https://github.com/rapid7/metasploit-framework/wiki/Meterpreter-Wishlist#communications-evasion)

[Cobaltstrike mallable](https://www.cobaltstrike.com/help-malleable-c2)

https://github.com/rapid7/mettle

[Build tutorial](https://www.youtube.com/watch?v=de-UYWnafow)

[Run extension before connection is established](https://github.com/rapid7/metasploit-framework/wiki/Python-Extension#stageless-initialisation)

[Create extensions](https://github.com/rapid7/metasploit-payloads/tree/master/c/meterpreter#creating-extensions)

[Explanation what are TLVs](https://buffered.io/posts/tlv-traffic-obfuscation/)

[Meterpreter reverse proxies](https://ionize.com.au/reverse-https-meterpreter-and-empire-behind-nginx/)

# Goals

1. Make extension which gives back what it gets in methods

1. Make extension load before initial connection 

2. Compile and test LUA outside of meterpreter

# Compile extension

1. Follow this tutorial for the dll creation [Create extensions](https://github.com/rapid7/metasploit-payloads/tree/master/c/meterpreter#creating-extensions) but carefull, I had to copy a working extension because an error during linking (file not found) was thrown

# TODO UPDATE THIS LIST

2. Following files are most likely needed 
```bash
./data/meterpreter/ext_server_malleable.x64.dll # This one is our compiled dll which will be injected into meterpreter
./lib/rex/post/meterpreter/ui/console/command_dispatcher/malleable.rb # In here we define commands (in meterpreter session "help") and helptext we also call functions here (which are defined in the "extensions" directory). Also I think some UI cleanup/manage stuff

./lib/rex/post/meterpreter/extensions/malleable/malleable.rb # # In here we implement the logic for the functions we can call through the UI. Also we send the actual requests to the server

./lib/rex/post/meterpreter/extensions/malleable/tlv.rb # I think this has to do with obfuscating traffic. Data saved in TLV variables are obfuscated to some extend. TLV can be appended to Requests and sent out
```

2. Delete old meterpreter dll, copy new into metasploit directory, start msfconsole with resource file
```
rm ~/Tools/bachelor_metasploit/metasploit-framework/data/meterpreter/*.dll; cp /mnt/hgfs/Shared_Folder/bachelor/vs_output/x64/* ~/Tools/bachelor_metasploit/metasploit-framework/data/meterpreter/; ./msfconsole -r ~/Projects/bachelor/msf.rc
```

3. Check if generate function with extinit works

4. Check if loading function in metasploit works

5. Check if loading function works in meterpreter

# Ausblick

* Integrate event handling system in meterpreter where  we can hook specific functions (like in apache2). (e.g function systemcall or function sendOutgoingpackage) Queues with event priorities and so on

* What happens if extension is unloaded in the middle of beeing used, normaly then meterpreter connection would cut out. Would need backup transport for that

* "Real" usable web application with reverse proxy for extra stealth


# Notes

Meterpreter is always called the server and metasploit always called the client

Set log level in Metasploit `setg LogLevel 3`

Open all important client side files
```bash
subl ./lib/rex/post/meterpreter/extensions/malleable/tlv.rb
subl ./lib/rex/post/meterpreter/extensions/malleable/malleable.rb
subl ./lib/rex/post/meterpreter/ui/console/command_dispatcher/malleable.rb
``` 

# Options to handle the obfuscation problem

* DLL inject and overwrite sending functions (what about tlvs? Can we do this?)

* Create clone of http meterpreter (most likely least initial effort, but need to manually update in the future)

* Change original meterpreter code and make a check if extension is loaded

* Create own transport (Probably wrong place to change these things)

* is there a functionality which is checked called beforehand?

* ask OJreeves for an idea

# reverse proxy

Decisions: evilginx(1\|2) or openresty (vor nachteile usw....)

Decided for openresty
```
sudo docker run -v ./nginx.vh.default.conf:/etc/nginx/conf.d/default.conf openresty/openresty:bionic
sudo docker run -v ./nginx.vh.default.conf:/etc/nginx/conf.d/default.conf -p 80:80 openresty/openresty:bionic
```

# Problems

* Extint not working (preload extension before any communication)

* XOR key applied to packets, looks suspicious

* We cant use tlv functionality, to send the obfuscated packet we need to hook right before the packet send function

* elua for better performance, because LUA needs a while to close. (In BA write about multiple possibilities and why I've chosen LUA)

* Lua script error handling with automatic fallback 

* Get loaded commands/DLL/extensions

* Check advanced options in payload (e.g. allowdirectreverseProxy)

* SSL

* Stageless problems? especially with reverse proxy

* malicously crafted packets which will get parsed by lua

* which lua version has openresty and which one has meterpreter?

# Bisherige Schritte

1. Basic functionality Extension zum laufen gebracht
2. Lua zum laufen gebracht
3. Reverse proxy aufgesetzt (openresty)
