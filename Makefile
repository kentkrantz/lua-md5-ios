SDK_IPHONEOS_PATH = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
XCODE_TOOLCHAIN_PATH = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

CC := $(XCODE_TOOLCHAIN_PATH)/clang
AR := $(XCODE_TOOLCHAIN_PATH)/ar

ARCHS = -arch armv7 -arch armv7s -arch arm64

#======================================

MD5_SO=core.so
DES56_SO=des56.so

CMOD_DESTDIR = $(DIST)/usr/local/lib/lua/5.3
LMOD_DESTDIR = $(DIST)/var/mobile/Library/AutoTouch/Library/LuaLibraries

#------
# Modules belonging to socket-core
#
MD5_OBJS= \
	md5.o \
	md5lib.o

#------
# Modules belonging mime-core
#
DES56_OBJS= \
	des56.o \
	ldes56.o

.c.o:
	xcrun -sdk iphoneos gcc $(ARCHS) -miphoneos-version-min=6.0 -O3 -std=c99 -I./ -c -o $@ $<

all: $(MD5_SO) $(DES56_SO)

$(MD5_SO): $(MD5_OBJS)
	xcrun -sdk iphoneos gcc $(ARCHS) -miphoneos-version-min=6.0 -O3 -Wl,-segalign,4000 -bundle -undefined dynamic_lookup -o $@ $^ $(LIBS)
	ldid -S $@

$(DES56_SO): $(DES56_OBJS)
	xcrun -sdk iphoneos gcc $(ARCHS) -miphoneos-version-min=6.0 -O3 -Wl,-segalign,4000 -bundle -undefined dynamic_lookup -o $@ $^ $(LIBS)
	ldid -S $@

install:
	install -d $(CMOD_DESTDIR) $(CMOD_DESTDIR)/md5
	install $(MD5_SO) $(CMOD_DESTDIR)/md5
	install $(DES56_SO) $(CMOD_DESTDIR)
	install -m644 md5.lua $(LMOD_DESTDIR)

clean:
	rm -f $(MD5_SO) $(DES56_SO) $(MD5_OBJS) $(DES56_OBJS)

.PHONY: all install clean

#------
# List of dependencies
#
md5.o: md5.c md5.h
md5lib.o: md5lib.c md5.h
compat-5.2.o: compat-5.2.c compat-5.2.h
ldes56.o: ldes56.c ldes56.h
des56.o: des56.c des56.h