#!/bin/bash
rm -r /home/timo/Projects/bachelor/metasploit_framework/data/meterpreter/*; 
scp -r mogwai@192.168.42.128:C:/Users/Mogwai/Documents/GitHub/metasploit-payloads/c/meterpreter/output/x64/ /home/timo/Projects/bachelor/metasploit_framework/data/meterpreter/;
mv /home/timo/Projects/bachelor/metasploit_framework/data/meterpreter/x64/* /home/timo/Projects/bachelor/metasploit_framework/data/meterpreter/; 
./msfconsole -r ~/Projects/bachelor/msf.rc 
