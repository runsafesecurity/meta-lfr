
LFR_DISABLE ??= "0"
LFR_USE_TRAPV1 ??= "0"
LFR_REPLACE_LD ?= "0"

LFR_ROOT_PATH = "${STAGING_BINDIR_TOOLCHAIN}/lfr"
LFR_BPREFIX_ARGS = "-B${LFR_ROOT_PATH} -B${LFR_ROOT_PATH}/${TARGET_SYS}"

def lfr_dep_prepend(d):
    #if d.getVar('INHIBIT_DEFAULT_DEPS', False):
    #    return ''

    target_arch = d.getVar('TARGET_ARCH')
    if target_arch in ['none', 'allarch']:
        return ''

    if bb.data.inherits_class('allarch', d) and not d.getVar('MULTILIB_VARIANTS'):
        return ''

    deps = ""
    deps += "virtual/lfr-traplinker-native python3-pyelftools-native "
    deps += "lfr-traplinker-cross-${TARGET_ARCH} "
    if d.getVar('LFR_DISABLE', False) != "1":
        deps += "virtual/lfr "
    return deps

def lfr_cc_args_prepend(d):
    cc_args = ""
    if d.getVar('LFR_DISABLE', False) != "1":
        cc_args += "-ffunction-sections -fPIC "
        if d.getVar('LFR_REPLACE_LD', False) != "1":
            cc_args += "${LFR_BPREFIX_ARGS} "
    return cc_args

def lfr_ld_args_prepend(d):
    ld_args = ""
    if d.getVar('LFR_DISABLE', False) != "1":
        ld_args += "-Wl,--traplinker-force-pie -Wl,--gc-sections "
        if d.getVar('LFR_USE_TRAPV1', False) == "1":
            ld_args += "-Wl,--traplinker-trap-version=1 "
    return ld_args

BASEDEPENDS_append_class-target = " ${@lfr_dep_prepend(d)} "
PATH_prepend_class-target = "${LFR_ROOT_PATH}:"
TARGET_CC_ARCH_prepend_class-target = "${@lfr_cc_args_prepend(d)} "
TARGET_LDFLAGS_prepend_class-target = "${@lfr_ld_args_prepend(d)} "

python () {
    if d.getVar('LFR_REPLACE_LD', False) == "1":
        d.appendVar('OVERRIDES', ':lfr-replace-ld')
    else:
        d.appendVar('OVERRIDES', ':lfr-keep-ld')
}

export LFR_ROOT_PATH
export ALKEMIST_LICENSE_KEY

export LFR_ORIGINAL_LINKER_SUFFIX = ".original"
export LFR_TRAPLINKER_DISABLE = "${LFR_DISABLE}"

# Work around GCC bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91629
# gcc-ar is broken in the yocto build environment because it uses
# GCC_EXEC_PREFIX incorrectly
export LFR_ORIGINIAL_AR = "${@d.getVar('AR').replace('gcc-ar', 'ar')}"

export LFR_PYTHONPATH = "${STAGING_DIR_NATIVE}/usr/lib/python3.8/site-packages"

# Disable LFR for certain packages
# - glibc&gcc libraries
LFR_DISABLE_pn-glibc = "1"
LFR_DISABLE_pn-glibc-initial = "1"
LFR_DISABLE_pn-libgcc-initial = "1"
# - Kernels & kernel headers
# This recipe doesn't build any binaries, but is required
# by other core ones like glibc-initial
LFR_DISABLE_pn-linux-libc-headers = "1"
LFR_DISABLE_pn-linux-yocto = "1"
LFR_DISABLE_pn-linux-raspberrypi = "1"
LFR_DISABLE_pn-linux-aspeed = "1"
# - Debugging tools
LFR_DISABLE_pn-gdb = "1"
LFR_DISABLE_pn-strace = "1"
# - Other recipes
LFR_DISABLE_pn-gcc = "1"
LFR_DISABLE_pn-quota = "1"
LFR_DISABLE_pn-sysklogd = "1"
LFR_DISABLE_pn-u-boot-aspeed = "1"


# Use TRaPv1 instead of the faster TRaPv2 for python because the TRaPv2 builder
# is python3 and the python2 build system interferes with this.
LFR_USE_TRAPV1_pn-python = "1"

# cairo doesn't configure correctly with --gc-sections because
# it tries to detect target endianness by compiling a float variable
# down into a string that's either "seesnoon" or "noonsees"
# and greps over the output of `strings` to find out which one.
# Adding `--gc-sections` removes that float global altogether from
# the binary, so the check fails
TARGET_LDFLAGS_remove_class-target_pn-cairo = "-Wl,--gc-sections"
