#!/bin/sh

# First parameter: shell or start, depending on if you want the shell or the server
# Second parameter: Optional, may give a jruby version if multiple installed in vendor/

pd=`dirname "$0"`
prog_dir=`cd $pd && pwd`

if test -n "$2"; then
	JRUBY_VERSION=$2
fi

if test -n "$JRUBY_VERSION"; then
	jruby_special_version=-$JRUBY_VERSION
else
	jruby_special_version=''
fi

jruby_dir=vendor/jruby$jruby_special_version

# We start the shell that the user is currently running
shell=$SHELL

if test -z $SHELL ; then
    # Fall back to bash
    shellbq='/bin/bash'
fi

export PATH=$prog_dir/$jruby_dir/bin:$prog_dir/$jruby_dir/lib/ruby/gems/1.8/bin:$PATH
export PATH=$prog_dir/lib/scripts:$PATH
export PATH=$prog_dir/vendor/plugins/talia_core/bin:$PATH
export PS1="talia-bash \w >> "

case $1 in
	shell)
		echo ;
		echo "Opening JRuby environment for Talia (using $shell and jruby from $jruby_dir)..."
		export TALIA_SHELL=true
		$shell -i
	;;
	start)
		jruby script/server
	;;
	*)
	echo "Usage: $0 [start|shell]"
	;;
esac
