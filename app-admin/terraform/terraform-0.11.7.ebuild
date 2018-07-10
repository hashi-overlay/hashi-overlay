# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

DESCRIPTION="Terraform is a tool for building, changing, and combining infrastructure safely and efficiently."
HOMEPAGE="https://www.terraform.io/"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGO_PN="github.com/hashicorp/terraform"

LICENSE="MPL-2.0"
SLOT="0.11"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-go/gox
	>=dev-lang/go-1.10
	>=dev-go/go-tools-0_pre20160121"
RDEPEND="${DEPEND}"
PDEPEND="app-eselect/eselect-terraform"

src_compile() {
	GOPATH="${S}" GOBIN="${S}/bin" \
		emake -C "${S}/src/${EGO_PN}" dev
}

src_install() {
	cp "${S}/bin/${PN}" "${D}/usr/bin/${PN}-${SLOT}"
}

eselect_terraform_update() {
	if [[ -z "$(eselect terraform show)" || ! -f "${EROOT}usr/bin/$(eselect terraform show)" ]]; then
		eselect terraform set ${PN}-${SLOT}
	fi
}

pkg_postinst() {
	eselect_terraform_update
}

pkg_postrm() {
	eselect_terraform_update
}
