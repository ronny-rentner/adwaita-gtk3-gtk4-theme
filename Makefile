.ONESHELL:
.SHELLFLAGS += -e

DIR       := ${CURDIR}
BUILD_DIR := ${DIR}/build
DEST_DIR  := ${DIR}/dest

update:
	cd ${DIR}
	git pull
	#cd ${DIR}/libadwaita
	#git pull

build:
	cd ${DIR}
	meson -Dprefix="/tmp/adwaita-gtk3-gtk4" build
	ninja -C build install

buildgtk4:
	cd ${DIR}/libadwaita
	meson . _build
	ninja -C _build

all: update build buildgtk4

.PHONY: clean
clean:  cleangtk4
	rm -rf "${BUILD_DIR}"

.PHONY: cleangtk4
cleangtk4:
	rm -rf ${DIR}/libadwaita/_build
