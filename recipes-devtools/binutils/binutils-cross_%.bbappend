do_install_append_lfr-keep-ld () {
    cd ${D}${bindir}
    # We create links from `ld.original` to `ld`,
    # so TrapLinker can call the original linker via the suffix
    for l in ${TARGET_PREFIX}ld*; do
        ln -s $l $l.original
    done
}

do_install_append_lfr-replace-ld () {
    cd ${D}${bindir}
    # Rename all aliases of the various linker binaries,
    # appending a ".original" suffix for LFR
    for l in ${TARGET_PREFIX}ld*; do
        mv $l $l.original
    done
}

DEPENDS_append_lfr-replace-ld = " virtual/lfr-traplinker-native lfr-traplinker-cross-${TARGET_ARCH} "
