#!/bin/sh

# OpenChariot documentation build script

MAKE_CMD=make

if [ -e `which gmake` ] ; then
        MAKE_CMD=gmake
fi

cd src/doc

$MAKE_CMD html
mv build/html ../../html
