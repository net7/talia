#!/bin/bash
if test -z $1 ; then
	DEFAULT_VERSION=1.3.1
else
	DEFAULT_VERSION=$1
fi

filename=jruby-$DEFAULT_VERSION.tgz

cd vendor
curl http://cloud.github.com/downloads/net7/talia/$filename > $filename
tar xvzf $filename
rm $filename
