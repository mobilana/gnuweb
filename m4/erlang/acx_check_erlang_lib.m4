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
         dnl check is the application or library
         if [[ -f $liberldir/$libpath/ebin/$1.app ]]; then
             ERLANG_APPS="$ERLANG_APPS $libpath"
             AC_SUBST(ERLANG_APPS)
         else
             ERLANG_LIBS="$ERLANG_LIBS $libpath"
             AC_SUBST(ERLANG_LIBS)
         fi
         rm -f conftest.out
         
         dnl check is this is an application or library
         dnl AC_RUN_IFELSE(
         dnl    [AC_LANG_PROGRAM([], [
         dnl       Start = fun(A, S) ->
         dnl          case application:start(A) of
         dnl             ok -> true;
         dnl             {error, {already_started, _}} -> true;
         dnl             {error, {not_started, D}} -> 
         dnl                case S(D,S) of
         dnl                   true  -> S(A,S);
         dnl                   false -> false
         dnl                end;
         dnl             _ -> false
         dnl          end
         dnl       end,
         dnl       case Start([$1], Start) of
         dnl          true  -> halt(0);
         dnl          false -> halt(1)
         dnl       end]
         dnl    )],
         dnl    [
         dnl       dnl this is an application
         dnl       ERLANG_APPS="$ERLANG_APPS $libpath"
         dnl       AC_SUBST(ERLANG_APPS)
         dnl    ],
         dnl    [
         dnl       dnl this is an library
         dnl       ERLANG_LIBS="$ERLANG_LIBS $libpath"
         dnl       AC_SUBST(ERLANG_LIBS)
         dnl    ]
         dnl )
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
