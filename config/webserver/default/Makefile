MAKEFLAGS=-s --no-print-directory
am__is_gnu_make = { \
  if test -z '$(MAKELEVEL)'; then \
    false; \
  elif test -n '$(MAKE_HOST)'; then \
    true; \
  elif test -n '$(MAKE_VERSION)' && test -n '$(CURDIR)'; then \
    true; \
  else \
    false; \
  fi; \
}
am__make_running_with_option = \
  case $${target_option-} in \
      ?) ;; \
      *) echo "am__make_running_with_option: internal error: invalid" \
              "target option '$${target_option-}' specified" >&2; \
         exit 1;; \
  esac; \
  has_opt=no; \
  sane_makeflags=$$MAKEFLAGS; \
  if $(am__is_gnu_make); then \
    sane_makeflags=$$MFLAGS; \
  else \
    case $$MAKEFLAGS in \
      *\\[\ \	]*) \
        bs=\\; \
        sane_makeflags=`printf '%s\n' "$$MAKEFLAGS" \
          | sed "s/$$bs$$bs[$$bs $$bs	]*//g"`;; \
    esac; \
  fi; \
  skip_next=no; \
  strip_trailopt () \
  { \
    flg=`printf '%s\n' "$$flg" | sed "s/$$1.*$$//"`; \
  }; \
  for flg in $$sane_makeflags; do \
    test $$skip_next = yes && { skip_next=no; continue; }; \
    case $$flg in \
      *=*|--*) continue;; \
        -*I) strip_trailopt 'I'; skip_next=yes;; \
      -*I?*) strip_trailopt 'I';; \
        -*O) strip_trailopt 'O'; skip_next=yes;; \
      -*O?*) strip_trailopt 'O';; \
        -*l) strip_trailopt 'l'; skip_next=yes;; \
      -*l?*) strip_trailopt 'l';; \
      -[dEDm]) skip_next=yes;; \
      -[JT]) skip_next=yes;; \
    esac; \
    case $$flg in \
      *$$target_option*) has_opt=yes; break;; \
    esac; \
  done; \
  test $$has_opt = yes
am__make_dryrun = (target_option=n; $(am__make_running_with_option))
am__make_keepgoing = (target_option=k; $(am__make_running_with_option))
pkgdatadir = $(datadir)/amule
pkgincludedir = $(includedir)/amule
pkglibdir = $(libdir)/amule
pkglibexecdir = $(libexecdir)/amule
am__cd = CDPATH="$${ZSH_VERSION+.}$(PATH_SEPARATOR)" && cd
install_sh_DATA = $(install_sh) -c -m 644
install_sh_PROGRAM = $(install_sh) -c
install_sh_SCRIPT = $(install_sh) -c
INSTALL_HEADER = $(INSTALL_DATA)
transform = $(program_transform_name)
NORMAL_INSTALL = :
PRE_INSTALL = :
POST_INSTALL = :
NORMAL_UNINSTALL = :
PRE_UNINSTALL = :
POST_UNINSTALL = :
build_triplet = x86_64-pc-linux-gnu
host_triplet = mips-openwrt-linux-gnu
subdir = src/webserver/default
ACLOCAL_M4 = $(top_srcdir)/aclocal.m4
am__aclocal_m4_deps = $(top_srcdir)/m4/GeoIP.m4 \
	$(top_srcdir)/m4/bfd.m4 $(top_srcdir)/m4/boost.m4 \
	$(top_srcdir)/m4/build-tools.m4 $(top_srcdir)/m4/cryptopp.m4 \
	$(top_srcdir)/m4/fallocate.m4 $(top_srcdir)/m4/gdlib.m4 \
	$(top_srcdir)/m4/intdiv0.m4 $(top_srcdir)/m4/inttypes-pri.m4 \
	$(top_srcdir)/m4/inttypes.m4 $(top_srcdir)/m4/kde.m4 \
	$(top_srcdir)/m4/lib-ld.m4 $(top_srcdir)/m4/lib-link.m4 \
	$(top_srcdir)/m4/lib-prefix.m4 $(top_srcdir)/m4/libpng.m4 \
	$(top_srcdir)/m4/libupnp.m4 $(top_srcdir)/m4/mmap.m4 \
	$(top_srcdir)/m4/muleboost.m4 $(top_srcdir)/m4/nls.m4 \
	$(top_srcdir)/m4/pkg.m4 $(top_srcdir)/m4/plasmamule.m4 \
	$(top_srcdir)/m4/progtest.m4 $(top_srcdir)/m4/qt.m4 \
	$(top_srcdir)/m4/readline.m4 $(top_srcdir)/m4/wxwin.m4 \
	$(top_srcdir)/m4/zlib.m4 $(top_srcdir)/acinclude.m4 \
	$(top_srcdir)/configure.in
am__configure_deps = $(am__aclocal_m4_deps) $(CONFIGURE_DEPENDENCIES) \
	$(ACLOCAL_M4)
DIST_COMMON = $(srcdir)/Makefile.am $(dist_webserver_DATA) \
	$(am__DIST_COMMON)
mkinstalldirs = $(SHELL) $(top_srcdir)/mkinstalldirs
CONFIG_HEADER = $(top_builddir)/config.h
CONFIG_CLEAN_FILES =
CONFIG_CLEAN_VPATH_FILES =
am__v_P_1 = :
am__v_GEN_1 = 
am__v_at_1 = 
SOURCES =
DIST_SOURCES =
am__can_run_installinfo = \
  case $$AM_UPDATE_INFO_DIR in \
    n|no|NO) false;; \
    *) (install-info --version) >/dev/null 2>&1;; \
  esac
am__vpath_adj_setup = srcdirstrip=`echo "$(srcdir)" | sed 's|.|.|g'`;
am__vpath_adj = case $$p in \
    $(srcdir)/*) f=`echo "$$p" | sed "s|^$$srcdirstrip/||"`;; \
    *) f=$$p;; \
  esac;
am__strip_dir = f=`echo $$p | sed -e 's|^.*/||'`;
am__install_max = 40
am__nobase_strip_setup = \
  srcdirstrip=`echo "$(srcdir)" | sed 's/[].[^$$\\*|]/\\\\&/g'`
am__nobase_strip = \
  for p in $$list; do echo "$$p"; done | sed -e "s|$$srcdirstrip/||"
am__nobase_list = $(am__nobase_strip_setup); \
  for p in $$list; do echo "$$p $$p"; done | \
  sed "s| $$srcdirstrip/| |;"' / .*\//!s/ .*/ ./; s,\( .*\)/[^/]*$$,\1,' | \
  $(AWK) 'BEGIN { files["."] = "" } { files[$$2] = files[$$2] " " $$1; \
    if (++n[$$2] == $(am__install_max)) \
      { print $$2, files[$$2]; n[$$2] = 0; files[$$2] = "" } } \
    END { for (dir in files) print dir, files[dir] }'
am__base_list = \
  sed '$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;s/\n/ /g' | \
  sed '$$!N;$$!N;$$!N;$$!N;s/\n/ /g'
am__uninstall_files_from_dir = { \
  test -z "$$files" \
    || { test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; } \
    || { echo " ( cd '$$dir' && rm -f" $$files ")"; \
         $(am__cd) "$$dir" && rm -f $$files; }; \
  }
am__installdirs = "$(DESTDIR)$(webserverdir)"
DATA = $(dist_webserver_DATA)
am__tagged_files = $(HEADERS) $(SOURCES) $(TAGS_FILES) $(LISP)
am__DIST_COMMON = $(srcdir)/Makefile.in $(top_srcdir)/mkinstalldirs
DISTFILES = $(DIST_COMMON) $(DIST_SOURCES) $(TEXINFOS) $(EXTRA_DIST)
ACLOCAL = ${SHELL} /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/missing aclocal-1.15
ALCC_MANPAGES = 
ALC_MANPAGES = 
ALLOCA = 
AMTAR = $${TAR-tar}
AMULECMD_MANPAGES = 
AMULEWEB_DEFS = -DWITH_LIBPNG
AMULE_DAEMON_MANPAGES = 
AMULE_GUI_MANPAGES = 
AR = mips-openwrt-linux-uclibc-gcc-ar
AUTOCONF = ${SHELL} /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/missing autoconf
AUTOHEADER = ${SHELL} /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/missing autoheader
AUTOMAKE = ${SHELL} /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/missing automake-1.15
AWK = gawk
BFD_CPPFLAGS = -DHAVE_BFD
BFD_LIBS = -lbfd
BOOST_CPPFLAGS = 
BOOST_LDPATH = 
BOOST_ROOT = 
BOOST_SYSTEM_LDFLAGS = 
BOOST_SYSTEM_LDPATH = 
BOOST_SYSTEM_LIBS = 
BUILD_CC = x86_64-linux-gnu-gcc
BUILD_CFLAGS = 
BUILD_CPPFLAGS = 
BUILD_EXEEXT = 
BUILD_INCLUDED_LIBINTL = no
BUILD_LDFLAGS = 
CAS_DEFS = 
CAS_MANPAGES = 
CATOBJEXT = 
CC = mips-openwrt-linux-uclibc-gcc
CCDEPMODE = depmode=gcc3
CFLAGS = -Os -pipe -mno-branch-likely -mips32 -mtune=mips32 -fno-caller-saves -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -msoft-float -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libiconv-stub/include -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libintl-stub/include  -O2
CPP = mips-openwrt-linux-uclibc-gcc -E
CPPFLAGS = -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/include -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/include -I/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/usr/include -I/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/include -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libiconv-stub/include -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libintl-stub/include 
CRYPTOPP_CPPFLAGS = -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/include -D__WEAK_CRYPTO__
CRYPTOPP_LDFLAGS = -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib
CRYPTOPP_LIBS = -lcryptopp
CXX = mips-openwrt-linux-uclibc-g++
CXXCPP = mips-openwrt-linux-uclibc-g++ -E
CXXDEPMODE = depmode=gcc3
CXXFLAGS = -Os -pipe -mno-branch-likely -mips32 -mtune=mips32 -fno-caller-saves -fhonour-copts -msoft-float -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libiconv-stub/include -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libintl-stub/include  -O2
CYGPATH_W = echo
DATADIRNAME = share
DEBUGFLAG = 
DEFS = -DHAVE_CONFIG_H
DEPDIR = .deps
DISTCHECK_CONFIGURE_FLAGS = 
ECHO_C = 
ECHO_N = -n
ECHO_T = 
ED2K_MANPAGES = 
EGREP = /home/asus/chaos_calmer/staging_dir/host/bin/grep -E
EXEEXT = 
GDLIB_CFLAGS = 
GDLIB_CONFIG_PATH = 
GDLIB_LDFLAGS = 
GDLIB_LIBS = 
GENCAT = gencat
GEOIP_CPPFLAGS = 
GEOIP_LDFLAGS = 
GEOIP_LIBS = 
GETTEXT_MACRO_VERSION = 0.18
GLIBC2 = yes
GLIBC21 = yes
GMSGFMT = /usr/bin/msgfmt
GMSGFMT_015 = /usr/bin/msgfmt
GREP = /home/asus/chaos_calmer/staging_dir/host/bin/grep
HAVE_ASPRINTF = 1
HAVE_NEWLOCALE = 0
HAVE_POSIX_PRINTF = 0
HAVE_SNPRINTF = 1
HAVE_WPRINTF = 0
INCINTL = 
INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_PROGRAM = ${INSTALL}
INSTALL_SCRIPT = ${INSTALL}
INSTALL_STRIP_PROGRAM = $(install_sh) -c -s
INSTOBJEXT = .mo
INTLBISON = bison
INTLLIBS = 
INTLOBJS = 
INTL_DEFAULT_VERBOSITY = 1
INTL_LIBTOOL_SUFFIX_PREFIX = 
INTL_MACOSX_LIBS = 
KDE4_CONFIG = 
KDE_APPLNK_PATH = 
KDE_HEADER_DIR = 
KDE_ICON_PATH = 
KDE_MIME_PATH = 
KDE_MODULE_PATH = 
KDE_SERVICE_PATH = 
LD = mips-openwrt-linux-uclibc-ld
LDFLAGS = -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/lib -L/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/usr/lib -L/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/lib -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libiconv-stub/lib -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libintl-stub/lib -liconv  
LEX = flex
LEXLIB = 
LEX_OUTPUT_ROOT = lex.yy
LIBICONV = /home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libiconv-stub/lib/libiconv.a
LIBINTL = 
LIBOBJS =  ${LIBOBJDIR}strtod$U.o
LIBPNG_CFLAGS = -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/include/libpng12
LIBPNG_CONFIG_PATH = /home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/bin/libpng-config
LIBPNG_LDFLAGS = -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib
LIBPNG_LIBS = -lpng12
LIBS = 
LIBUPNP_CFLAGS = 
LIBUPNP_CPPFLAGS = 
LIBUPNP_LDFLAGS = 
LIBUPNP_LIBS = 
LTLIBC = -lc
LTLIBICONV = -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib/libiconv-stub/lib -liconv
LTLIBINTL = 
LTLIBOBJS =  ${LIBOBJDIR}strtod$U.lo
MAINT = #
MAKEINFO = ${SHELL} /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/missing makeinfo
MKDIR_P = /bin/mkdir -p
MONOLITHIC_MANPAGES = 
MSGFMT = /usr/bin/msgfmt
MSGFMT_015 = /usr/bin/msgfmt
MSGMERGE = /usr/bin/msgmerge
MULECFLAGS = -w 
MULECPPFLAGS =  -DUSE_WX_EXTENSIONS
MULECXXFLAGS = -w 
MULELDFLAGS =  -lpthread
MULERCFLAGS = -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib/wx/include/mips-openwrt-linux-base-unicode-release-2.8 -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/include -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/contrib/include -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -DwxUSE_GUI=0 
OBJEXT = o
PACKAGE = amule
PACKAGE_BUGREPORT = admin@amule.org
PACKAGE_NAME = aMule
PACKAGE_STRING = aMule 2.3.2
PACKAGE_TARNAME = amule
PACKAGE_URL = 
PACKAGE_VERSION = 2.3.2
PATH_SEPARATOR = :
PKG_CONFIG = /home/asus/chaos_calmer/staging_dir/host/bin/pkg-config
POSUB = 
POW_LIB = 
QT_CORE_CXXFLAGS = 
QT_CORE_LIBS = 
QT_DBUS_LDFLAGS = 
QT_GUI_CXXFLAGS = 
QT_GUI_LIBS = 
QT_MOC = 
RANLIB = mips-openwrt-linux-uclibc-gcc-ranlib
RC = 
RCFLAGS = 
READLINE_LIBS = -lreadline -lcurses
RESOLV_LIB = 
SED = /home/asus/chaos_calmer/staging_dir/host/bin/sed
SET_MAKE = 
SHELL = /bin/sh
STRIP = mips-openwrt-linux-uclibc-strip
SVNDATE = 
USE_INCLUDED_LIBINTL = no
USE_NLS = no
VERSION = 2.3.2
WEBSERVER_MANPAGES = 
WINDRES = 
WOE32 = no
WOE32DLL = no
WXBASE_CPPFLAGS = -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib/wx/include/mips-openwrt-linux-base-unicode-release-2.8 -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/include -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/contrib/include -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -DwxUSE_GUI=0 -DwxUSE_GUI=0
WXBASE_LIBS = -L/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib -pthread -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/lib -L/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/usr/lib -L/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/lib   -lwx_baseu_net-2.8-mips-openwrt-linux -lwx_baseu-2.8-mips-openwrt-linux 
WXCAS_MANPAGES = 
WX_CFLAGS = -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib/wx/include/mips-openwrt-linux-base-unicode-release-2.8 -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/include -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/contrib/include -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -DwxUSE_GUI=0 -pthread
WX_CFLAGS_ONLY = -pthread
WX_CONFIG_PATH = /home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/bin/wx-config
WX_CPPFLAGS = -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib/wx/include/mips-openwrt-linux-base-unicode-release-2.8 -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/include -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/contrib/include -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -DwxUSE_GUI=0
WX_CXXFLAGS = -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib/wx/include/mips-openwrt-linux-base-unicode-release-2.8 -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/include -I/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/contrib/include -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -DwxUSE_GUI=0 -pthread
WX_CXXFLAGS_ONLY = 
WX_DEBUG = 0
WX_LIBS = -L/home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/wxGTK-2.8.12/lib -pthread -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/lib -L/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/usr/lib -L/home/asus/chaos_calmer/staging_dir/toolchain-mips_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/lib   -lwx_baseu_adv-2.8-mips-openwrt-linux -lwx_baseu_core-2.8-mips-openwrt-linux -lwx_baseu_net-2.8-mips-openwrt-linux -lwx_baseu-2.8-mips-openwrt-linux 
WX_LIBS_STATIC = 
WX_PORT = base
WX_RESCOMP = 
WX_SHARED = 1
WX_UNICODE = 1
WX_VERSION = 2.8.12
WX_VERSION_MAJOR = 2
WX_VERSION_MICRO = 12
WX_VERSION_MINOR = 8
XGETTEXT = /usr/bin/xgettext
XGETTEXT_015 = /usr/bin/xgettext
XGETTEXT_EXTRA_OPTIONS = 
YACC = bison -y
YFLAGS = 
ZLIB_CPPFLAGS = -I/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/include
ZLIB_LDFLAGS = -L/home/asus/chaos_calmer/staging_dir/target-mips_mips32_uClibc-0.9.33.2/usr/lib
ZLIB_LIBS = -lz
abs_builddir = /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/src/webserver/default
abs_srcdir = /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/src/webserver/default
abs_top_builddir = /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2
abs_top_srcdir = /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2
ac_ct_BUILD_CC = 
ac_ct_CC = 
ac_ct_CXX = 
am__include = include
am__leading_dot = .
am__quote = 
am__tar = $${TAR-tar} chof - "$$tardir"
am__untar = $${TAR-tar} xf -
bindir = /usr/bin
build = x86_64-pc-linux-gnu
build_alias = x86_64-linux-gnu
build_cpu = x86_64
build_os = linux-gnu
build_vendor = pc
builddir = .
datadir = /usr/share
datarootdir = ${prefix}/share
docdir = ${datarootdir}/doc/${PACKAGE_TARNAME}
dvidir = ${docdir}
exec_prefix = /usr
host = mips-openwrt-linux-gnu
host_alias = mips-openwrt-linux
host_cpu = mips
host_os = linux-gnu
host_vendor = openwrt
htmldir = ${docdir}
includedir = ${prefix}/include
infodir = /usr/info
install_sh = ${SHELL} /home/asus/chaos_calmer/build_dir/target-mips_mips32_uClibc-0.9.33.2/aMule-2.3.2/install-sh
libdir = ${exec_prefix}/lib
libexecdir = /usr/lib
localedir = ${datarootdir}/locale
localstatedir = /var
mandir = /usr/man
mkdir_p = /bin/mkdir -p
oldincludedir = /usr/include
pdfdir = ${docdir}
prefix = /usr
program_transform_name = s&$$&&;s&^&&
psdir = ${docdir}
sbindir = /usr/sbin
sharedstatedir = ${prefix}/com
srcdir = .
sysconfdir = /etc
target_alias = mips-openwrt-linux
top_build_prefix = ../../../
top_builddir = ../../..
top_srcdir = ../../..
dist_webserver_DATA = \
	amuleweb-main-dload.php \
	amuleweb-main-kad.php \
	amuleweb-main-log.php \
	amuleweb-main-prefs.php \
	amuleweb-main-search.php \
	amuleweb-main-servers.php \
	amuleweb-main-shared.php \
	amuleweb-main-stats.php \
	black.gif \
	blank1x1.gif \
	blue1.gif \
	blue2.gif \
	blue3.gif \
	blue4.gif \
	blue5.gif \
	blue6.gif \
	cancel.gif \
	close.png \
	col.png \
	connect.gif \
	down.png \
	edkserv_0.png \
	edkserv_1.png \
	favicon.ico \
	filter.png \
	fond.gif \
	fond_haut.png \
	footer.php \
	index.html \
	loginfond.gif \
	loginfond_haut.png \
	loginlogo.jpg \
	loginlogo.png \
	login.php \
	logo.png \
	log.php \
	maquette.dwt \
	ok.png \
	pause.png \
	play.png \
	red.gif \
	refresh.png \
	search_0.png \
	search_1.png \
	shared_0.png \
	shared_1.png \
	sheserv_0.png \
	sheserv_1.png \
	stats_0.png \
	stats_1.png \
	stats.php \
	stats_tree.php \
	style.css \
	tab_bottom_left.png \
	tab_bottom.png \
	tab_bottom_right.png \
	tab_left.png \
	tab_right.png \
	tab_top_left.png \
	tab_top.png \
	tab_top_right.png \
	transf_0.png \
	transf_1.png \
	tree-closed.gif \
	tree-leaf.gif \
	tree-open.gif \
	up.png \
	yellow.gif
webserverdir = $(pkgdatadir)/webserver/default
MAINTAINERCLEANFILES = Makefile.in
all: all-am
.SUFFIXES:
$(srcdir)/Makefile.in: # $(srcdir)/Makefile.am  $(am__configure_deps)
	@for dep in $?; do \
	  case '$(am__configure_deps)' in \
	    *$$dep*) \
	      ( cd $(top_builddir) && $(MAKE) $(AM_MAKEFLAGS) am--refresh ) \
	        && { if test -f $@; then exit 0; else break; fi; }; \
	      exit 1;; \
	  esac; \
	done; \
	echo ' cd $(top_srcdir) && $(AUTOMAKE) --foreign src/webserver/default/Makefile'>/dev/null; \
	$(am__cd) $(top_srcdir) && \
	  $(AUTOMAKE) --foreign src/webserver/default/Makefile
Makefile: $(srcdir)/Makefile.in $(top_builddir)/config.status
	@case '$?' in \
	  *config.status*) \
	    cd $(top_builddir) && $(MAKE) $(AM_MAKEFLAGS) am--refresh;; \
	  *) \
	    echo ' cd $(top_builddir) && $(SHELL) ./config.status $(subdir)/$@ $(am__depfiles_maybe)'>/dev/null; \
	    cd $(top_builddir) && $(SHELL) ./config.status $(subdir)/$@ $(am__depfiles_maybe) denoiser;; \
	esac;
$(top_builddir)/config.status: $(top_srcdir)/configure $(CONFIG_STATUS_DEPENDENCIES)
	cd $(top_builddir) && $(MAKE) $(AM_MAKEFLAGS) am--refresh
$(top_srcdir)/configure: # $(am__configure_deps)
	cd $(top_builddir) && $(MAKE) $(AM_MAKEFLAGS) am--refresh
$(ACLOCAL_M4): # $(am__aclocal_m4_deps)
	cd $(top_builddir) && $(MAKE) $(AM_MAKEFLAGS) am--refresh
$(am__aclocal_m4_deps):
install-dist_webserverDATA: $(dist_webserver_DATA)
	@$(NORMAL_INSTALL)
	@list='$(dist_webserver_DATA)'; test -n "$(webserverdir)" || list=; \
	if test -n "$$list"; then \
	  echo " $(MKDIR_P) '$(DESTDIR)$(webserverdir)'"; \
	  $(MKDIR_P) "$(DESTDIR)$(webserverdir)" || exit 1; \
	fi; \
	for p in $$list; do \
	  if test -f "$$p"; then d=; else d="$(srcdir)/"; fi; \
	  echo "$$d$$p"; \
	done | $(am__base_list) | \
	while read files; do \
	  echo " $(INSTALL_DATA) $$files '$(DESTDIR)$(webserverdir)'">/dev/null; \
	echo "Installing $(webserverdir)"; \
	  $(INSTALL_DATA) $$files "$(DESTDIR)$(webserverdir)" || exit $$?; \
	done
uninstall-dist_webserverDATA:
	@$(NORMAL_UNINSTALL)
	@list='$(dist_webserver_DATA)'; test -n "$(webserverdir)" || list=; \
	files=`for p in $$list; do echo $$p; done | sed -e 's|^.*/||'`; \
	dir='$(DESTDIR)$(webserverdir)'; $(am__uninstall_files_from_dir)
tags TAGS:
ctags CTAGS:
cscope cscopelist:
distdir: $(DISTFILES)
	@srcdirstrip=`echo "$(srcdir)" | sed 's/[].[^$$\\*]/\\\\&/g'`; \
	topsrcdirstrip=`echo "$(top_srcdir)" | sed 's/[].[^$$\\*]/\\\\&/g'`; \
	list='$(DISTFILES)'; \
	  dist_files=`for file in $$list; do echo $$file; done | \
	  sed -e "s|^$$srcdirstrip/||;t" \
	      -e "s|^$$topsrcdirstrip/|$(top_builddir)/|;t"`; \
	case $$dist_files in \
	  */*) $(MKDIR_P) `echo "$$dist_files" | \
			   sed '/\//!d;s|^|$(distdir)/|;s,/[^/]*$$,,' | \
			   sort -u` ;; \
	esac; \
	for file in $$dist_files; do \
	  if test -f $$file || test -d $$file; then d=.; else d=$(srcdir); fi; \
	  if test -d $$d/$$file; then \
	    dir=`echo "/$$file" | sed -e 's,/[^/]*$$,,'`; \
	    if test -d "$(distdir)/$$file"; then \
	      find "$(distdir)/$$file" -type d ! -perm -700 -exec chmod u+rwx {} \;; \
	    fi; \
	    if test -d $(srcdir)/$$file && test $$d != $(srcdir); then \
	      cp -fpR $(srcdir)/$$file "$(distdir)$$dir" || exit 1; \
	      find "$(distdir)/$$file" -type d ! -perm -700 -exec chmod u+rwx {} \;; \
	    fi; \
	    cp -fpR $$d/$$file "$(distdir)$$dir" || exit 1; \
	  else \
	    test -f "$(distdir)/$$file" \
	    || cp -p $$d/$$file "$(distdir)/$$file" \
	    || exit 1; \
	  fi; \
	done
check-am: all-am
check: check-am
all-am: Makefile $(DATA)
installdirs:
	for dir in "$(DESTDIR)$(webserverdir)"; do \
	  test -z "$$dir" || $(MKDIR_P) "$$dir"; \
	done
install: install-am
install-exec: install-exec-am
install-data: install-data-am
uninstall: uninstall-am
install-am: all-am
	@$(MAKE) $(AM_MAKEFLAGS) install-exec-am install-data-am
installcheck: installcheck-am
install-strip:
	if test -z '$(STRIP)'; then \
	  $(MAKE) $(AM_MAKEFLAGS) INSTALL_PROGRAM="$(INSTALL_STRIP_PROGRAM)" \
	    install_sh_PROGRAM="$(INSTALL_STRIP_PROGRAM)" INSTALL_STRIP_FLAG=-s \
	      install; \
	else \
	  $(MAKE) $(AM_MAKEFLAGS) INSTALL_PROGRAM="$(INSTALL_STRIP_PROGRAM)" \
	    install_sh_PROGRAM="$(INSTALL_STRIP_PROGRAM)" INSTALL_STRIP_FLAG=-s \
	    "INSTALL_PROGRAM_ENV=STRIPPROG='$(STRIP)'" install; \
	fi
mostlyclean-generic:
clean-generic:
distclean-generic:
	-test -z "$(CONFIG_CLEAN_FILES)" || rm -f $(CONFIG_CLEAN_FILES)
	-test . = "$(srcdir)" || test -z "$(CONFIG_CLEAN_VPATH_FILES)" || rm -f $(CONFIG_CLEAN_VPATH_FILES)
maintainer-clean-generic:
	@echo "This command is intended for maintainers to use"
	@echo "it deletes files that may require special tools to rebuild."
	-test -z "$(MAINTAINERCLEANFILES)" || rm -f $(MAINTAINERCLEANFILES)
clean: clean-am
clean-am: clean-generic mostlyclean-am
distclean: distclean-am
	-rm -f Makefile
distclean-am: clean-am distclean-generic
dvi: dvi-am
dvi-am:
html: html-am
html-am:
info: info-am
info-am:
install-data-am: install-dist_webserverDATA
install-dvi: install-dvi-am
install-dvi-am:
install-exec-am:
install-html: install-html-am
install-html-am:
install-info: install-info-am
install-info-am:
install-man:
install-pdf: install-pdf-am
install-pdf-am:
install-ps: install-ps-am
install-ps-am:
installcheck-am:
maintainer-clean: maintainer-clean-am
	-rm -f Makefile
maintainer-clean-am: distclean-am maintainer-clean-generic
mostlyclean: mostlyclean-am
mostlyclean-am: mostlyclean-generic
pdf: pdf-am
pdf-am:
ps: ps-am
ps-am:
uninstall-am: uninstall-dist_webserverDATA
.MAKE: install-am install-strip
.PHONY: all all-am check check-am clean clean-generic cscopelist-am \
	ctags-am distclean distclean-generic distdir dvi dvi-am html \
	html-am info info-am install install-am install-data \
	install-data-am install-dist_webserverDATA install-dvi \
	install-dvi-am install-exec install-exec-am install-html \
	install-html-am install-info install-info-am install-man \
	install-pdf install-pdf-am install-ps install-ps-am \
	install-strip installcheck installcheck-am installdirs \
	maintainer-clean maintainer-clean-generic mostlyclean \
	mostlyclean-generic pdf pdf-am ps ps-am tags-am uninstall \
	uninstall-am uninstall-dist_webserverDATA
.PRECIOUS: Makefile
.NOEXPORT:
