# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages the /usr/bin/terraform symlink"
HOMEPAGE="https://github.com/hashi-overlay/eselect-terraform"
SRC_URI="https://github.com/hashi-overlay/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=app-admin/eselect-1.4"

src_install() {
	insinto /usr/share/eselect/modules
	doins terraform.eselect || die
}
