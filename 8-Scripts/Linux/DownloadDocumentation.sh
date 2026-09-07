#!/bin/bash

echo "Downloading all docs from github /CSEliot/sbox-get-docs-api ..."

git clone https://github.com/CSEliot/sbox-get-docs-api.git ../../3-Documentation/

echo "Downloading done?"

echo "Updating and downloading api ... "

../../3-Documentation/update-all.sh

echo "Updating done?"

echo "Done."
