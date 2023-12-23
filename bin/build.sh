#!/bin/bash -e

# This script publishes the KTex specification document to the web.

mkdir -p public
bun spec-md spec/KTex.md > public/index.html
