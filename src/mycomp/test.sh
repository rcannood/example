#!/bin/bash

echo "Generating test data"
echo "Hello World" > test.txt

echo "Running script"
"$meta_executable" --input test.txt --output test.out

echo "Checking output"
if [ ! -f test.out ]; then
  echo "Output file not found"
  exit 1
fi

# check contents
if [ "$(cat test.out)" != "Hello World" ]; then
  echo "Output file content does not match"
  exit 1
fi

echo "Test passed"
exit 0
