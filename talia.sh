#!/bin/bash
pd=`dirname "$0"`
prog_dir=`cd $pd && pwd`
jruby_dir="vendor/jruby-1.1.3"

export PATH=$prog_dir/$jruby_dir/bin:$prog_dir/$jruby_dir/lib/ruby/gems/1.8/bin:$PATH
export PS1="talia-bash \w >> "

case $1 in
	shell)
		echo ;
		echo "Opening JRuby environment for Talia..."
		/bin/bash -i
	;;
	start)
		jruby script/server
	;;
	*)
	echo "Usage: $0 [start|shell]"
	;;
esac
