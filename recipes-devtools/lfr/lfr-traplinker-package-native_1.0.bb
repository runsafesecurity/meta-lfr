include lfr-package.inc

inherit native

PROVIDES = "virtual/lfr-traplinker-native"
INHIBIT_DEFAULT_DEPS = "1"
INHIBIT_AUTOTOOLS_DEPS = "1"

do_install() {
    install -d ${D}${bindir}/lfr
    install -d ${D}${bindir}/lfr/license
    install -m 0755 ${S}/bin/traplinker ${D}${bindir}/lfr/traplinker
    install -m 0755 ${S}/bin/trapdump ${D}${bindir}/lfr/trapdump
    install -m 0644 ${S}/bin/traplinker_script.ld ${D}${bindir}/lfr/traplinker_script.ld
    install -m 0755 ${S}/bin/build_optimized_trap.py ${D}${bindir}/lfr/build_optimized_trap.py
    install -m 0755 ${S}/bin/parse_textrap.py ${D}${bindir}/lfr/parse_textrap.py
    install -m 0755 ${S}/bin/LicenseChecker ${D}${bindir}/lfr/LicenseChecker
    install -m 0644 ${S}/license/key.pub ${D}${bindir}/lfr/license/key.pub
}

COMPATIBLE_HOST = "(i.86|x86_64|arm|aarch64).*-linux"

# FIXME: for now, we're only building the native recipe,
# because that's all the package contains
#BBCLASSEXTEND = "nativesdk"
