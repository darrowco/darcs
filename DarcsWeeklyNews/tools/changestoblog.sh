#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 entry"
  exit 1
fi

chmod u+x ./toblog.pl
pandoc -f markdown -t html $1 | ./toblog.pl $1 > entry.html
