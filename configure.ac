# Testbit.eu/Tools configure.ac					-*- Autoconf -*-
# Redistributable under GNU GPLv3 or later: http://www.gnu.org/licenses/gpl.html

# == Package Setup ==
AC_INIT([Testbit.eu/Tools],
	m4_esyscmd(./mkrelease.sh shellvar configure.ac:TESTBIT_TOOLS_VERSION),
	[http://testbit.eu/],
	[testbit-tools],
	[http://testbit.eu/Tools])
# Package definitions pushed to be available for --help
m4_divert_text([NOTICE],[
  TESTBIT_TOOLS_YEAR=11		# increment when ABI or API changes
  TESTBIT_TOOLS_MONTH=05	# increment when ABI or API changes
  TESTBIT_TOOLS_REVISION=0	# increment while ABI compatible, otherwise reset
  TESTBIT_TOOLS_VERSION=$TESTBIT_TOOLS_YEAR.$TESTBIT_TOOLS_MONTH.$TESTBIT_TOOLS_REVISION
  debug_default=minimum
])
# Autoconf, automake, etc setup
AC_CONFIG_MACRO_DIR([autotools])
AC_CONFIG_AUX_DIR([autotools])
AC_PREREQ([2.67])
AC_PROG_MAKE_SET
AC_CONFIG_HEADER(configure.h)
AM_INIT_AUTOMAKE([1.10 check-news dist-bzip2 no-dist-gzip -Wno-portability])
AM_MAINTAINER_MODE # maintainer-mode might require exotic tools
AM_SILENT_RULES([yes])

# Configure arguments.
AC_ARG_ENABLE(debug,           [  --enable-debug=no/minimum/yes  turn on debugging],,enable_debug=$debug_default)

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_CPP
AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
