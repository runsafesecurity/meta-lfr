SUMMARY = "LFR load-time code randomization, built from external package"
HOMEPAGE = "https://runsafesecurity.com"
LICENSE = "CLOSED"

LFR_PACKAGE ?= ""

BB_STRICT_CHECKSUM = "0"

SRC_URI = "${LFR_PACKAGE} \
           file://lfr_cached.service \
           "

# The package archive extracts to the lfr-package directory,
# not ${BPN}-${PV} like Yocto expects
S = "${WORKDIR}/lfr-package"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
