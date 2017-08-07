VERSION=$(shell cat VERSION)
BUILD_DIR=build
SRC_DIR=src
REDIST_NAME=OpenChariot-$(VERSION)-redist
INJECT_HEADER=$(SRC_DIR)/toolchain/octoolchain-inject-header

clean:
	-rm -rf "$(BUILD_DIR)"
	-rm -rf "$(REDIST_NAME)"
	-rm -rf "$(REDIST_NAME).tar.gz"
	cd src/doc ; make clean

prep: clean
	@# setup the build directory for use
	mkdir -p $(BUILD_DIR)
	cp -r $(SRC_DIR)/* $(BUILD_DIR)
	cp CHANGELOG $(BUILD_DIR)
	cp CONTRIBUTORS $(BUILD_DIR)
	cp LICENSE $(BUILD_DIR)
	cp README.rst $(BUILD_DIR)
	cp install.pl $(BUILD_DIR)
	cp uninstall.pl $(BUILD_DIR)

headers: prep
	@# inject the shared sh header into all of the ocutil files
	for f in $(BUILD_DIR)/core/bin/ocutil-* ; do $(INJECT_HEADER) "$$f" ; done

groom-build: prep
	@# clean-up junk from the build directory
	-find $(BUILD_DIR) -type f -name ".*.sw*" -exec rm "{}" \;
	rm -rf $(BUILD_DIR)/toolchain

.PHONY build: headers groom-build
	@# build OpenChariot, but don't generate docs or a release tarball

redist: build doc
	@# Build redist tarball with HTML format documentation only
	rm -rf "$(BUILD_DIR)/doc/build"
	mv "$(BUILD_DIR)" "$(REDIST_NAME)"
	tar cvfpz "$(REDIST_NAME).tar.gz" "$(REDIST_NAME)"
	mv "$(REDIST_NAME)" "$(BUILD_DIR)"

redist-pdf: doc-pdf doc
	@# Build redist tarball with both HTML and PDF format documentation
	rm -rf "$(BUILD_DIR)/doc/build"
	mv "$(BUILD_DIR)" "$(REDIST_NAME)"
	tar cvfpz "$(REDIST_NAME).tar.gz" "$(REDIST_NAME)"
	mv "$(REDIST_NAME)" "$(BUILD_DIR)"

doc: prep
	@# Build HTML documentation, this just requires Sphinx
	cd "$(BUILD_DIR)/doc" ; make html
	mv "$(BUILD_DIR)/doc/build/html" "$(BUILD_DIR)/doc/html"

doc-pdf: prep
	@# build PDF documentation, requires LaTeX
	cd "$(BUILD_DIR)/doc" ; make latexpdf
	mv "$(BUILD_DIR)/doc/build/latex/OpenChariot.pdf" "$(BUILD_DIR)/doc/manual.pdf"
