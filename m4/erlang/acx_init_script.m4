dnl @synopsis ACX_INIT_SCRIPT
dnl
dnl Generates a INIT SCRIPT file
dnl 
dnl 
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_INIT_SCRIPT],[
   printf "
ROOT=\`pwd\`
ERTS=\`ls $ROOT | grep erts\`
ERL=\$ROOT/\$ERTS/bin/erl
sed s,\x25FINAL_ROOTDIR\x25,\$ROOT, \$ROOT/\$ERTS/bin/erl.src > \$ROOT/\$ERTS/bin/erl

\$ERL -boot \$ROOT/releases/$VERSION/start -config \$ROOT/releases/$VERSION/sys

" > init.erlang


])
