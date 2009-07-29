#!/bin/bash
if test -z $1 ; then
	DEFAULT_VERSION=1.3.1
else
	DEFAULT_VERSION=$1
fi

filename=jruby-$DEFAULT_VERSION.tgz

if test -e vendor/jruby-$DEFAULT_VERSION ; then
  echo Version $DEFAULT_VERSION already installed
  exit 1
fi

cd vendor
curl http://cloud.github.com/downloads/net7/talia/$filename > $filename
tar xvzf $filename
rm $filename

if test -L jruby ; then
  rm jruby
fi

ln -s jruby-$DEFAULT_VERSION jruby

echo jruby $DEFAULT_VERSION installed
