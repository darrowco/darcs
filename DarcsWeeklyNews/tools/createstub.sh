#!/bin/bash

if [ $# -ne 0 ]; then
  echo "This script doesn't take any arguments"
  exit 1
fi

if [ ! -e lastchange ]; then
  echo "Please create a file 'lastchange' containing the short name of" 1>&2
  echo "last weeks' most recent patch" 1>&2
  exit 1
fi

rm -f lastchange.old
cp lastchange lastchange.old
darcsdir=http://darcs.net/reviewed
cat template > stub
darcs changes --no-interactive --from-patch "`cat lastchange`" --xml --repo ${darcsdir} | ./parsechanges >> stub
darcs changes --no-interactive --last=1 --xml --repo ${darcsdir} | grep name | sed -e 's/.*<name>//' -e 's!</name>.*!!' > lastchange

cat stub
echo "I have also saved this to 'stub' and updated 'lastchange'" 1>&2
