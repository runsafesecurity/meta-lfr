# We need to disable TrapLinker altogether for the configure step,
# otherwise glibc fails to either configure or build
TARGET_CC_ARCH_append_task-configure_lfr-enabled = " -Wl,--traplinker-disable"
TARGET_LDFLAGS_append_task-configure_lfr-enabled = " -Wl,--traplinker-disable"
TARGET_LDFLAGS_remove_task-configure_lfr-enabled = "-Wl,--traplinker-force-pie"

# glibc on dunfell doesn't build at all with --gc-sections,
# and configure fails on all versions with this
TARGET_LDFLAGS_remove = "-Wl,--gc-sections"

# glibc really doesn't like fPIC being forced in
TARGET_CC_ARCH_remove = "-fPIC"

do_configure_append_lfr-enabled () {
    echo "build-pic-default=yes" >> ${B}/configparms

    echo "LDFLAGS += -Wl,--traplinker-enable" >> ${B}/configparms
    echo "LDFLAGS += -Wl,--traplinker-no-pic-warning" >> ${B}/configparms
    echo "LDFLAGS += -Wl,--traplinker-force-pie" >> ${B}/configparms
    # Prevent a circular reference during linking:
    # libdl.so -> liblfr.so -> libdl.so
    echo "LDFLAGS += -Wl,--traplinker-no-libdl" >> ${B}/configparms

    # We can't randomize the loader (yet)
    echo "LDFLAGS-rtld += -Wl,--traplinker-disable" >> ${B}/configparms

    # These are static binaries, currently broken
    echo "LDFLAGS-sln += -Wl,--traplinker-disable" >> ${B}/configparms
    echo "LDFLAGS-ldconfig += -Wl,--traplinker-disable" >> ${B}/configparms
}
