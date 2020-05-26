include add-symlinks.inc

# We need g++ to build lfr
EXTRA_OECONF_remove = "--enable-languages=c"
EXTRA_OECONF_append = "--enable-languages=c,c++"
