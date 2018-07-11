# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

DESCRIPTION="Nomad is a flexible, enterprise-grade cluster scheduler designed to easily integrate into existing workflows."
HOMEPAGE="https://www.nomadproject.io/"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGO_PN="github.com/hashicorp/nomad"

LICENSE="MPL-2.0"
SLOT="0.8"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-go/gox
	>=dev-lang/go-1.10
	>=dev-go/go-tools-0_pre20160121"
RDEPEND="${DEPEND}"
PDEPEND="app-eselect/eselect-nomad"

src_prepare() {
	default

	sed -e 's/dev: vendorfmt changelogfmt/dev:/' \
	    -e 's/^\(GIT_COMMIT :=\).*/\1/' \
		-e 's/^\(GIT_DIRTY :=\).*/\1/' \
		-i "${S}/src/${EGO_PN}/GNUmakefile" || die
}

src_compile() {
	GOPATH="${S}" GOBIN="${S}/bin" \
		emake -C "${S}/src/${EGO_PN}" dev
}

src_install() {
	dodir /usr/bin
	cp "${S}/src/${EGO_PN}/bin/${PN}" "${D}/usr/bin/${PN}-${SLOT}" || die
}

eselect_nomad_update() {
	if [[ -z "$(eselect nomad show)" || ! -f "${EROOT}usr/bin/$(eselect nomad show)" ]]; then
		eselect nomad set ${PN}-${SLOT}
	fi
}

pkg_postinst() {
	eselect_nomad_update
}

pkg_postrm() {
	eselect_nomad_update
}
