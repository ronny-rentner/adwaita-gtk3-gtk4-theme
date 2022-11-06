.ONESHELL:
.SHELLFLAGS += -e

DIR         := ${CURDIR}
BUILD_DIR   := ${DIR}/build
TARGET_DIR  := ${DIR}/target
RELEASE_DIR := ${DIR}/releases

GTK4_DIR             := ${DIR}/libadwaita
GTK4_BUILD_DIR       := ${GTK4_DIR}/_build
GTK4_PATCH_DIR       := ${TARGET_DIR}/share/themes/adw-gtk3/gtk-4.0
GTK4_PATCH_SRC_DIR   := ${GTK4_BUILD_DIR}/src/stylesheet
GTK4_DARK_PATCH_DIR  := ${TARGET_DIR}/share/themes/adw-gtk3-dark/gtk-4.0
GTK4_ASSETS_DIR      :=  ${GTK4_DIR}/src/stylesheet/assets

update:
	git pull
	git submodule update --recursive --remote

build:
	meson -Dprefix="${TARGET_DIR}" ${BUILD_DIR}
	ninja -C ${BUILD_DIR} install

gtk4build:
	cd ${GTK4_DIR}
	meson . ${GTK4_BUILD_DIR}
	ninja -C ${GTK4_BUILD_DIR}

gtk4patch:
	#light
	mkdir -p ${GTK4_PATCH_DIR}
	cp ${GTK4_PATCH_SRC_DIR}/defaults-light.css ${GTK4_PATCH_DIR}
	cp -R ${GTK4_ASSETS_DIR} ${GTK4_PATCH_DIR}
	echo "@import 'defaults-light.css';\n" |cat - ${GTK4_PATCH_SRC_DIR}/base.css >${GTK4_PATCH_DIR}/gtk.css
	#dark
	mkdir -p ${GTK4_DARK_PATCH_DIR}
	cp ${GTK4_PATCH_SRC_DIR}/defaults-dark.css ${GTK4_PATCH_DIR}
	cp -R ${GTK4_ASSETS_DIR} ${GTK4_DARK_PATCH_DIR}
	echo "@import 'defaults-dark.css';\n" |cat - ${GTK4_PATCH_SRC_DIR}/base.css >${GTK4_DARK_PATCH_DIR}/gtk.css

all: update build buildgtk4

.PHONY: clean
clean:  cleangtk4
	rm -rf "${TARGET_DIR}"
	rm -rf "${BUILD_DIR}"

.PHONY: cleangtk4
cleangtk4:
	rm -rf ${DIR}/libadwaita/_build
