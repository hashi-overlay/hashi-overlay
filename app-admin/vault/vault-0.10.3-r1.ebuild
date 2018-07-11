# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fcaps golang-vcs-snapshot systemd user

EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="A tool for secrets management, encryption as a service, and privileged access management"
HOMEPAGE="https://www.vaultproject.io/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0.10"
LICENSE="MPL-2.0"
KEYWORDS="amd64"
IUSE=""

RESTRICT="test"

DEPEND=">=dev-lang/go-1.10:=
	dev-go/gox"
PDEPEND="app-eselect/eselect-vault"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/${PN}-${SLOT}
)

src_prepare() {
	default

	sed -e 's/dev: prep/dev:/' \
		-i "${S}/src/${EGO_PN}/Makefile" || die

	sed -e 's:^\(GIT_COMMIT=\).*:\1:' \
		-e 's:^\(GIT_DIRTY=\).*:\1:' \
		-e s:\'\${GIT_COMMIT}\${GIT_DIRTY}\':: \
		-i "${S}/src/${EGO_PN}/scripts/build.sh" || die
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	mkdir bin || die
	export GOPATH=${S}
	cd src/${EGO_PN} || die
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	XC_OSARCH=$(go env GOOS)/$(go env GOARCH) \
	emake
}

src_install() {
	dodoc src/${EGO_PN}/{CHANGELOG.md,CONTRIBUTING.md,README.md}
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	dobin bin/${PN}-${SLOT}
}

eselect_vault_update() {
	if [[ -z "$(eselect vault show)" || ! -f "${EROOT}usr/bin/$(eselect vault show)" ]]; then
		eselect vault set ${PN}-${SLOT}
	fi
}

pkg_postinst() {
	eselect_vault_update
}

pkg_postrm() {
	eselect_vault_update
}
