#!/bin/bash
CACHE_DIR=/var/lib/gitit/cache

for f in $DARCS_FILES; do
  echo "Removing cache entry: $CACHE_DIR/$f"
  if [ -e $CACHE_DIR/$f ]; then rm $CACHE_DIR/$f; fi
done

MAX_SINCE_LAST_TAG=100
PATCHES_SINCE_LAST_TAG=`darcs changes --count --from-tag='.'`

if [ "$PATCHES_SINCE_LAST_TAG" -gt "$MAX_SINCE_LAST_TAG" ]; then
  ZDATE=`date +"%Y-%m-%d" -u`
  darcs tag "$ZDATE (autotag)"
fi
