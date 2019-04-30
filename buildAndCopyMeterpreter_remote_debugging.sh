#!/bin/bash
rm -r /home/timo/Tools/bachelor/metasploit-framework/data/meterpreter/*; 
scp -r mogwai@192.168.42.128:C:/Users/Mogwai/Documents/GitHub/metasploit-payloads/c/meterpreter/output/x64/ /home/timo/Tools/bachelor/metasploit-framework/data/meterpreter/;
mv /home/timo/Tools/bachelor/metasploit-framework/data/meterpreter/x64/* /home/timo/Tools/bachelor/metasploit-framework/data/meterpreter/; 
/opt/ruby/lib/ruby/gems/2.6.0/gems/ruby-debug-ide-0.6.1/bin/rdebug-ide  --host 127.0.0.1 --port 1234 -- ~/Tools/bachelor/metasploit-framework/msfconsole
