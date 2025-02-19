#!/bin/bash

## VIASH START
par_input='/path/to/file'
par_output='output.txt'
meta_name='mycomp'
meta_functionality_name='mycomp'
meta_resources_dir='/tmp/viash_inject_mycomp17839327725427957864'
meta_executable='/tmp/viash_inject_mycomp17839327725427957864/mycomp'
meta_config='/tmp/viash_inject_mycomp17839327725427957864/.config.vsh.yaml'
meta_temp_dir='/tmp'
meta_cpus='123'
meta_memory_b='123'
meta_memory_kb='123'
meta_memory_mb='123'
meta_memory_gb='123'
meta_memory_tb='123'
meta_memory_pb='123'
meta_memory_kib='123'
meta_memory_mib='123'
meta_memory_gib='123'
meta_memory_tib='123'
meta_memory_pib='123'
## VIASH END

# sleep randomly between 1 and 5 seconds
sleep $((1 + RANDOM % 5))

echo "Copying files from $par_input to $par_output"
cp -r "$par_input" "$par_output"
