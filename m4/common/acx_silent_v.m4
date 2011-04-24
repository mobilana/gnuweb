dnl @synopsis ACX_SILENT_V
dnl
dnl helper macro to device silencer
dnl 
dnl @depend 
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_SILENT_V],[
   m4_pushdef([T], $1)
   dnl TODO: fix an issue if silent rule is not enabled
   [AM_V_][]T[]='$(am__v_[]T[]_$(V))'
   am__v_[]T[]_='$(am__v_[]T[]_$(AM_DEFAULT_VERBOSITY))'
   am__v_[]T[]_0='@echo "   []T[]   [\t]" $[@]$$[@];'
   AC_SUBST([AM_V_][]T[])
   AC_SUBST(am__v_[]T[]_)
   AC_SUBST(am__v_[]T[]_0)
   m4_popdef([T])
])
