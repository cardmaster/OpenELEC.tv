################################################################################
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

PKG_NAME="mktorrent"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://github.com/cardmaster/mktorrent"
PKG_URL="https://github.com/cardmaster/$PKG_NAME/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain "
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="mktorrent create torrent meta file"
PKG_LONGDESC="mktorrent - preparing torrent meta file for sharing"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAINTAINER="cardmaster"

unpack() {
  tar xzf $SOURCES/$PKG_NAME/v$PKG_VERSION.tar.gz -C $BUILD

  if [ -d  $BUILD/$PKG_NAME-$PKG_NAME-$PKG_VERSION ]; then
    mv $BUILD/$PKG_NAME-$PKG_NAME-$PKG_VERSION $BUILD/$PKG_NAME-$PKG_VERSION
  fi
}

