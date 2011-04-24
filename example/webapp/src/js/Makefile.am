#
# define sources of libhello
libhello_SRC = hello/he.js hello/lo.js

#
# define target libhello
pkgdata_DATA  = libhello.js
webjs_SCRIPTS = libhello.yc.js libhello.$(VERSION).yc.js
CLEANFILES    = $(pkgdata_DATA) $(webjs_SCRIPTS)

@MAKE_GNUWEB@

