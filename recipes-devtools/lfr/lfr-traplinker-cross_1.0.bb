inherit cross

include lfr.inc

PN = "lfr-traplinker-cross-${TARGET_ARCH}"

DEPENDS += " virtual/lfr-traplinker-native "

deltask do_fetch
deltask do_unpack
deltask do_patch
deltask do_configure
deltask do_compile
deltask do_populate_lic

do_install () {
    n_d=`readlink -m ${D}${bindir}/../lfr`
    c_d=`readlink -m ${D}${bindir}/lfr`
    t_d=$c_d/${TARGET_SYS}
    install -d $c_d
    install -d $t_d
    for x in traplinker trapdump license; do
        lnr $n_d/$x $c_d/$x
        lnr $n_d/$x $t_d/$x
    done
    for x in ld ld.bfd ld.gold; do
        lnr $c_d/traplinker $c_d/${TARGET_PREFIX}$x
        lnr $c_d/traplinker $t_d/$x
    done
}

do_install_append_lfr-replace-ld () {
    # If we renamed `ld`&friends to `ld.original`, then create our own
    # symlinks from `ld` to `traplinker`
    cd ${D}${bindir}
    for x in ld ld.bfd ld.gold; do
        lnr lfr/traplinker ${TARGET_PREFIX}$x
    done
}
