include lfr-package.inc
include lfr-common.inc

# We need this for objcopy
DEPENDS = "virtual/${TARGET_PREFIX}binutils"
INHIBIT_AUTOTOOLS_DEPS = "1"

do_install() {
    # TODO: install page-alignment libs and lfr-txtrp.o
    install -d ${D}${libdir}
    install -d ${D}${sbindir}
    install -m 0755 ${S}/bin/${LFR_ARCH}/CacheDaemon ${D}${sbindir}/lfr_cached
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/lfr_cached.service ${D}${systemd_unitdir}/system
    sed -i -e 's,@SBINDIR@,${sbindir},g' ${D}${systemd_unitdir}/system/lfr_cached.service
    install -m 0755 ${S}/bin/${LFR_ARCH}/liblfr.so ${D}${libdir}/liblfr.so
    install -m 0755 ${S}/bin/${LFR_ARCH}/liblfr.a ${D}${libdir}/liblfr.a
    for l in randoentry_exec randoentry_so; do
        install -m 0644 ${S}/bin/${LFR_ARCH}/lib$l.a ${D}${libdir}/lib$l.a
    done
    for l in trapheader trapfooter trapfooter_nopage; do
        install -m 0644 ${S}/bin/${LFR_ARCH}/lib$l.a ${D}${libdir}/lib$l.a
    done
}
