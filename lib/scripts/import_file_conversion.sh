#!/bin/bash
ARGS_NUM=2

if [ $# -ne $ARGS_NUM  ]; then 
 echo "USAGE: $0 <catalog> <file>";
 exit;
fi;

sed -i -backup "s/\<siglum\>$1\-/\<siglum\>/g" $2 
sed -i "" "s/$1\-/$1\//g" $2 
