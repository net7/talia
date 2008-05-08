#!/bin/bash
pd=`dirname "$0"`
prog_dir=`cd $pd && pwd`
jruby_dir="vendor/jruby-1.1.1"

export PATH=$prog_dir/$jruby_dir/bin:$PATH
export PS1="talia-bash \w >> "

case $1 in
	console)
		echo ;
		echo "Opening JRuby environment for Talia..."
		/bin/bash -i
	;;
	*)
		jruby script/server
	;;
esac