#!/bin/bash

PWD=$(pwd)

echo "Running in $PWD"

if [[ $PWD != *Community-Patch-Kit ]] then
  echo "Incorrect directory, script should be run from repository root."
	exit -1
fi

rm -rf dist
mkdir -p dist
cp -r src dist/

SEARCH_DIR="src"
INPUT_FILE="scripts/modinfo.xml"
OUTPUT_FILE="dist/Community Patch Kit (v 1).modinfo"

xml=""

while IFS= read -r file; do
  checksum=$(md5sum "$file" | awk '{ print toupper($1) }')
  entry="    <File md5=\"${checksum}\" import=\"1\">${file}</File>"

  # Append the entry to the xml variable
  xml="${xml}${entry}\n"
done < <(find "$SEARCH_DIR" -type f -name "*.lua")

sed "s|__FILES__|$xml|" "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE"