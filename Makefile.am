# Redistributable under GNU GPLv3 or later: http://www.gnu.org/licenses/gpl.html

ACLOCAL_AMFLAGS = -I autotools
cache_files     =
cache_deps      =
man_MANS        = $(man_targets)
MYBUILDFAY      = $(shell /bin/sh $(top_srcdir)/buildfay.sh $(1))
COMMIT_STAMPS   = $(call MYBUILDFAY, commit-stamps) $(top_srcdir)/buildfay.sh
REVISION        = $(call MYBUILDFAY, describe)
bin_SCRIPTS=
EXTRA_DIST=
CLEANFILES=
MAINTAINERCLEANFILES=
Q = $(if $(findstring 1, $(V)) ,, @)

SHCONFIGVARS = MYPACKAGE="${PACKAGE_NAME}"; MYVERSION="${VERSION}"; MYREVISION="$(REVISION)"
PYCONFIGVARS = "PACKAGE" : "${PACKAGE}", "PACKAGE_NAME" : "${PACKAGE_NAME}", \
               "VERSION" : "${VERSION}", "REVISION"     : "$(REVISION)"

# == buildfay ==
bin_SCRIPTS += buildfay
buildfay: buildfay.sh $(COMMIT_STAMPS)
	$(AM_V_GEN)
	$(Q) sed <$< >xgen-$(@F)                        \
	  -e '1,24s|^ *#@PKGINSTALL_CONFIGVARS_IN24LINES@|  ${SHCONFIGVARS}|'
	$(Q) chmod +x xgen-$(@F)
	$(Q) cp -p xgen-$(@F) $@ && rm -f xgen-$(@F)
EXTRA_DIST += buildfay.sh
CLEANFILES += buildfay
buildfay-installcheck:
	$(Q) buildfay --help | grep -qF ChangeLog ; eval "$$TSTDIAGNOSE"
installcheck-local: buildfay-installcheck
buildfay-check-describe: ; @ ./buildfay describe   | grep -q "[0-9]\..*-" ; eval "$$TSTDIAGNOSE"
check: buildfay-check-describe

# == wikihtml2man.py ==
bin_SCRIPTS += wikihtml2man
wikihtml2man: wikihtml2man.py $(COMMIT_STAMPS)
	$(AM_V_GEN)
	$(Q) sed <$< >xgen-$(@F)                        \
	  -e '1,1s|#!/usr/bin/env python\([0-9]\+\(\.[0-9]\+\)\?\)\?|#!${PYTHON}|' \
	  -e '1,24s|^ *#@PKGINSTALL_CONFIGVARS_IN24LINES@|  ${PYCONFIGVARS}|'
	$(Q) chmod +x xgen-$(@F)
	$(Q) cp -p xgen-$(@F) $@ && rm -f xgen-$(@F)
EXTRA_DIST += wikihtml2man.py
CLEANFILES += wikihtml2man
cache_deps += wikihtml2man.py
wikihtml2man-installcheck:
	$(Q) wikihtml2man --version | grep -qF wikihtml2man ; eval "$$TSTDIAGNOSE"
installcheck-local: wikihtml2man-installcheck

# == wikihtml2man.1 ==
man_targets = wikihtml2man.1
cache_files += cache/wikihtml2man.1
wikihtml2man-check: wikihtml2man.1
	@ grep -q '\.TH.*WIKIHTML2MAN' $(srcdir)/wikihtml2man.1 ; eval "$$TSTDIAGNOSE"
check: wikihtml2man-check

# == man generation ==
%.1: @MAINTAINER_MODE_TRUE@ cache/%.1
	$(AM_V_GEN)
	$(Q) $(srcdir)/wikihtml2man.py $< >xgen-$@
	$(Q) mv xgen-$@ $@ ; rm -f xgen-$@
EXTRA_DIST += $(man_targets)
CLEANFILES += $(man_targets)

# == online cache ==
cache/: ; @ mkdir -p $@
$(cache_files): $(cache_deps) | cache/
	$(AM_V_GEN)
	$(Q) curl -sfS http://testbit.eu/$(@F)?action=render >$(@D)/xgen-$(@F)
	$(Q) mv $(@D)/xgen-$(@F) $@ ; rm -f $(@D)/xgen-$(@F)
clean-local: @MAINTAINER_MODE_TRUE@ ; rm -rf cache/

# == Test Utilities ==
export MAKE_TARGET_FILE = $(@F)
export FAILOK           = FAIL  OK
export TSTDIAGNOSE = _e=$$?; tstdiagnose() { printf '  CHECK  %-64s%s\n' "$${1:-$$MAKE_TARGET_FILE}:" \
                                "$${FAILOK:$$(($$_e?0:6)):6}"; [ $$_e = 0 ] || exit $$_e; }; tstdiagnose
# == buglist.py ==
bin_SCRIPTS += buglist
buglist: buglist.py $(COMMIT_STAMPS)
	$(AM_V_GEN)
	$(Q) sed <$< >xgen-$(@F)                        \
	  -e '1,1s|#!/usr/bin/env python\([0-9]\+\(\.[0-9]\+\)\?\)\?|#!${PYTHON}|' \
	  -e '1,24s|^ *#@PKGINSTALL_CONFIGVARS_IN24LINES@|  ${PYCONFIGVARS}|'
	$(Q) chmod +x xgen-$(@F)
	$(Q) cp -p xgen-$(@F) $@ && rm -f xgen-$(@F)
EXTRA_DIST += buglist.py
CLEANFILES += buglist
buglist-installcheck:
	$(Q) buglist --bug-tracker-list | grep -qF gcc ; eval "$$TSTDIAGNOSE"
installcheck-local: buglist-installcheck
buglist-check-fd:  ; @ echo      1 | ./buglist fd   | grep -q "Optimizations" ; eval "$$TSTDIAGNOSE"
buglist-check-gb:  ; @ echo 598490 | ./buglist gb   | grep -q "Beast.*Guile" ; eval "$$TSTDIAGNOSE"
buglist-check-gcc: ; @ echo  50456 | ./buglist gcc  | grep -q "attributes.*templates" ; eval "$$TSTDIAGNOSE"
buglist-check-libc:; @ echo  12894 | ./buglist libc | grep -q "systemd" ; eval "$$TSTDIAGNOSE"
buglist-check-mb:  ; @ echo   6791 | ./buglist mb   | grep -q "context.*menu" ; eval "$$TSTDIAGNOSE"
buglist-check-moz: ; @ echo 489834 | ./buglist moz  | grep -q "DXR" ; eval "$$TSTDIAGNOSE"
buglist-check-xm:  ; @ echo    830 | ./buglist xm   | grep -q "MonoDevelop.*MacOS" ; eval "$$TSTDIAGNOSE"
check: buglist-check-fd buglist-check-gb buglist-check-gcc buglist-check-libc buglist-check-mb buglist-check-moz buglist-check-xm

# == ChangeLog & Release Rules ==
noinst_DATA = ChangeLog
ChangeLog: $(COMMIT_STAMPS) ./buildfay
	$(AM_V_GEN)
	$(Q) ./buildfay ChangeLog
EXTRA_DIST += ChangeLog
CLEANFILES += ChangeLog
release-news: ./buildfay
	@./buildfay news
release-check: ./buildfay
	@echo "Checking for unlisted contributors..."
	@./buildfay contributors -X -B timj
release-upload: ChangeLog ./buildfay
	./buildfay upload -U dist.testbit.eu:dist/testbit-tools/ -E configure.ac:TESTBIT_TOOLS_REVISION
.PHONY: release-news release-check release-upload
