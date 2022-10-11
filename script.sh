#!/bin/sh

# check if docs/ is empty
if [ -z "$(ls -A docs/)" ]; then
   echo "Empty"
else
   echo "Not Empty"
   echo "Remove All Contents"
   # remove contents
   rm -r docs/*
fi

echo "Copy Contents from ../website/out/ to docs/"
cp -a ../website/out/. docs/