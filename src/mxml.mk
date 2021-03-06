# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mxml
$(PKG)_WEBSITE  := http://www.msweet.org/projects.php?Z3
$(PKG)_DESCR    := Mini-XML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9
$(PKG)_CHECKSUM := cded54653c584b24c4a78a7fa1b3b4377d49ac4f451ddf170ebbc8161d85ff92
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.msweet.org/files/project3/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.msweet.org/downloads.php?L+Z3' | \
    $(SED) -n 's,.*<a href="files.*mxml-\([0-9\.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' libmxml.a
    $(MAKE) -C '$(1)' -j 1 install-libmxml.a
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/mxml.h'  '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/mxml.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-mxml.exe' \
        `'$(TARGET)-pkg-config' mxml --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
