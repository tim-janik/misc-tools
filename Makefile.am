# Redistributable under GNU GPLv3 or later: http://www.gnu.org/licenses/gpl.html

ACLOCAL_AMFLAGS = -I autotools
cache_files     =
cache_deps      =
man_MANS        = $(man_targets)
EXTRA_DIST=
CLEANFILES=
MAINTAINERCLEANFILES=

# == wikihtml2man.py ==
bin_SCRIPTS = wikihtml2man.py
cache_deps += wikihtml2man.py
EXTRA_DIST += wikihtml2man.py

# == wikihtml2man.1 ==
man_targets = wikihtml2man.1
cache_files += cache/wikihtml2man.1
wikihtml2man-check: wikihtml2man.1
	@ grep -q '\.TH.*WIKIHTML2MAN' wikihtml2man.1 ; eval "$$TSTDIAGNOSE"
check: wikihtml2man-check

# == man generation ==
%.1: @MAINTAINER_MODE_TRUE@ cache/%.1
	$(srcdir)/wikihtml2man.py $< >xgen-$@
	mv xgen-$@ $@ ; rm -f xgen-$@
EXTRA_DIST += $(man_targets)
CLEANFILES += $(man_targets)

# == online cache ==
cache/: ; mkdir -p $@
$(cache_files): $(cache_deps) | cache/
	curl -sfS http://testbit.eu/$(@F)?action=render >$(@D)/xgen-$(@F)
	mv $(@D)/xgen-$(@F) $@ ; rm -f $(@D)/xgen-$(@F)
CLEANFILES += @MAINTAINER_MODE_TRUE@ $(cache_files)
clean-local: @MAINTAINER_MODE_TRUE@ ; rm -rf cache/

# == Test Utilities ==
export MAKE_TARGET_FILE = $(@F)
export FAILOK           = FAIL  OK
export TSTDIAGNOSE = _e=$$?; tstdiagnose() { printf '  CHECK  %-64s%s\n' "$${1:-$$MAKE_TARGET_FILE}:" \
                                "$${FAILOK:$$(($$_e?0:6)):6}"; [ $$_e = 0 ] || exit $$_e; }; tstdiagnose
# == buglist.py ==
bin_SCRIPTS += buglist
PYCONFIGVARS = "PKG_VERSION" : "${VERSION}"
buglist: buglist.py Makefile.am
	$(AM_V_GEN)
	$(Q) sed <$< >xgen-$(@F)                        \
	  -e '1,1s|#!/usr/bin/env python\([0-9]\+\(\.[0-9]\+\)\?\)\?|#!${PYTHON}|' \
	  -e '1,24s|^ *#@PKGINSTALL_CONFIGVARS_IN24LINES@|  ${PYCONFIGVARS}|'
	$(Q) chmod +x xgen-$(@F)
	$(Q) cp -p xgen-$(@F) $@ && rm -f xgen-$(@F)
EXTRA_DIST += buglist.py
buglist-installcheck:
	$(Q) buglist --bug-tracker-list | grep -qF gcc ; eval "$$TSTDIAGNOSE"
installcheck-local: buglist-installcheck
buglist-check-fd:  ; @ echo      1 | ./buglist.py fd   | grep -q "Optimizations" ; eval "$$TSTDIAGNOSE"
buglist-check-gb:  ; @ echo 598490 | ./buglist.py gb   | grep -q "Beast.*Guile" ; eval "$$TSTDIAGNOSE"
buglist-check-gcc: ; @ echo  50456 | ./buglist.py gcc  | grep -q "attributes.*templates" ; eval "$$TSTDIAGNOSE"
buglist-check-libc:; @ echo  12894 | ./buglist.py libc | grep -q "systemd" ; eval "$$TSTDIAGNOSE"
buglist-check-mb:  ; @ echo   6791 | ./buglist.py mb   | grep -q "context.*menu" ; eval "$$TSTDIAGNOSE"
buglist-check-moz: ; @ echo 489834 | ./buglist.py moz  | grep -q "DXR" ; eval "$$TSTDIAGNOSE"
buglist-check-xm:  ; @ echo    830 | ./buglist.py xm   | grep -q "MonoDevelop.*MacOS" ; eval "$$TSTDIAGNOSE"
check: buglist-check-fd buglist-check-gb buglist-check-gcc buglist-check-libc buglist-check-mb buglist-check-moz buglist-check-xm

# == ChangeLog ==
ChangeLog: $(shell $(srcdir)/mkrelease.sh commit-stamps)
	$(srcdir)/mkrelease.sh ChangeLog
noinst_DATA = ChangeLog
EXTRA_DIST += ChangeLog mkrelease.sh

# == Release Rules ==
release-news:
	@$(srcdir)/mkrelease.sh news
release-check:
	@echo "Checking for unlisted contributors..."
	@$(srcdir)/mkrelease.sh contributors -X -B timj
release-upload: ChangeLog
	$(srcdir)/mkrelease.sh upload -U dist.testbit.eu:dist/testbit-tools/ -E configure.ac:TESTBIT_TOOLS_REVISION
.PHONY: release-news release-check release-upload
