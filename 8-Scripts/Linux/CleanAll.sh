#!/bin/bash

echo "Emptying 0-Builds"

rm -rf ../../0-Builds/*

echo "Emptying Engine Builds"

rm -rf ../../1-Engine-Builds/Dev/sbox-public
rm -rf ../../1-Engine-Builds/Steam
rm -rf ../../1-Engine-Builds/Vanilla/sbox-public

echo "Emptying Projects"

rm -rf ../../2-Projects/*

echo "Emptying Documentation"

rm -rf ../../3-Documentation

echo "Done."
