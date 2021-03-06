dnl @synopsis ACX_INIT_SCRIPT
dnl
dnl Generates a INIT SCRIPT file
dnl 
dnl 
dnl @category erlang
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_INIT_SCRIPT],[
   printf "
ROOT=\`pwd\`
ERTS=\`ls \$ROOT | grep erts\`
ERL=\$ROOT/\$ERTS/bin/erl
RUN=\$ROOT/\$ERTS/bin/run_erl
CON=\$ROOT/\$ERTS/bin/to_erl
sed s,\x25FINAL_ROOTDIR\x25,\$ROOT, \$ROOT/\$ERTS/bin/erl.src > \$ROOT/\$ERTS/bin/erl

LOGDIR=\$ROOT/var/log
test -d \$LOGDIR || mkdir -p \$LOGDIR

RUNDIR=\$ROOT/var/run
test -d \$RUNDIR || mkdir -p \$RUNDIR

NODE=\`ls releases/*.rel | sed -n \"s,releases/\\(.*\\)\\.rel,\x5c\x31,p\"\`
LIVE=\`echo \'erlang:now().\' | \$CON \$RUNDIR/ 2>/dev/null \&\& echo live\`

case \"\$\x31\" in
    start)
        if [[ \"x\$LIVE\" == \"xlive\" ]]; then
            echo \"Node \$NODE is already running\"
	     else
            \$RUN -daemon \$RUNDIR/ \$LOGDIR/ \
                \"\$ERL -sname \$NODE \
                -boot \$ROOT/releases/@VSN@/start \
                -config \$ROOT/releases/@VSN@/sys\"
            echo \"Node \$NODE is started\"
        fi
        ;;

    stop)
        if [[ \"x\$LIVE\" == \"xlive\" ]]; then
            echo \'q().\' | \$CON \$RUNDIR/ 2>/dev/null
            echo \"Node \$NODE is terminated.\"
        else
            echo \"Node \$NODE is not alive\"
        fi
        ;;

    attach)
        if [[ \"x\$LIVE\" == \"xlive\" ]]; then
	         exec \$CON \$RUNDIR/
        else
            echo \"Node \$NODE is not alive\"
        fi
        ;;

    *)
        SCRIPT=\`basename \$\x30\`
        echo \"Usage: \$SCRIPT {start|stop|attach}\"
        exit 1
        ;;
esac
exit 0  

" > init.erlang


])
