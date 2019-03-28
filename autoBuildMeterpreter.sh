#!/bin/sh
while inotifywait -e create /mnt/hgfs/Shared_Folder/bachelor/vs_output/; do
	echo "delete old dlls in metasploit directory"
	echo "copy from shared to metasploit"
	echo "run msfvenom and write file into shared folder"
done
