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

PKG_NAME="miraclecast"
PKG_VERSION="0.1-OEC"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://github.com/albfan/miraclecast"
PKG_URL="https://github.com/cardmaster/${PKG_NAME}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd udevil glib ncurses"
PKG_PRIORITY="optional"
PKG_SECTION="service/mediacenter"
PKG_SHORTDESC="miracast support"
PKG_LONGDESC="miracast support with 3rd party"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_CONFIGURE_OPTS_TARGET=""
PKG_MAKE_OPTS="LIBS=-lncurses"
PKG_MAINTAINER="Leaf J(cardmaster)"

unpack() {
        echo "UNPACK" $SOURCES/$PKG_NAME/$PKG_VERSION.tar.gz " to ${BUILD}"
	tar xzf $SOURCES/$PKG_NAME/$PKG_VERSION.tar.gz -C $BUILD
}

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DBUILD_SHARED_LIBS=1 \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=/usr/lib \
        -DCMAKE_INSTALL_LIBDIR_NOARCH=/usr/lib \
        -DCMAKE_INSTALL_PREFIX_TOOLCHAIN=$SYSROOT_PREFIX/usr \
        -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr \
        $EXTRA_CMAKE_OPTS \
        ..
}
