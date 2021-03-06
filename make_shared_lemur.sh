#!/bin/bash
LIB=/usr/local/lib

##########################################
if [ "$(whoami)" != "root" ]; then
    echo "You must run this script as root."
    exit
fi

if [ -e "$LIB/liblemur.a" ]; then
    echo found liblemur.a
else
    echo
    echo "Cannot find liblemur.a!"
    echo "Find it, then specify the library's directory"
    echo "location on the first line of $0"
    echo
    exit
fi

TMPDIR=$(mktemp -d)
cd $TMPDIR
echo Copying $LIB/liblemur.a to $TMPDIR ....
cp $LIB/liblemur.a .

echo Extracting liblemur....
ar x liblemur.a
rm main.o

echo Creating dynamically shared library...
g++ -shared *.o -o liblemur.so.0.0.0

echo Removing any old copies of library in $LIB...
rm -f $LIB/liblemur.so*

echo Installing library...
cp liblemur.so.0.0.0 $LIB
ln -s $LIB/liblemur.so.0.0.0 $LIB/liblemur.so.0
ln -s $LIB/liblemur.so.0.0.0 $LIB/liblemur.so

echo Removing temp dir $TMPDIR...
rm -rf $TMPDIR

echo Running ldconfig to update cache of dynamic linked libs...
ldconfig

echo Done.