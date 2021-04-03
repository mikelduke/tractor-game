#!/bin/bash

echo 'assembling to temp'

mkdir -p dist
mkdir -p temp

mkdir -p temp/assets
cp -rf src/* temp/
cp -rf src/assets/ temp/
