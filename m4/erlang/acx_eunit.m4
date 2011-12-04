dnl @synopsis ACX_EUNIT
dnl
dnl Integrates EUNIT with GNU Make test framework
dnl 
dnl 
dnl @category erlang
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_EUNIT],[
   printf "
   
TEST=\`basename \$\x31\`
FILE=\${TEST\x25.*}
erlc \$\x31 && \
erl -sname eunit@localhost -pa ../../*/ebin \\
-eval \"R = case eunit:test(\$FILE, [[verbose]]) of ok -> 0; _ -> 1 end, timer:apply_after(100, erlang, halt, [[R]]).\"
rm \$FILE.beam

   " > eunit
   chmod u+x eunit
])