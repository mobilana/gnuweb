dnl @synopsis ACX_ERLANG
dnl
dnl Setup Erlang development  
dnl 
dnl @category erlang
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_ERLANG],[
   ACX_PREFIX

   ACX_SECTION([Erlang development runtime])
   AC_ARG_WITH(erlang, [  --with-erlang=PREFIX path to erlang runtime])
 
   if test -f conf2lib ; then
      CONF2LIB="\$(top_builddir)/conf2lib"
   else
      ACX_CHECK_PROG([conf2lib])
      cp $CONF2LIB conf2lib
      chmod 777 conf2lib
      CONF2LIB="\$(top_builddir)/conf2lib"
   fi
   AC_SUBST(CONF2LIB)
   
   erlang_path=$with_erlang:$with_erlang/bin:$PATH
   AC_PATH_PROG([ERLC],   [erlc],    [], [$erlang_path])
   AC_PATH_PROG([ERL],    [erl],     [], [$erlang_path])
   AC_PATH_PROG([ESCRIPT],[escript], [], [$erlang_path])
   
   if test "x$ERLC" == "x" ; then
      AC_ERROR("Erlang runtime not found.")
   fi
   if test "x$ERL"  == "x" ; then
      AC_ERROR("Erlang runtime not found.")
   fi
   
   AC_MSG_CHECKING([Erlang lib path])
   liberlroot=`$ERL -noshell -eval 'io:format("~s", [[code:lib_dir()]]),halt(0)'`
   if [[ "$?" -ne 0 ]] ; then
      AC_ERROR("Unable to resolve path.")
   fi
   AC_MSG_RESULT([$liberlroot])

   ACX_DEFINE_DIR([liberldir],    $liberlroot, [])
   ACX_DEFINE_DIR([pkgliberldir], $liberlroot, [$PACKAGE]-[$VERSION])
   ACX_DEFINE_DIR([pkglibprivdir], $liberlroot, [$PACKAGE]-[$VERSION]/priv)
   
   
   ACX_CHECK_ERLANG_LIB([erts])
   ACX_CHECK_ERLANG_LIB([kernel])
   ACX_CHECK_ERLANG_LIB([stdlib])
   
   ACX_SILENT_V([ERL])

   AMX_ERLANG
   ACX_INIT_SCRIPT 
   ACX_EUNIT
])
