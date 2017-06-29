PREFIX=/usr/local

# Note: PREFIX/bin must be in PATH!

install: getconfig process-gitspool update-be update-docs update-gitstats update-www-perm validate-dep validate-dirs gitarrconf update-git-arr spooler generate-index update-dumb-http
	ocutil-validate-dep
	ocutil-validate-dirs

redist:
	cd .. && tar cfz OpenChariot/OpenChariot-redist.tar.gz OpenChariot/Makefile OpenChariot/README.rst OpenChariot/src/

clean:
	-rm OpenChariot-*.tar.gz

uninstall:
	-rm $(PREFIX)/bin/ocutil-*

purge: uninstall
	@# like uninstall, but also purge configs
	-rm -rf $(PREFIX)/etc/openchariot

getconfig: src/core/bin/ocutil-getconfig
	cp "$<" "$(PREFIX)/bin"
	echo '# OpenChariot installation prefix (generated by installer)' >> "$(PREFIX)/bin/ocutil-getconfig"
	echo "echo 'export OC_PREFIX=$(PREFIX)'" >> "$(PREFIX)/bin/ocutil-getconfig"

process-gitspool: src/core/bin/ocutil-process-gitspool
	cp "$<" "$(PREFIX)/bin"

update-be: src/core/bin/ocutil-update-be
	cp "$<" "$(PREFIX)/bin"

update-docs: src/core/bin/ocutil-update-docs
	cp "$<" "$(PREFIX)/bin"

update-gitstats: src/core/bin/ocutil-update-gitstats
	cp "$<" "$(PREFIX)/bin"

update-www-perm: src/core/bin/ocutil-update-www-perm
	cp "$<" "$(PREFIX)/bin"

validate-dep: src/core/bin/ocutil-validate-dep
	cp "$<" "$(PREFIX)/bin"

validate-dirs: src/core/bin/ocutil-validate-dirs
	cp "$<" "$(PREFIX)/bin"

spooler: src/core/bin/ocutil-spooler
	cp "$<" "$(PREFIX)/bin"

update-git-arr: src/core/bin/ocutil-update-git-arr
	cp "$<" "$(PREFIX)/bin"

generate-index: src/core/bin/ocutil-generate-index
	cp "$<" "$(PREFIX)/bin"

update-dumb-http: src/core/bin/ocutil-update-dumb-http
	cp "$<" "$(PREFIX)/bin"

confdir:
	mkdir -p "$(PREFIX)/etc/openchariot"

gitarrconf: src/etc/git-arr.conf confdir
	cp "$<" "$(PREFIX)/etc/openchariot/"
	# insert git directory from config
	$$(src/core/bin/ocutil-getconfig) && echo "path = $$OC_GIT_DIR/." >> "$(PREFIX)/etc/openchariot/git-arr.conf"


