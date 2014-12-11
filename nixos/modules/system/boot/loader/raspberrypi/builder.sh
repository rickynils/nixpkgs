#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

default=$1
if test -z "$1"; then
    echo "Syntax: builder.sh <DEFAULT-CONFIG>"
    exit 1
fi

echo "updating the boot generations directory..."

outdir=/boot/old
mkdir -p $outdir || true

# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g'
}

# Copy a file from the Nix store to /boot/kernels.
declare -A filesCopied

copyToKernelsDir() {
    local src="$1"
    local dst="/boot/old/$(cleanName $src)"
    # Don't copy the file if $dst already exists.  This means that we
    # have to create $dst atomically to prevent partially copied
    # kernels or initrd if this script is ever interrupted.
    if ! test -e $dst; then
        local dstTmp=$dst.tmp.$$
        cp $src $dstTmp
        mv $dstTmp $dst
    fi
    filesCopied[$dst]=1
    result=$dst
}

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

addEntry() {
    local path="$1"
    local generation="$2"

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local sysdir=$(readlink -f "$path")
    local kernel=$sysdir/kernel
    local initrd=$sysdir/initrd

    if test -n "@copyKernels@"; then
        copyToKernelsDir $kernel; kernel=$result
        copyToKernelsDir $initrd; initrd=$result
    fi

    echo $sysdir > $outdir/$generation-system
    echo $sysdir/init > $outdir/$generation-init
    echo "`cat "$sysdir/kernel-params"` systemConfig=$sysdir init=$sysdir/init" > $outdir/$generation-cmdline.txt
    echo "initramfs initrd" | cat - "@rpiBootConfig@" > $outdir/$generation-config.txt
    echo $initrd > $outdir/$generation-initrd
    echo $kernel > $outdir/$generation-kernel

    for f in system init cmdline.txt config.txt initrd kernel; do
      filesCopied[$outdir/$generation-$f]=1
    done

    if test "$sysdir" = "$default"; then
      copyForced $kernel /boot/kernel.img
      copyForced $initrd /boot/initrd
      copyForced $outdir/$generation-cmdline.txt /boot/cmdline.txt
      copyForced $outdir/$generation-config.txt /boot/config.txt
      echo "$generation" > /boot/defaultgeneration
    fi
}

# Add all generations of the system profile to the menu, in reverse
# (most recent to least recent) order.
for generation in $(
    (cd /nix/var/nix/profiles && ls -d system-*-link) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    link=/nix/var/nix/profiles/system-$generation-link
    addEntry $link $generation
done

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
copyForced $fwdir/bootcode.bin  /boot/bootcode.bin
copyForced $fwdir/fixup.dat     /boot/fixup.dat
copyForced $fwdir/fixup_cd.dat  /boot/fixup_cd.dat
copyForced $fwdir/fixup_x.dat   /boot/fixup_x.dat
copyForced $fwdir/start.elf     /boot/start.elf
copyForced $fwdir/start_cd.elf  /boot/start_cd.elf
copyForced $fwdir/start_x.elf   /boot/start_x.elf

# Remove obsolete files from /boot/old.
for fn in /boot/old/*; do
    if ! test "${filesCopied[$fn]}" = 1; then
        rm -vf -- "$fn"
    fi
done
