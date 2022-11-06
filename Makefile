.ONESHELL:
.SHELLFLAGS += -e

DIR         := ${CURDIR}
BUILD_DIR   := ${DIR}/build
TARGET_DIR  := ${DIR}/tmp/adwaita-gtk3-gtk4
RELEASE_DIR := ${DIR}/releases

update:
	git pull
	git submodule update --recursive --remote

build:
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
	rm -rf "${TARGET_DIR}"

.PHONY: cleangtk4
cleangtk4:
	rm -rf ${DIR}/libadwaita/_build
