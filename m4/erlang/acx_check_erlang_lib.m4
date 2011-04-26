dnl @synopsis AX_CHECK_ERLANG_LIB(lib, [,action-if-found], [,action-if-not-found])
dnl
dnl @category erlang
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_CHECK_ERLANG_LIB],[
   m4_pushdef([LIB], $1)
   AC_MSG_CHECKING([for Erlang $1])
   
   AC_LANG_PUSH(Erlang)
   AC_RUN_IFELSE(
      [AC_LANG_PROGRAM([],[
         case code:lib_dir("[$1]") of
         {error, bad_name} ->
            halt(1);
         Lib ->
         	Root = code:lib_dir(),
         	Name = string:sub_string(Lib, length(Root) + 2),
            file:write_file("conftest.out", Name),
            halt(0)
         end]
      )],
      [
         dnl erlang lib is found
         libpath=`cat conftest.out`
         have_[]LIB[]="yes"
         AC_SUBST(have_[]LIB[])
         rm -f conftest.out
         
         dnl check is this is an application or library
         AC_RUN_IFELSE(
            [AC_LANG_PROGRAM([], [
               case application:start([$1]) of
                  ok ->
                     halt(0);
                  {error,{already_started, _}} ->
                     halt(0);
                  _ ->
                     halt(1)
               end]
            )],
            [
               dnl this is an application
               ERLANG_APPS="$ERLANG_APPS $libpath"
               AC_SUBST(ERLANG_APPS)
            ],
            [
               dnl this is an library
               ERLANG_LIBS="$ERLANG_LIBS $libpath"
               AC_SUBST(ERLANG_LIBS)
            ]
         )
         AC_MSG_RESULT([yes])
         ifelse([$2], , :, [$2])
      ],
      [
         dnl erlang lib is not found
         have_[]LIB[]="no"
         rm -f conftest.out
         AC_MSG_RESULT([no])
         ifelse([$2], , AC_ERROR($1 not found), [$3])
      ]
   )
   AC_LANG_POP(Erlang)
   m4_popdef([LIB])
])
