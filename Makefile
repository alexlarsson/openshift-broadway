PREFIX=$(shell pwd)/root

export ACLOCAL_FLAGS=-I $(PREFIX)/share/aclocal -I /usr/share/aclocal
export ACLOCAL_PATH=$(PREFIX)/share/aclocal
export CPLUS_INCLUDE_PATH=$(PREFIX)/include
export C_INCLUDE_PATH=$(PREFIX)/include
export DYLD_FALLBACK_LIBRARY_PATH=$(PREFIX)/lib
export GI_TYPELIB_PATH=$(PREFIX)/lib/girepository-1.0:/usr/lib/girepository-1.0
export LDFLAGS=-L$(PREFIX)/lib 
export LD_LIBRARY_PATH=$(PREFIX)/lib
export PATH=$(PREFIX)/bin:/usr/lib/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/alex/bin
export PERL5LIB=$(PREFIX)/lib/perl5
export PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig:$(PREFIX)/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
export PYTHONPATH=$(PREFIX)/lib/python2.7/site-packages:$(PREFIX)/lib/python2.7/site-packages
export XCURSOR_PATH=$(PREFIX)/share/icons
export XDG_CONFIG_DIRS=$(PREFIX)/etc/xdg:/etc
export XDG_DATA_DIRS=$(PREFIX)/share:/usr/share

STD_CONFIGURE_FLAGS=--prefix=${PREFIX}

src/% : src/%.url
	wget -O - -i $< > $@

build_tarball =					\
	(					\
	mkdir -p $(PREFIX) &&			\
	mkdir -p build &&			\
	cd build &&				\
	rm -rf $(basename $(basename $(notdir $(1)))) && \
	tar xf ../$(1) &&				\
        cd $(basename $(basename $(notdir $(1)))) &&				\
	if test "x$(3)" != "x"; then patch -p1 < ../../$(3); fi && \
	./configure --prefix=${PREFIX} $(2) &&	\
	make -j4 V=1 &&				\
	make install $(4) 			\
	)



all: create-root create-export
	echo DONE

empty-root: 
	rm -rf root
	mkdir root

create-root: empty-root modules
	true;

modules: glib fontconfig pixman cairo gobject-introspection atk harfbuzz pango gdk-pixbuf gtk+ librsvg gnome-themes-standard
	true

glib: src/glib-2.35.8.tar.xz
	$(call build_tarball,$<,)

fontconfig: src/fontconfig-2.10.91.tar.bz2
#	We need DESTDIR to work around an issue with failing fc-cache
	$(call build_tarball,$<,,,DESTDIR=/)

pixman: src/pixman-0.28.2.tar.gz
	$(call build_tarball,$<,)

cairo: src/cairo-1.12.8.tar.xz
	$(call build_tarball,$<,)

gobject-introspection: src/gobject-introspection-1.35.8.tar.xz
	$(call build_tarball,$<,)

atk: src/atk-2.7.91.tar.xz
	$(call build_tarball,$<,)

harfbuzz: src/harfbuzz-0.9.13.tar.bz2
	$(call build_tarball,$<,)

pango_extra_args:=--with-included-modules=arabic-lang,basic-fc,indic-lang
pango: src/pango-1.33.8.tar.xz
	$(call build_tarball,$<,$(pango_extra_args))

gdk_pixbuf_extra_args:=--with-included-loaders=png,jpeg --enable-gio-sniffing=no
gdk-pixbuf: src/gdk-pixbuf-2.27.2.tar.xz
	$(call build_tarball,$<,$(gdk_pixbuf_extra_args))

gtk+: src/gtk+-3.7.12.tar.xz
	$(call build_tarball,$<,--enable-broadway-backend,gtk.patch)

librsvg: src/librsvg-2.37.0.tar.xz
	$(call build_tarball,$<)

gnome-themes-standard: src/gnome-themes-standard-3.7.91.tar.xz
	$(call build_tarball,$<,--disable-gtk2-engine)

create-export:
	rm -rf export
	mkdir -p export/{bin,var}
	cp -r root/etc root/lib root/share export
	cp root/bin/broadwayd root/bin/gtk3-demo root/bin/gtk3-demo-application export/bin
	rm -rf export/share/aclocal  export/share/doc export/share/gir-1.0 export/share/gtk-doc export/share/locale export/share/man
	rm -rf export/lib/*.a export/lib/*.la
	rm -rf export/lib/*/*.a export/lib/pkgconfig  export/lib/gobject-introspection
	rm -rf export/share/icons/HighContrast
	strip export/lib/*.so*
	strip export/bin/*
	cp fonts.conf export/etc/fonts/
	mkdir -p export/etc/xdg/gtk-3.0
	cp settings.ini export/etc/xdg/gtk-3.0/