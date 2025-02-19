#!/bin/bash

# sleep randomly between 1 and 5 seconds
sleep $((1 + RANDOM % 5))

echo "Copying files from $par_input to $par_output"
cp -r "$par_input" "$par_output"
