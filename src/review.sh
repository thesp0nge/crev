#!/bin/bash
# review command
source ./src/config.sh

if [ $# -eq 0 ]; then
    echo "usage: review.sh packagename"
    exit 0
fi
