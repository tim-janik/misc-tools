#!/bin/sh
# Redistributable under GNU GPLv3 or later: http://www.gnu.org/licenses/gpl.html

PROJECT=TESTBIT-TOOLS
TEST_TYPE=-f
FILE=wikihtml2man.py
AUTOMAKE=automake
AUTOMAKE_VERSION=1.10
ACLOCAL=aclocal
AUTOCONF=autoconf
AUTOCONF_VERSION=2.64
AUTOHEADER=autoheader
LIBTOOLIZE=libtoolize
LIBTOOLIZE_VERSION=2.2.6
CONFIGURE_OPTIONS=

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
ORIGDIR=`pwd`
cd $srcdir
DIE=0

# check build directory
test $TEST_TYPE $FILE || {
	echo
	echo "$0: must be invoked in the toplevel directory of $PROJECT"
	DIE=1
}

# check_version(given,required) compare two versions in up to 6 decimal numbers
check_version()
{
  # number pattern
  N="\([^:]*\)"
  # remove leading non-numbers, seperate by :
     GIVEN=`echo "$1:0:0:0:0:0:0" | sed -e 's/^[^0-9]*//' -e 's/[^0-9]\+/:/g'`
  REQUIRED=`echo "$2:0:0:0:0:0:0" | sed -e 's/^[^0-9]*//' -e 's/[^0-9]\+/:/g'`
  # extract 6 numbers from $GIVEN into ac_v?
  eval `echo "$GIVEN"    | sed "s/^$N:$N:$N:$N:$N:$N.*$/ac_v1=\1 ac_v2=\2 ac_v3=\3 ac_v4=\4 ac_v5=\5 ac_v6=\6/" `
  # extract 6 numbers from $REQUIRED into ac_r?
  eval `echo "$REQUIRED" | sed "s/^$N:$N:$N:$N:$N:$N.*$/ac_r1=\1 ac_r2=\2 ac_r3=\3 ac_r4=\4 ac_r5=\5 ac_r6=\6/" `
  # do the actual comparison (yielding 1 on success)
  ac_vm=`expr \( $ac_v1 \> $ac_r1 \) \| \( \( $ac_v1 \= $ac_r1 \) \& \(          \
               \( $ac_v2 \> $ac_r2 \) \| \( \( $ac_v2 \= $ac_r2 \) \& \(         \
                \( $ac_v3 \> $ac_r3 \) \| \( \( $ac_v3 \= $ac_r3 \) \& \(        \
                 \( $ac_v4 \> $ac_r4 \) \| \( \( $ac_v4 \= $ac_r4 \) \& \(       \
                  \( $ac_v5 \> $ac_r5 \) \| \( \( $ac_v5 \= $ac_r5 \) \& \(      \
                   \( $ac_v6 \>= $ac_r6 \)                                       \
                  \) \)  \
                 \) \)   \
                \) \)    \
               \) \)     \
              \) \)      `
  #echo "Given:    ac_v1=$ac_v1 ac_v2=$ac_v2 ac_v3=$ac_v3 ac_v4=$ac_v4 ac_v5=$ac_v5 ac_v6=$ac_v6"
  #echo "Required: ac_r1=$ac_r1 ac_r2=$ac_r2 ac_r3=$ac_r3 ac_r4=$ac_r4 ac_r5=$ac_r5 ac_r6=$ac_r6"
  #echo "Result:   $ac_vm"
  test $ac_vm = 1
}

# check for automake
if check_version "`$AUTOMAKE --version 2>/dev/null | sed 1q`" $AUTOMAKE_VERSION ; then
	:	# all fine
elif check_version "`$AUTOMAKE$AUTOMAKE_VERSION --version 2>/dev/null | sed 1q`" $AUTOMAKE_VERSION ; then
	AUTOMAKE=$AUTOMAKE$AUTOMAKE_VERSION
	ACLOCAL=$ACLOCAL$AUTOMAKE_VERSION
elif check_version "`$AUTOMAKE-$AUTOMAKE_VERSION --version 2>/dev/null | sed 1q`" $AUTOMAKE_VERSION ; then
	AUTOMAKE=$AUTOMAKE-$AUTOMAKE_VERSION
	ACLOCAL=$ACLOCAL-$AUTOMAKE_VERSION
else
	echo "You need to have $AUTOMAKE (version >= $AUTOMAKE_VERSION) installed to compile $PROJECT."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/automake"
	DIE=1
fi

# check for autoconf
if check_version "`$AUTOCONF --version 2>/dev/null | sed 1q`" $AUTOCONF_VERSION ; then
	:	# all fine
elif check_version "`$AUTOCONF$AUTOCONF_VERSION --version 2>/dev/null | sed 1q`" $AUTOCONF_VERSION ; then
	AUTOCONF=$AUTOCONF$AUTOCONF_VERSION
	AUTOHEADER=$AUTOHEADER$AUTOCONF_VERSION
elif check_version "`$AUTOCONF-$AUTOCONF_VERSION --version 2>/dev/null | sed 1q`" $AUTOCONF_VERSION ; then
	AUTOCONF=$AUTOCONF-$AUTOCONF_VERSION
	AUTOHEADER=$AUTOHEADER-$AUTOCONF_VERSION
else
	echo "You need to have $AUTOCONF (version >= $AUTOCONF_VERSION) installed to compile $PROJECT."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/autoconf"
	DIE=1
fi

# check for libtool
check_version "`$LIBTOOLIZE --version 2>/dev/null | sed 1q`" $LIBTOOLIZE_VERSION || {
	echo "You need to have $LIBTOOLIZE (version >= $LIBTOOLIZE_VERSION) installed to compile $PROJECT."
	echo "Get the source tarball at http://ftp.gnu.org/gnu/libtool"
	DIE=1
}

# sanity test aclocal
$ACLOCAL --version >/dev/null 2>&1 || {
	echo "Unable to run $ACLOCAL though $AUTOMAKE is available."
	echo "Please correct the above error first."
	DIE=1
}

# sanity test autoheader
$AUTOHEADER --version >/dev/null 2>&1 || {
	echo "Unable to run $AUTOHEADER though $AUTOCONF is available."
	echo "Please correct the above error first."
	DIE=1
}

# bail out as scheduled
test "$DIE" -gt 0 && exit 1

# sanity check $ACLOCAL_FLAGS
if test -z "$ACLOCAL_FLAGS"; then
	acdir=`$ACLOCAL --print-ac-dir`
        m4tests="glib-2.0.m4"
	for file in $m4tests ; do
		[ ! -f "$acdir/$file" ] && {
			echo "WARNING: failed to find $file in $acdir"
			echo "         If this file is installed in /some/dir, you may need to set"
			echo "         the ACLOCAL_FLAGS environment variable to \"-I /some/dir\","
			echo "         or install $acdir/$file."
		}
	done
fi

echo "Cleaning configure cache..."
rm -rf autom4te.cache/

echo "Running: $LIBTOOLIZE"
$LIBTOOLIZE --force || exit $?

echo "Running: $ACLOCAL $ACLOCAL_FLAGS"
$ACLOCAL $ACLOCAL_FLAGS	|| exit $?

echo "Running: $AUTOHEADER"
$AUTOHEADER || exit $?

echo "Running: $AUTOMAKE"
case $CC in
*xlc | *xlc\ * | *lcc | *lcc\ *) am_opt=--include-deps;;
esac
$AUTOMAKE -Wno-portability --force-missing --add-missing $am_opt || exit $?

echo "Running: $AUTOCONF"
$AUTOCONF || exit $?

cd $ORIGDIR
echo "Running: $srcdir/configure $CONFIGURE_OPTIONS $@"
$srcdir/configure --enable-maintainer-mode $CONFIGURE_OPTIONS "$@" || exit $?
