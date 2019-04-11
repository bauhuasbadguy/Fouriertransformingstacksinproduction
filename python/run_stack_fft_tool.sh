#!/usr/bin/env bash

version=`cat VERSION`

echo $version

docker build -t stack_fft:$version .

docker run \
-v "$(pwd)/test_piece:/input" \
-v "$(pwd)/output:/output" \
stack_fft:$version