SUMMARY = "LFR load-time code randomization"
HOMEPAGE = "https://runsafesecurity.com"
LICENSE = "CLOSED"

S = "${FILE_DIRNAME}/../../../../.."

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
