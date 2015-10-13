################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="leafmod"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="various"
PKG_SITE="http://github.com/cardmaster"
PKG_URL=""
PKG_DEPENDS_TARGET="rtorrent libtorrent libsigc++ xmlrpc-c screen rutorrent php yaddns mktorrent shairplay"
PKG_PRIORITY="optional"
PKG_SECTION="leafmod"
PKG_SHORTDESC="leafmod: leaf mod for openelec package"
PKG_LONGDESC="leafmod: virtual package to install all leaf mod packages yaddns"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target(){
:
#nop
}

makeinstall_target() {
  echo +mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/etc/leafmod
  echo + cp $PKG_DIR/source/leafmodesetup.sh $INSTALL/usr/bin/setup_leafmod
  cp -f $PKG_DIR/source/leafmodesetup.sh $INSTALL/usr/bin/setup_leafmod
  echo + chmod 755 $INSTALL/usr/bin/setup_leafmod
  chmod 755 $INSTALL/usr/bin/setup_leafmod

}

