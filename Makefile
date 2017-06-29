VERSION=$(shell cat VERSION)
BUILD_DIR=build
SRC_DIR=src
REDIST_NAME=OpenChariot-$(VERSION)-redist
INJECT_HEADER=$(SRC_DIR)/toolchain/octoolchain-inject-header

clean:
	-rm -rf "$(BUILD_DIR)"
	-rm -rf "$(REDIST_NAME)"
	-rm -rf "$(REDIST_NAME).tar.gz"

prep: clean
	mkdir -p $(BUILD_DIR)
	cp -r $(SRC_DIR)/* $(BUILD_DIR)

headers: prep
	for f in $(BUILD_DIR)/core/bin/ocutil-* ; do $(INJECT_HEADER) "$$f" ; done

groom-build: prep
	-find $(BUILD_DIR) -type f -name ".*.sw*" -exec rm "{}" \;

redist: headers groom-build
	mv "$(BUILD_DIR)" "$(REDIST_NAME)"
	tar cvfz "$(REDIST_NAME).tar.gz" "$(REDIST_NAME)"
	mv "$(REDIST_NAME)" "$(BUILD_DIR)"

