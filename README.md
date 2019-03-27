# BA Timo

## Debugging

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

# Ausblick

* Integrate event handling system in meterpreter where  we can hook specific functions (like in apache2). (e.g function systemcall or function sendOutgoingpackage)

* What happens if extension is unloaded in the middle of beeing used, normaly then meterpreter connection would cut out. Would need backup transport for that