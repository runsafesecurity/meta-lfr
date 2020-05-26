# gcc-cross installs binutils symlinks into `/usr/libexec/gcc`
# Mainly `ld` -> `/usr/bin/${TARGET_PREFIX}ld
# We need to add `.original` versions of these symlinks for LFR
do_install_append () {
    cd ${D}${libexecdir}/gcc/${TARGET_SYS}/${BINV}
    for x in ld ld.bfd ld.gold lld; do
        y=${TARGET_PREFIX}$x
        if [ -h $x ]; then
            ln -sf ${BINRELPATH}/$y.original $x.original
        fi
        if [ -h $y ]; then
            ln -sf ${BINRELPATH}/$y.original $y.original
        fi
    done
}
