###############################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="rtorrent"
PKG_VERSION="0.9.6-OEC4"
PKG_REV="5"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL="http://github.com/cardmaster/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl curl netbsd-curses libtorrent zlib xmlrpc-c libsigc++"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="rTorrent: a very fast, free BitTorrent client"
PKG_LONGDESC="rTorrent bittorrent client can handel multipel watch dirs and post actions. [CR][CR]After changing settings you need to disable and re-enable the addon. [CR][CR]Hove this addon is intended to work: [CR][CR]You add base dirs. [CR]torrents: /storage/downloads/torrents/ [CR]downloads: /storage/downloads [CR]comlete: /storege [CR][CR]then you add watch dirs separated by: ,[CR]videos,tvshows,music [CR][CR]Wath will happen then is: [CR][CR]Directorys while ve created if they dont exist: [CR]/storage/downloads/torrents/videos [CR]/storage/downloads/videos [CR]/storege/videos [CR][CR]then rtorrent while start dtached. [CR][CR]Now if you add a torrent file to: /storage/downloads/torrents/videos it while be downloaded to /storage/downloads/videos [CR][CR]On completion it while be Linked or Copyed to /storege/videos [CR][CR]The same for every watch dir added... [CR][CR]Nice ha..."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_MAINTAINER="Daniel Forsberg (jenkins101)"

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
            --with-xmlrpc-c=$SYSROOT_PREFIX/usr/bin/xmlrpc-c-config \
            --with-gnu-ld \
"

unpack() {
	tar xzf $SOURCES/$PKG_NAME/$PKG_VERSION.tar.gz -C $BUILD
}

post_unpack() {
  $SED "s:<ncurses/curses.h>:<curses.h>:g" $PKG_BUILD/src/display/attributes.h
  $SED "s:<ncurses/ncurses.h>:<curses.h>:g" $PKG_BUILD/src/input/input_event.cc
}

pre_configure_target() {
# bluez fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME

  export LIBS="-lncurses -lterminfo"
}

#makeinstall_target() {
#  : # nop
#}
post_makeinstall_target() {
  mkdir -p $INSTALL/usr/share
  echo cp -f -P $ROOT/$PKG_BUILD/doc/rtorrent.rc $INSTALL/usr/share/rtorrent.rc.default
  cp -f -P $ROOT/$PKG_BUILD/doc/rtorrent.rc $INSTALL/usr/share/rtorrent.rc.default
}

post_install() {
  enable_service rtorrent-defaults.service
  enable_service rtorrent-daemon.service
}