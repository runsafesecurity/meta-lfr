PROVIDES = "virtual/lfr"
INHIBIT_DEFAULT_DEPS = "1"
LFR_DISABLE = "1"

inherit systemd

PACKAGES += "${PN}-server"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE_${PN}-server = "lfr_cached.service"

def map_lfr_arch(bb, d, arch_var):
    a = d.getVar(arch_var)
    if a.startswith("aarch64"):
        return "arm64"
    else:
        return a

LFR_ARCH = "${@map_lfr_arch(bb, d, "TARGET_ARCH")}"

FILES_${PN} = "${libdir}/liblfr.so"
FILES_${PN}-server = "${sbindir}/lfr_cached"
FILES_${PN}-dev = "${libdir}/librandoentry*.a ${libdir}/libtrap*.a"
FILES_${PN}-staticdev = "${libdir}/liblfr.a"

RDEPENDS_${PN}-server = "libgcc glibc"

# The TrapLibs libraries go into lfr-dev,
# but there's a QA check that that package doesn't contain
# any static archives; we disable that check here
INSANE_SKIP_${PN}-dev = "staticdev"

COMPATIBLE_HOST = "(i.86|x86_64|arm|aarch64).*-linux"
