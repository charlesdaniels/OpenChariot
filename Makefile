PREFIX=/usr/local

install: getconfig process-gitspool

getconfig: src/core/bin/ocutil-getconfig
	cp "$<" "$(PREFIX)/bin"

process-gitspool: src/core/bin/ocutil-getconfig
	cp "$<" "$(PREFIX)/bin"

update-be: src/core/bin/ocutil-update-be
	cp "$<" "$(PREFIX)/bin"
