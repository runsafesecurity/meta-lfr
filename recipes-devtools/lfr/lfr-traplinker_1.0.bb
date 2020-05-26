include lfr.inc

inherit cmake

DEPENDS += "elfutils openssl boost"
PROVIDES = "virtual/lfr-traplinker"

EXTRA_OECMAKE = " -DSR_BUILD_MODULES='TrapLinker;TrapDump' "

do_install() {
    install -d ${D}${bindir}/lfr
    install -m 0755 ${B}/src/TrapLinker/posix/traplinker ${D}${bindir}/lfr/traplinker
    install -m 0755 ${B}/src/TrapInfo/trapdump ${D}${bindir}/lfr/trapdump
    install -m 0644 ${S}/src/TrapLinker/posix/traplinker_script.ld ${D}${bindir}/lfr/traplinker_script.ld
    install -m 0644 ${S}/src/scripts/build_optimized_trap.py ${D}${bindir}/lfr/build_optimized_trap.py
    install -m 0644 ${S}/src/scripts/parse_textrap.py ${D}${bindir}/lfr/parse_textrap.py
}

COMPATIBLE_HOST = "(i.86|x86_64|arm|aarch64).*-linux"

RDEPENDS_${PN}_class-target += "grep"

BBCLASSEXTEND = "native nativesdk"
