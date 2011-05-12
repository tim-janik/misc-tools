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
