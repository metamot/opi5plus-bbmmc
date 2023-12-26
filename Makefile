PWD=$(shell pwd)
# Add sync for ESD-touch when Opi5 imidiately shutdown from ESD-touch #SYNC=
SYNC=sync
# How many parrallel jobs? If anything is wrong, pls use only ONE, i.e. "make JOBS=-j1"
JOBS=-j12
#Verbose - default minimal (=0) , set VERB=1 to lots of verbose
VERB=0
# You can create logs if VERB=1 and redirect "1"(stdout) to file and "2"(stderr) to file, like this:
# $ make JOBS=-j1 VERB=1 1>1.txt 2>2.txt
# see 1.txt and 2.txt for more info

# BRD=opi5 # not supported
BRD=opi5plus

ifeq ($(BRD),opi5)
UBOOT_DEFCONFIG=uboot_opi5_my_defconfig
else
ifeq ($(BRD),opi5plus)
UBOOT_DEFCONFIG=uboot_opi5plus_my_defconfig
else
$(error BRD is not set as BRD=opi5 or BRD=opi5plus)
endif
endif

#BL31_FILE=rk3588_bl31_v1.28.elf
BL31_FILE=bl31.elf

#KERNEL_CONFIG=linux-rockchip-rk3588-legacy.config
KERNEL_CONFIG=kernel_my_config

BUSYBOX_CONFIG=busybox_my_config

RK3588_FLAGS = -mcpu=cortex-a76.cortex-a55+crypto
BASE_OPT_FLAGS = $(RK3588_FLAGS) -Os
OPT_FLAGS = CFLAGS="$(BASE_OPT_FLAGS)" CPPFLAGS="$(BASE_OPT_FLAGS)" CXXFLAGS="$(BASE_OPT_FLAGS)"

#echo | gcc -mcpu=cortex-a76.cortex-a55+crypto+sve -xc - -o - -S | grep arch


### LFS
LFS=$(PWD)/lfs
LFS_HST=aarch64-linux-gnu
LFS_TGT=aarch64-cross-linux-gnu

GLIBC_VER=2.32
BINUTILS_VER=2.35
MPFR_VER=4.1.0
GMP_VER=6.2.0
MPC_VER=1.1.0
GCC_VER=10.2.0
M4_VER=1.4.18
NCURSES_VER=6.2
BASH_VER=5.0
CORE_UTILS_VER=8.32
DIFF_UTILS_VER=3.7
FILE_VER=5.39
FIND_UTILS_VER=4.7.0
GAWK_VER=5.1.0
GREP_VER=3.4
GZIP_VER=1.10
MAKE_VER=4.3
PATCH_VER=2.7.6
SED_VER=4.8
TAR_VER=1.32
XZ_VER=5.2.5

BINUTILS_OPT+= --with-sysroot=$(LFS)
BINUTILS_OPT+= --prefix=$(LFS)/tools
BINUTILS_OPT+= --target=$(LFS_TGT)
BINUTILS_OPT+= --disable-nls
BINUTILS_OPT+= --disable-werror
BINUTILS_OPT+= $(OPT_FLAGS)

BINUTILS_OPT2+= --prefix=/usr
#BINUTILS_OPT2+= --build=$(../config.guess)
BINUTILS_OPT2+= --host=$(LFS_TGT)
BINUTILS_OPT2+= --disable-nls
BINUTILS_OPT2+= --enable-shared
BINUTILS_OPT2+= --disable-werror
BINUTILS_OPT2+= --enable-64-bit-bfd
#BINUTILS_OPT2+= --with-build-sysroot=$(LFS)
#BINUTILS_OPT2+= AR_FOR_TARGET=$(LFS_TGT)-ar
#BINUTILS_OPT2+= --with-build-time-tools=$(LFS)/tools/bin
BINUTILS_OPT2+= $(OPT_FLAGS)

GCC_OPT+= --with-sysroot=$(LFS)
GCC_OPT+= --prefix=$(LFS)/tools
GCC_OPT+= --target=$(LFS_TGT)
GCC_OPT+= --with-glibc-version=2.11
GCC_OPT+= --with-newlib
GCC_OPT+= --without-headers
GCC_OPT+= --enable-initfini-array
GCC_OPT+= --disable-nls
GCC_OPT+= --disable-shared
GCC_OPT+= --disable-multilib
GCC_OPT+= --disable-decimal-float
GCC_OPT+= --disable-threads
GCC_OPT+= --disable-libatomic
GCC_OPT+= --disable-libgomp
GCC_OPT+= --disable-libquadmath
GCC_OPT+= --disable-libssp
GCC_OPT+= --disable-libvtv
GCC_OPT+= --disable-libstdcxx
GCC_OPT+= --enable-languages=c,c++
GCC_OPT+= $(OPT_FLAGS)


#GCC_OPT2+= --build=$(../config.guess)
GCC_OPT2+= --host=$(LFS_TGT)
GCC_OPT2+= --prefix=/usr
#GCC_OPT2+= CC_FOR_TARGET=$(LFS_TGT)-gcc
GCC_OPT2+= --with-build-sysroot=$(LFS)
GCC_OPT2+= --enable-initfini-array
GCC_OPT2+= --disable-nls
GCC_OPT2+= --disable-multilib
GCC_OPT2+= --disable-decimal-float
GCC_OPT2+= --disable-libatomic
GCC_OPT2+= --disable-libgomp
GCC_OPT2+= --disable-libquadmath
GCC_OPT2+= --disable-libssp
GCC_OPT2+= --disable-libvtv
GCC_OPT2+= --disable-libstdcxx
GCC_OPT2+= --enable-languages=c,c++
GCC_OPT2+= $(OPT_FLAGS)

GLIBC_OPT+= --prefix=/usr
GLIBC_OPT+= --host=$(LFS_TGT)
GLIBC_OPT+= --enable-kernel=3.2
GLIBC_OPT+= --with-headers=$(LFS)/usr/include
GLIBC_OPT+= --without-selinux
GLIBC_OPT+= $(OPT_FLAGS)
      
LIBCPP_OPT+= --host=$(LFS_TGT)
LIBCPP_OPT+= --prefix=/usr
LIBCPP_OPT+= --disable-multilib
LIBCPP_OPT+= --disable-nls
LIBCPP_OPT+= --disable-libstdcxx-pch
#LIBCPP_OPT+= --with-gxx-include-dir=$(LFS)/tools/$(LFS_TGT)/include/c++/$(GCC_VER)
LIBCPP_OPT+= --with-gxx-include-dir=/tools/$(LFS_TGT)/include/c++/$(GCC_VER)
LIBCPP_OPT+= $(OPT_FLAGS)

M4_OPT+= --prefix=/usr
M4_OPT+= --host=$(LFS_TGT)
M4_OPT+= $(OPT_FLAGS)


NCURSES_OPT+= --prefix=/usr
NCURSES_OPT+= --host=$(LFS_TGT)
#NCURSES_OPT+= --build=$(./config.guess)
#NCURSES_OPT+= --mandir=/usr/share/man
#NCURSES_OPT+= --with-manpage-format=normal

NCURSES_OPT+= --without-manpages
#NCURSES_OPT+= --with-default-terminfo-dir=/usr/share/terminfo
NCURSES_OPT+= --with-shared
#NCURSES_OPT+= --without-gpm
NCURSES_OPT+= --without-debug
NCURSES_OPT+= --without-ada
#NCURSES_OPT+= --without-normal
#NCURSES_OPT+= --without-cxx
#NCURSES_OPT+= --without-cxx-binding
#NCURSES_OPT+= --disable-db-install

NCURSES_OPT+= --with-termlib
NCURSES_OPT+= --with-ticlib
NCURSES_OPT+= --enable-widec

NCURSES_OPT+= $(OPT_FLAGS)


BASH_OPT+= --prefix=/usr
#BASH_OPT+= --build=$(support/config.guess)
BASH_OPT+= --host=$(LFS_TGT)
BASH_OPT+= --without-bash-malloc
BASH_OPT+= $(OPT_FLAGS)

CORE_UTILS_OPT+= --prefix=/usr
CORE_UTILS_OPT+= --host=$(LFS_TGT)
#CORE_UTILS_OPT+= --build=$(build-aux/config.guess)
CORE_UTILS_OPT+= --enable-install-program=hostname
CORE_UTILS_OPT+= --enable-no-install-program=kill,uptime

#CORE_UTILS_OPT+= --disable-acl
#CORE_UTILS_OPT+= --disable-libcap
#CORE_UTILS_OPT+= --disable-rpath
#CORE_UTILS_OPT+= --disable-single-binary
#CORE_UTILS_OPT+= --disable-xattr
#CORE_UTILS_OPT+= --without-gmp
#CORE_UTILS_OPT+= --enable-install-program=ln,realpath
#CORE_UTILS_OPT+= --enable-no-install-program=date
CORE_UTILS_OPT+= --without-selinux
CORE_UTILS_OPT+= $(OPT_FLAGS)

DIFF_UTILS_OPT+= --prefix=/usr
DIFF_UTILS_OPT+= --host=$(LFS_TGT)
DIFF_UTILS_OPT+= $(OPT_FLAGS)

FILE_OPT+= --prefix=/usr
FILE_OPT+= --host=$(LFS_TGT)
FILE_OPT+= $(OPT_FLAGS)

FIND_UTILS_OPT+= --prefix=/usr
FIND_UTILS_OPT+= --host=$(LFS_TGT)
FIND_UTILS_OPT+= --without-selinux
FIND_UTILS_OPT+= $(OPT_FLAGS)

GAWK_OPT+= --prefix=/usr
GAWK_OPT+= --host=$(LFS_TGT)
GAWK_OPT+= $(OPT_FLAGS)

GREP_OPT+= --prefix=/usr
GREP_OPT+= --host=$(LFS_TGT)
#GREP_OPT+= --bindir=/bin
GREP_OPT+= $(OPT_FLAGS)

GZIP_OPT+= --prefix=/usr
GZIP_OPT+= --host=$(LFS_TGT)
GZIP_OPT+= $(OPT_FLAGS)

MAKE_OPT+= --prefix=/usr
MAKE_OPT+= --without-guile
MAKE_OPT+= --host=$(LFS_TGT)
MAKE_OPT+= $(OPT_FLAGS)

PATCH_OPT+= --prefix=/usr
PATCH_OPT+= --host=$(LFS_TGT)
PATCH_OPT+= $(OPT_FLAGS)

SED_OPT+= --prefix=/usr
SED_OPT+= --host=$(LFS_TGT)
#SED_OPT+= --bindir=/bin
SED_OPT+= --without-selinux
SED_OPT+= $(OPT_FLAGS)

TAR_OPT+= --prefix=/usr
TAR_OPT+= --host=$(LFS_TGT)
#TAR_OPT+= --bindir=/bin
TAR_OPT+= --without-selinux
TAR_OPT+= $(OPT_FLAGS)

XZ_OPT+= --prefix=/usr
XZ_OPT+= --host=$(LFS_TGT)
XZ_OPT+= --disable-static
XZ_OPT+= --docdir=/usr/share/doc/xz-5.2.5
XZ_OPT+= $(OPT_FLAGS)

###


all: deps pkg mmc

clean: clean_uboot clean_linux
	rm -fr tmp
clean_uboot:
	rm -fr parts/u-boot/blobs/bl31.elf
	rm -fr parts/u-boot/boot
	rm -fr parts/u-boot/build
	rm -fr parts/u-boot/trusted/build
	rm -fr parts/u-boot/build*
	rm -fr parts/u-boot/*.bin
	rm -fr parts/u-boot/*.img
	rm -fr out/fat/boot.scr
	rm -fr out/fat/orangepiEnv.txt
clean_kernel:
	rm -fr parts/kernel/bld
	rm -fr out/fat/dtb
	rm -fr out/fat/Image
	rm -fr out/rd/kermod
easyclean:
	rm -fr tmp
	rm -fr parts
	rm -fr out
clean_pkg:
	rm -fr pkg
deepclean: easyclean clean_pkg
help:
	@echo ""
	@echo "BRD=$(BRD), UbootCfg=$(UBOOT_DEFCONFIG), jobs=$(JOBS), verbose=$(VERB), cur_prj_dir=$(PWD), opt=$(BASE_OPT_FLAGS)"
	@echo ""
	@echo 'make deps                      - Install Hosts-Deps (sudo required)'
	@echo 'make pkg                       - Download all packages before build'
	@echo 'WARNING: You need use "make deps" and "make pkg" only once BEFORE start'
	@echo ""
	@echo 'make mmc                       - Build "mmc.img"'
	@echo 'make flash                     - Flash "mmc.img" via USB'
	@echo 'make write_tst                 - Check for microSD present in slot'
	@echo 'make write_run                 - Write "mmc.img" microSD'
	@echo ""
	

# #############################################################################
deps:
	sudo apt install -y zstd u-boot-tools dosfstools libudev-dev libusb-1.0-0-dev dh-autoreconf texinfo libisl23 libisl-dev python gawk gettext
# #############################################################################

PKG+=pkg/binutils-$(BINUTILS_VER).tar.xz
PKG+=pkg/mpfr-$(MPFR_VER).tar.xz
PKG+=pkg/gmp-$(GMP_VER).tar.xz
PKG+=pkg/mpc-$(MPC_VER).tar.gz
PKG+=pkg/gcc-$(GCC_VER).tar.xz
PKG+=pkg/glibc-$(GLIBC_VER).tar.xz
PKG+=pkg/glibc-$(GLIBC_VER)-fhs-1.patch
PKG+=pkg/m4-$(M4_VER).tar.xz
PKG+=pkg/ncurses-$(NCURSES_VER).tar.gz
PKG+=pkg/bash-$(BASH_VER).tar.gz
PKG+=pkg/coreutils-$(CORE_UTILS_VER).tar.xz
PKG+=pkg/diffutils-$(DIFF_UTILS_VER).tar.xz
PKG+=pkg/file-$(FILE_VER).tar.gz
PKG+=pkg/findutils-$(FIND_UTILS_VER).tar.xz
PKG+=pkg/gawk-$(GAWK_VER).tar.xz
PKG+=pkg/grep-$(GREP_VER).tar.xz
PKG+=pkg/gzip-$(GZIP_VER).tar.xz
PKG+=pkg/make-$(MAKE_VER).tar.gz
PKG+=pkg/patch-$(PATCH_VER).tar.xz
PKG+=pkg/sed-$(SED_VER).tar.xz
PKG+=pkg/tar-$(TAR_VER).tar.xz
PKG+=pkg/xz-$(XZ_VER).tar.xz



pkg: pkg/orangepi5-atf.cpio.zst pkg/orangepi5-rkbin-only_rk3588.cpio.zst pkg/orangepi5-uboot.cpio.zst pkg/orangepi5-linux510-xunlong.cpio.zst pkg/busybox.cpio.zst pkg/rkdeveloptool.cpio.zst $(PKG)

pkg/orangepi5-atf.cpio.zst:
	@echo ""
	@echo "=== Download ATF(ArmTrustedFirmware) Sources ==="
	mkdir -p pkg
	rm -fr tmp/orangepi5-atf
	mkdir -p tmp/orangepi5-atf
	git clone https://review.trustedfirmware.org/TF-A/trusted-firmware-a tmp/orangepi5-atf
	cd tmp/orangepi5-atf && git fetch https://review.trustedfirmware.org/TF-A/trusted-firmware-a refs/changes/40/21840/5 && git checkout -b change-21840 FETCH_HEAD
	@echo "--- Pack ATF-Sources (with RK3588 support) ---"
	cd tmp/orangepi5-atf && find . -print0 | cpio -o0H newc | zstd -z9T9 > ../../pkg/orangepi5-atf.cpio.zst
	rm -fr tmp/orangepi5-atf
	$(SYNC)
	@echo "... Done! ...."
	@echo ""
pkg/orangepi5-rkbin-only_rk3588.cpio.zst:
	@echo ""
	@echo "=== Download RKBIN-RK3588(OrangePi5) ==="
	mkdir -p pkg
	rm -fr tmp/orangepi5-rkbin
	mkdir -p tmp/orangepi5-rkbin
	git clone https://github.com/armbian/rkbin tmp/orangepi5-rkbin
	@echo "--- Pack only RK3588 bins ---"
	cd tmp/orangepi5-rkbin/rk35 && find rk3588* -print0 | cpio -o0H newc | zstd -z9T9 > ../../../pkg/orangepi5-rkbin-only_rk3588.cpio.zst
	rm -fr tmp/orangepi5-rkbin
	$(SYNC)
	@echo "... Done! ...."
	@echo ""
pkg/orangepi5-uboot.cpio.zst:
	@echo ""
	@echo "=== Download RK3588_ORANGEPI5-UBOOT ==="
	mkdir -p pkg
	rm -fr tmp/orangepi5-uboot
	mkdir -p tmp/orangepi5-uboot
	git clone https://github.com/orangepi-xunlong/u-boot-orangepi.git -b v2017.09-rk3588 tmp/orangepi5-uboot
	@echo "--- Pack RK3588_ORANGEPI5-UBOOT as cpio.zst ---"
	cd tmp/orangepi5-uboot && find . -print0 | cpio -o0H newc | zstd -z9T9 > ../../pkg/orangepi5-uboot.cpio.zst
	rm -fr tmp/orangepi5-uboot
	$(SYNC)
	@echo "... Done! ...."
	@echo ""
pkg/orangepi5-linux510-xunlong.cpio.zst:
	@echo ""
	@echo "=== Download RK3588_LINUX_5.10_KERNEL ==="
	mkdir -p pkg
	mkdir -p tmp/orangepi5-linux510-xunlong
	git clone https://github.com/orangepi-xunlong/linux-orangepi.git -b orange-pi-5.10-rk3588 tmp/orangepi5-linux510-xunlong
	@echo "--- Pack RK3588_ORANGEPI5-LINUX_5.10 as cpio.zst ---"
	cd tmp/orangepi5-linux510-xunlong && find . -print0 | cpio -o0H newc | zstd -z4T9 > ../../pkg/orangepi5-linux510-xunlong.cpio.zst
	rm -fr tmp/orangepi5-linux510-xunlong
	$(SYNC)
	@echo "... Done! ...."
	@echo ""
pkg/busybox.cpio.zst:
	@echo ""
	@echo "=== Download BUSYBOX ==="
	mkdir -p pkg
	mkdir -p tmp/busybox
	git clone https://git.busybox.net/busybox -b 1_36_stable tmp/busybox
	@echo "--- Pack BUSYBOX as cpio.zst ---"
	cd tmp/busybox && find . -print0 | cpio -o0H newc | zstd -z9T9 > ../../pkg/busybox.cpio.zst
	rm -fr tmp/busybox
	$(SYNC)
	@echo "... Done! ...."
	@echo ""
pkg/rkdeveloptool.cpio.zst:
	@echo ""
	@echo "=== Download rkdeveloptool ==="
	mkdir -p pkg
	mkdir -p tmp/rkdeveloptool
	git clone https://github.com/rockchip-linux/rkdeveloptool tmp/rkdeveloptool
	sed -i "1491s/buffer\[5\]/buffer\[558\]/" tmp/rkdeveloptool/main.cpp
	rm -fr tmp/rkdeveloptool/.git
	@echo "--- Pack rkdeveloptool as cpio.zst ---"
	cd tmp/rkdeveloptool && find . -print0 | cpio -o0H newc | zstd -z9T9 > ../../pkg/rkdeveloptool.cpio.zst
	rm -fr tmp/rkdeveloptool
	$(SYNC)
	@echo "... Done! ...."
	@echo ""

# #############################################################################
parts/u-boot/v2017.09-rk3588/Makefile: pkg/orangepi5-uboot.cpio.zst
	mkdir -p parts/u-boot/v2017.09-rk3588
	pv pkg/orangepi5-uboot.cpio.zst | zstd -d | cpio -iduH newc -D parts/u-boot/v2017.09-rk3588
	cp -far cfg/$(UBOOT_DEFCONFIG) parts/u-boot/v2017.09-rk3588/configs
	sed -i "s/-march=armv8-a+nosimd/$(RK3588_FLAGS)/" parts/u-boot/v2017.09-rk3588/arch/arm/Makefile
	sed -i "s/-O2/$(BASE_OPT_FLAGS)/" parts/u-boot/v2017.09-rk3588/Makefile
	sed -i "s/CONFIG_BOOTDELAY=3/CONFIG_BOOTDELAY=0/" parts/u-boot/v2017.09-rk3588/configs/orangepi_5_defconfig
	sed -i "s/CONFIG_BOOTDELAY=3/CONFIG_BOOTDELAY=0/" parts/u-boot/v2017.09-rk3588/configs/orangepi_5b_defconfig
	sed -i "s/CONFIG_BOOTDELAY=3/CONFIG_BOOTDELAY=0/" parts/u-boot/v2017.09-rk3588/configs/orangepi_5_plus_defconfig
ifeq ($(UBOOT_DEFCONFIG),uboot_opi5plus_my_defconfig)
# If USB removed -- begin
	sed -i "s/obj-\$$(CONFIG_USB_OHCI_NEW)/# obj-\$$(CONFIG_USB_OHCI_NEW)/" parts/u-boot/v2017.09-rk3588/drivers/usb/host/Makefile
# If USB removed -- end
endif
	sed -i "s/U-Boot SPL board init/U-Boot SPL my board init/" parts/u-boot/v2017.09-rk3588/arch/arm/mach-rockchip/spl.c
	$(SYNC)
parts/u-boot/build_mkimage/.config: parts/u-boot/v2017.09-rk3588/Makefile
	mkdir -p parts/u-boot/build_mkimage
	cd parts/u-boot/v2017.09-rk3588 && make O=../build_mkimage V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- $(UBOOT_DEFCONFIG)
	$(SYNC)
parts/u-boot/build_mkimage/tools/mkimage: parts/u-boot/build_mkimage/.config
	mkdir -p parts/u-boot/build_mkimage
	cd parts/u-boot/v2017.09-rk3588 && make O=../build_mkimage V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- $(JOBS) tools
	$(SYNC)
# #############################################################################
## Uboot BUILD
parts/u-boot/trusted/Makefile: pkg/orangepi5-atf.cpio.zst
	mkdir -p parts/u-boot/trusted
	pv pkg/orangepi5-atf.cpio.zst | zstd -d | cpio -iduH newc -D parts/u-boot/trusted
	sed -i "s/ASFLAGS		+=	\$$(march-directive)/ASFLAGS += $(RK3588_FLAGS)/" parts/u-boot/trusted/Makefile
	sed -i "s/TF_CFLAGS   +=	\$$(march-directive)/TF_CFLAGS += $(RK3588_FLAGS)/" parts/u-boot/trusted/Makefile
	$(SYNC)
parts/u-boot/blobs/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin: pkg/orangepi5-rkbin-only_rk3588.cpio.zst
	mkdir -p parts/u-boot/blobs
	pv pkg/orangepi5-rkbin-only_rk3588.cpio.zst | zstd -d | cpio -iduH newc -D parts/u-boot/blobs
	$(SYNC)
parts/u-boot/v2017.09-rk3588/arch/arm/mach-rockchip/make_fit_atf.sh: parts/u-boot/v2017.09-rk3588/Makefile 
	@echo "... Patch ::: arch/arm/mach-rockchip/make_fit_atf.sh ..."
	sed -i '8s/source .\//source /' $@
	$(SYNC)
parts/u-boot/v2017.09-rk3588/arch/arm/mach-rockchip/fit_nodes.sh: parts/u-boot/v2017.09-rk3588/arch/arm/mach-rockchip/make_fit_atf.sh
	@echo "... Patch ::: arch/arm/mach-rockchip/fit_nodes.sh ..."
	sed -i '9s/source .\//source /' $@
	$(SYNC)
parts/u-boot/build/arch/arm/mach-rockchip/decode_bl31.py: parts/u-boot/v2017.09-rk3588/arch/arm/mach-rockchip/fit_nodes.sh
	@echo "... Patch ::: Copy PY-files ..."
	mkdir -p parts/u-boot/build/arch/arm/mach-rockchip
	cp -far --no-preserve=timestamps parts/u-boot/v2017.09-rk3588/arch/arm/mach-rockchip/*.py parts/u-boot/build/arch/arm/mach-rockchip
	$(SYNC)
parts/u-boot/trusted/build/rk3588/release/bl31/bl31.elf: parts/u-boot/trusted/Makefile
	cd parts/u-boot/trusted && make V=$(VERB) $(JOBS) CROSS_COMPILE=aarch64-linux-gnu- PLAT=rk3588 bl31
	$(SYNC)
parts/u-boot/blobs/bl31.elf: parts/u-boot/trusted/build/rk3588/release/bl31/bl31.elf
	ln -sf ../trusted/build/rk3588/release/bl31/bl31.elf $@
	$(SYNC)
parts/u-boot/v2017.09-rk3588/configs/$(UBOOT_DEFCONFIG): parts/u-boot/v2017.09-rk3588/Makefile
	cp -far cfg/$(UBOOT_DEFCONFIG) parts/u-boot/v2017.09-rk3588/configs
	touch $@
parts/u-boot/build/.config: parts/u-boot/build/arch/arm/mach-rockchip/decode_bl31.py parts/u-boot/blobs/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin parts/u-boot/blobs/bl31.elf parts/u-boot/v2017.09-rk3588/configs/$(UBOOT_DEFCONFIG)
	cd parts/u-boot/v2017.09-rk3588 && make O=../build V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- $(UBOOT_DEFCONFIG) && touch ../build/.config
	$(SYNC)
uboot_config: parts/u-boot/build/.config
parts/u-boot/build/spl/u-boot-spl.bin: parts/u-boot/build/.config
	cd parts/u-boot/v2017.09-rk3588 && make O=../build V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- $(JOBS) spl/u-boot-spl.bin && touch ../build/spl/u-boot-spl.bin
	$(SYNC)
parts/u-boot/build/u-boot.itb: parts/u-boot/build/.config parts/u-boot/build/spl/u-boot-spl.bin
	mkdir -p parts/u-boot/build
	cd parts/u-boot/v2017.09-rk3588 && make O=../build V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- $(JOBS) BL31=../blobs/$(BL31_FILE) u-boot.dtb u-boot.itb
	$(SYNC)
parts/u-boot/uboot-head.bin: parts/u-boot/build_mkimage/tools/mkimage parts/u-boot/build/spl/u-boot-spl.bin parts/u-boot/blobs/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin
	$< -n rk3588 -T rksd -d "parts/u-boot/blobs/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin:parts/u-boot/build/spl/u-boot-spl.bin" $@
	$(SYNC)
parts/u-boot/uboot-tail.bin: parts/u-boot/build/u-boot.itb
	ln -sf build/u-boot.itb $@
# Don't use qspi.img if mtd-devices disabled in u-boot !!!
parts/u-boot/qspi.img: parts/u-boot/uboot-head.bin parts/u-boot/uboot-tail.bin
	dd if=/dev/zero of=$@ bs=1M count=0 seek=4
	/sbin/parted -s $@ mklabel gpt
	/sbin/parted -s $@ unit s mkpart idbloader 64 1023
	/sbin/parted -s $@ unit s mkpart uboot 1024 7167
	dd if=parts/u-boot/uboot-head.bin of=$@ seek=64 conv=notrunc
	dd if=parts/u-boot/uboot-tail.bin of=$@ seek=1024 conv=notrunc
	$(SYNC)
out/fat/boot.scr: cfg/uboot_boot.cmd
	mkdir -p out/fat
	mkimage -C none -A arm -T script -d $< $@
#	parts/u-boot/build_mkimage/tools/mkimage -C none -A arm -T script -d boot.cmd $@
#	echo "0x61 0xdf 0x72 0xd7" | xxd -r > parts/u-boot/scr_4bytes.dat
#	dd of=$@ if=parts/u-boot/scr_4bytes.dat bs=1 seek=24 count=4 conv=notrunc
#	dd of=$@ if=/dev/zero bs=1 seek=68 count=4 conv=notrunc
	$(SYNC)
	touch $@
out/fat/orangepiEnv.txt: out/fat/boot.scr
#	cp -far orangepiEnv.txt out/fat/
	echo 'verbosity=1' > $@
	echo 'bootlogo=false' >> $@
	echo 'extraargs=cma=128M' >> $@
	echo 'overlay_prefix=rk3588' >> $@
	echo 'fdtfile=rockchip/rk3588-orangepi-5-plus.dtb' >> $@
	echo 'rootdev=UUID=0b9501f8-db3c-4b33-940a-7fce0931dc2c' >> $@
	$(SYNC)
	touch $@
uboot: parts/u-boot/uboot-head.bin parts/u-boot/uboot-tail.bin out/fat/orangepiEnv.txt

### Linux Out-Of-Src-Tree-BUILD

parts/kernel/src/MAINTAINERS: pkg/orangepi5-linux510-xunlong.cpio.zst
	mkdir -p parts/kernel/src
	pv pkg/orangepi5-linux510-xunlong.cpio.zst | zstd -d | cpio -iduH newc -D parts/kernel/src
	@echo ""
	@echo "=== Patching RK3588_LINUX_5.10_KERNEL SRC ==="
	sed -i "s/include \$$(TopDIR)\/drivers\/net\/wireless\/rtl88x2cs\/rtl8822c.mk/include \$$(src)\/rtl8822c.mk/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/Makefile
	sed -i "s/-I\$$(BCMDHD_ROOT)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rockchip_wlan\/rkwifi\/bcmdhd\/include/" parts/kernel/src/drivers/net/wireless/rockchip_wlan/rkwifi/bcmdhd/Makefile
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rockchip_wlan\/rtl8852be\/include/" parts/kernel/src/drivers/net/wireless/rockchip_wlan/rtl8852be/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rockchip_wlan\/rtl8852be\/platform/" parts/kernel/src/drivers/net/wireless/rockchip_wlan/rtl8852be/Makefile
	sed -i "s/-I\$$(src)\/core\/crypto/-I\$$(src)\/..\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rockchip_wlan\/rtl8852be\/core\/crypto/" parts/kernel/src/drivers/net/wireless/rockchip_wlan/rtl8852be/common.mk
	sed -i "s/phl_path_d1 := \$$(src)/phl_path_d1 := \$$(src)\/..\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rockchip_wlan\/rtl8852be/" parts/kernel/src/drivers/net/wireless/rockchip_wlan/rtl8852be/phl/phl.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189es\/include/" parts/kernel/src/drivers/net/wireless/rtl8189es/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189es\/platform/" parts/kernel/src/drivers/net/wireless/rtl8189es/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189es\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8189es/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189es\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8189es/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189es\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8189es/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189fs\/include/" parts/kernel/src/drivers/net/wireless/rtl8189fs/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189fs\/platform/" parts/kernel/src/drivers/net/wireless/rtl8189fs/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189fs\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8189fs/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189fs\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8189fs/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8189fs\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8189fs/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8192eu\/include/" parts/kernel/src/drivers/net/wireless/rtl8192eu/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8192eu\/platform/" parts/kernel/src/drivers/net/wireless/rtl8192eu/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8192eu\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8192eu/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8192eu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8192eu/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8192eu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8192eu/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8812au\/include/" parts/kernel/src/drivers/net/wireless/rtl8812au/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8812au\/platform/" parts/kernel/src/drivers/net/wireless/rtl8812au/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8812au\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8812au/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8812au\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8812au/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8812au\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8812au/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8811cu\/include/" parts/kernel/src/drivers/net/wireless/rtl8811cu/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8811cu\/platform/" parts/kernel/src/drivers/net/wireless/rtl8811cu/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8811cu\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8811cu/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8811cu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8811cu/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8188eu\/include/" parts/kernel/src/drivers/net/wireless/rtl8188eu/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8188eu\/platform/" parts/kernel/src/drivers/net/wireless/rtl8188eu/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8188eu\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8188eu/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8188eu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8188eu/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8188eu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8188eu/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2bu\/include/" parts/kernel/src/drivers/net/wireless/rtl88x2bu/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2bu\/platform/" parts/kernel/src/drivers/net/wireless/rtl88x2bu/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2bu\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl88x2bu/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2bu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl88x2bu/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2bu\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl88x2bu/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2cs\/include/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2cs\/platform/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2cs\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/Makefile
	sed -i "s/-I\$$(src)\/core\/crypto/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2cs\/core\/crypto/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2cs\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl88x2cs\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl88x2cs/hal/phydm/sd4_phydm_2_kernel.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723ds\/include/" parts/kernel/src/drivers/net/wireless/rtl8723ds/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723ds\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8723ds/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723ds\/platform/" parts/kernel/src/drivers/net/wireless/rtl8723ds/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723ds\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8723ds/Makefile
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723du\/include/" parts/kernel/src/drivers/net/wireless/rtl8723du/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723du\/platform/" parts/kernel/src/drivers/net/wireless/rtl8723du/Makefile
	sed -i "s/-I\$$(src)\/hal/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723du\/hal/" parts/kernel/src/drivers/net/wireless/rtl8723du/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8723du\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8723du/hal/phydm/phydm.mk
	sed -i "s/-I\$$(src)\/include/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8822bs\/include/" parts/kernel/src/drivers/net/wireless/rtl8822bs/Makefile
	sed -i "s/-I\$$(src)\/platform/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8822bs\/platform/" parts/kernel/src/drivers/net/wireless/rtl8822bs/Makefile
	sed -i "s/-I\$$(src)\/hal\/btc/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8822bs\/hal\/btc/" parts/kernel/src/drivers/net/wireless/rtl8822bs/Makefile
	sed -i "s/-I\$$(src)\/hal\/phydm/-I\$$(src)\/..\/..\/..\/..\/..\/src\/drivers\/net\/wireless\/rtl8822bs\/hal\/phydm/" parts/kernel/src/drivers/net/wireless/rtl8822bs/hal/phydm/phydm.mk
	$(SYNC)
	@echo ""
pkg/linux_src4bld_rtl8852be.cpio.zst: parts/kernel/src/MAINTAINERS
	mkdir -p tmp
	cp -far parts/kernel/src/drivers/net/wireless/rockchip_wlan/rtl8852be tmp/
	cd tmp/rtl8852be && find . -name "*.c" -type f -delete
	cd tmp/rtl8852be && find . -print0 | cpio -o0H newc | zstd -z9T9 > ../../$@
	rm -fr tmp/rtl8852be
	$(SYNC)
parts/kernel/bld/drivers/net/wireless/rockchip_wlan/rtl8852be/Makefile: pkg/linux_src4bld_rtl8852be.cpio.zst
	mkdir -p parts/kernel/bld/drivers/net/wireless/rockchip_wlan/rtl8852be
	pv pkg/linux_src4bld_rtl8852be.cpio.zst | zstd -d | cpio -iduH newc -D parts/kernel/bld/drivers/net/wireless/rockchip_wlan/rtl8852be
	$(SYNC)
parts/kernel/bld/.config: cfg/$(KERNEL_CONFIG) parts/kernel/bld/drivers/net/wireless/rockchip_wlan/rtl8852be/Makefile
	mkdir -p parts/kernel/bld	
	cp -far $< $@ && touch $@
	$(SYNC)
parts/kernel/bld/Makefile: parts/kernel/bld/.config
#	cd parts/kernel/src && make O=../bld V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 EXTRAVERSION=$(KERNAM) olddefconfig && cd ../../ && touch $@
	cd parts/kernel/src && make O=../bld V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 olddefconfig
	$(SYNC)
kernel_config: parts/kernel/bld/Makefile
out/fat/Image: parts/kernel/bld/Makefile
	mkdir -p out/fat/dtb
	mkdir -p out/rd/kermod
	cd parts/kernel/src && make O=../bld $(JOBS) V=$(VERB) KCFLAGS="$(RK3588_FLAGS)" CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 dtbs && make O=../bld $(JOBS) V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 INSTALL_DTBS_PATH=../../../out/fat/dtb dtbs_install && make O=../bld $(JOBS) V=$(VERB) KCFLAGS="$(RK3588_FLAGS)" CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 Image && make O=../bld $(JOBS) V=$(VERB) KCFLAGS="$(RK3588_FLAGS)" CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 modules && make O=../bld $(JOBS) V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 INSTALL_MOD_PATH=../../../out/rd/kermod modules_install 
	cp -far parts/kernel/bld/arch/arm64/boot/Image out/fat/
	touch $@
kernel: out/fat/Image
out/rd/kermod/include/asm/ioctl.h: out/fat/Image
	cd parts/kernel/src && make O=../bld $(JOBS) V=$(VERB) CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 INSTALL_HDR_PATH=../../../out/rd/kermod headers_install
kernel_hdrs: out/rd/kermod/include/asm/ioctl.h

parts/busybox/src/Makefile:
	mkdir -p parts/busybox/src
	pv pkg/busybox.cpio.zst | zstd -d | cpio -iduH newc -D parts/busybox/src
	@echo ""
	@echo "=== Patching BUSYBOX ==="
	find parts/busybox/src -name "*.h" -exec sed -i "s/\/etc\//\/aetc\//g" {} +
	find parts/busybox/src -name "*.c" -exec sed -i "s/\/etc\//\/aetc\//g" {} +
	find parts/busybox/src -name "*.h" -exec sed -i "s/\/bin\//\/abin\//g" {} +
	find parts/busybox/src -name "*.c" -exec sed -i "s/\/bin\//\/abin\//g" {} +
#	sed -i "s/\/etc\/inittab/\/inittab/" parts/busybox/src/init/init.c
#	sed -i "s/\/bin\/login/\/login/" parts/busybox/src/loginutils/getty.c
#	sed -i "s/\/etc\/issue/\/issue/" parts/busybox/src/loginutils/getty.c
#	sed -i "s/\/bin\/login/\/login/" parts/busybox/src/networking/telnetd.c
#	sed -i "s/\/etc\/issue/\/issue/" parts/busybox/src/networking/telnetd.c
	$(SYNC)

parts/busybox/bld/.config: cfg/$(BUSYBOX_CONFIG) parts/busybox/src/Makefile
	mkdir -p parts/busybox/bld
	cp -far $< parts/busybox/bld/.config && touch $@

parts/busybox/bld/busybox: parts/busybox/bld/.config
	cd parts/busybox/bld && make $(JOBS) V=$(VERB) CFLAGS="$(BASE_OPT_FLAGS)" KBUILD_SRC=../src -f ../src/Makefile

out/rd/abin/busybox: parts/busybox/bld/busybox
	mkdir -p out/rd/abin
	cp -far $< $@ && touch $@
	cd out/rd && ln -sf /abin/busybox init
#	cd out/rd && mkdir -p usr
#	cd out/rd && mkdir -p tmp
#	cd out/rd && mkdir -p run
#	cd out/rd && mkdir -p opt
#	cd out/rd && mkdir -p mnt
#	cd out/rd && mkdir -p media
#	cd out/rd && mkdir -p home
#	cd out/rd && ln -sf /usr/var var
#	cd out/rd && ln -sf /usr/root root
	cd out/rd && ln -sf /usr/etc etc
	cd out/rd && ln -sf /usr/bin bin
	cd out/rd && ln -sf /usr/sbin sbin
	cd out/rd && ln -sf /usr/lib lib
#	cd out/rd && ln -sf /usr/lib64 lib64
	cd out/rd/abin && ln -sf busybox login && ln -sf busybox poweroff && ln -sf busybox reboot && ln -sf busybox getty && ln -sf busybox sh && ln -sf busybox ash && ln -sf busybox cat && ln -sf busybox mount && ln -sf busybox echo && ln -sf busybox mkdir && ln -sf busybox passwd && ln -sf busybox false && ln -sf busybox sync && ln -sf busybox ls && ln -sf busybox who && ln -sf busybox whoami && ln -sf busybox dd && ln -sf busybox vi && ln -sf busybox [ && ln -sf busybox [[ && ln -sf busybox df && ln -sf busybox du && ln -sf busybox modprobe && ln -sf busybox fdisk && ln -sf busybox ps && ln -sf busybox pstree && ln -sf busybox less && ln -sf busybox hexdump

out/rd/aetc/inittab: out/rd/abin/busybox
	mkdir -p out/rd/amnt/emmc
	mkdir -p out/rd/amnt/microsd
	mkdir -p out/rd/aetc/init.d
#
	echo "::sysinit:/abin/mkdir /sys" > $@
	echo "::sysinit:/abin/mount -t sysfs -o nodev,noexec,nosuid sysfs /sys" >> $@
	echo "::sysinit:/abin/mkdir /proc" >> $@
	echo "::sysinit:/abin/mount -t proc -o nodev,noexec,nosuid proc /proc" >> $@
	echo "::sysinit:/abin/mount -t devtmpfs -o nosuid,mode=0755 udev /dev" >> $@
	echo "::sysinit:/abin/mkdir /dev/pts" >> $@
	echo "::sysinit:/abin/mount -t devpts -o noexec,nosuid,gid=5,mode=0620 devpts /dev/pts" >> $@
	echo "::sysinit:/aetc/init.d/rcS" >> $@
	echo "::respawn:-/abin/sh" >> $@
	echo "ttyFIQ0::respawn:/abin/getty -L -f 0 1500000 ttyFIQ0 vt100" >> $@
	echo "::ctrlaltdel:/abin/poweroff" >> $@
#
	echo '#!/abin/sh' > out/rd/aetc/init.d/rcS
	echo 'for x in $$(/abin/busybox cat /proc/cmdline); do' >> out/rd/aetc/init.d/rcS
	echo '  case $$x in' >> out/rd/aetc/init.d/rcS
	echo '  myboot=*)' >> out/rd/aetc/init.d/rcS
	echo '    BOOT_DEV=$${x#myboot=}' >> out/rd/aetc/init.d/rcS
	echo '    BOOT_DEV_NAME=/dev/mmcblk$${BOOT_DEV}' >> out/rd/aetc/init.d/rcS
	echo '    echo "BOOT_DEV_NAME = $${BOOT_DEV_NAME}"' >> out/rd/aetc/init.d/rcS
	echo '    ;;' >> out/rd/aetc/init.d/rcS
	echo '  esac' >> out/rd/aetc/init.d/rcS
	echo 'done' >> out/rd/aetc/init.d/rcS
	echo 'if [ $${BOOT_DEV} = "0" ]' >> out/rd/aetc/init.d/rcS
	echo 'then' >> out/rd/aetc/init.d/rcS
	echo '   BOOT_DEV_TYPE=microSD' >> out/rd/aetc/init.d/rcS
	echo 'else' >> out/rd/aetc/init.d/rcS
	echo '   BOOT_DEV_TYPE=eMMC' >> out/rd/aetc/init.d/rcS
	echo '   /abin/busybox mount /dev/mmcblk$${BOOT_DEV}p1 /amnt/emmc' >> out/rd/aetc/init.d/rcS
	echo '   /abin/busybox ln -s /amnt/emmc /boot' >> out/rd/aetc/init.d/rcS
	echo 'fi' >> out/rd/aetc/init.d/rcS
	echo 'echo "BOOT_DEV_TYPE = $${BOOT_DEV_TYPE}"' >> out/rd/aetc/init.d/rcS
#	echo 'mkdir /sys' >> out/rd/aetc/init.d/rcS
#	echo 'mount -t sysfs -o nodev,noexec,nosuid sysfs /sys' >> out/rd/aetc/init.d/rcS
#	echo 'mkdir /proc' >> out/rd/aetc/init.d/rcS
#	echo 'mount -t proc -o nodev,noexec,nosuid proc /proc' >> out/rd/aetc/init.d/rcS
#	echo 'mount -t devtmpfs -o nosuid,mode=0755 udev /dev' >> out/rd/aetc/init.d/rcS
#	echo 'mkdir /dev/pts' >> out/rd/aetc/init.d/rcS
#	echo 'mount -t devpts -o noexec,nosuid,gid=5,mode=0620 devpts /dev/pts || /busybox true' >> out/rd/aetc/init.d/rcS
#	echo '/busybox echo emmc=/dev/mmcblk`/busybox ls /dev/mmcblk*boot0 | /busybox cut -c12-12`' >> out/rd/aetc/init.d/rcS
#	echo '/busybox echo microsd=/dev/mmcblk`/busybox ls /dev/mmcblk*boot0 | /busybox cut -c12-12 | /busybox tr 01 10`' >> out/rd/aetc/init.d/rcS
#	echo '/busybox mkdir -p /mnt/emmc' >> out/rd/aetc/init.d/rcS
#	echo '/busybox mkdir -p /mnt/microsd' >> out/rd/aetc/init.d/rcS
#	echo '/busybox mount -a -T /fstab' >> out/rd/aetc/init.d/rcS
#	echo '/busybox ls /sys/bus/mmc/devices' >> out/rd/aetc/init.d/rcS
#	echo '/busybox ln -sf /proc/self/fd /dev/fd' >> out/rd/aetc/init.d/rcS
#	echo '/busybox ln -sf /proc/self/fd/0 /dev/stdin' >> out/rd/aetc/init.d/rcS
#	echo '/busybox ln -sf /proc/self/fd/1 /dev/stdout' >> out/rd/aetc/init.d/rcS
#	echo '/busybox ln -sf /proc/self/fd/2 /dev/stderr' >> out/rd/aetc/init.d/rcS
	chmod ugo+x out/rd/aetc/init.d/rcS
#
	echo "MySys_OPI5+" > out/rd/aetc/issue
#
	echo 'export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/abin"' > out/rd/aetc/profile
#	echo 'echo "profile: Hellow World!"' >> out/rd/aetc/profile
#
	echo "/abin/ash" > out/rd/aetc/shells
	echo "/abin/sh" >> out/rd/aetc/shells
#
	echo "root:x:0:" > out/rd/aetc/group
	echo "daemon:x:1:" >> out/rd/aetc/group
	echo "bin:x:2:" >> out/rd/aetc/group
	echo "sys:x:3:" >> out/rd/aetc/group
	echo "adm:x:4:" >> out/rd/aetc/group
	echo "tty:x:5:" >> out/rd/aetc/group
	echo "disk:x:6:" >> out/rd/aetc/group
	echo "lp:x:7:" >> out/rd/aetc/group
	echo "mail:x:8:" >> out/rd/aetc/group
	echo "kmem:x:9:" >> out/rd/aetc/group
	echo "wheel:x:10:root" >> out/rd/aetc/group
	echo "cdrom:x:11:" >> out/rd/aetc/group
	echo "dialout:x:18:" >> out/rd/aetc/group
	echo "floppy:x:19:" >> out/rd/aetc/group
	echo "video:x:28:" >> out/rd/aetc/group
	echo "audio:x:29:" >> out/rd/aetc/group
	echo "tape:x:32:" >> out/rd/aetc/group
	echo "www-data:x:33:" >> out/rd/aetc/group
	echo "operator:x:37:" >> out/rd/aetc/group
	echo "utmp:x:43:" >> out/rd/aetc/group
	echo "plugdev:x:46:" >> out/rd/aetc/group
	echo "staff:x:50:" >> out/rd/aetc/group
	echo "lock:x:54:" >> out/rd/aetc/group
	echo "netdev:x:82:" >> out/rd/aetc/group
	echo "users:x:100:" >> out/rd/aetc/group
	echo "nobody:x:65534:" >> out/rd/aetc/group
#
	echo "root::0:0:root:/root:/abin/sh" > out/rd/aetc/passwd
#	echo "daemon:x:1:1:daemon:/usr/sbin:/bin/false" >> out/rd/aetc/passwd
	echo "bin:x:2:2:bin:/abin:/abin/false" >> out/rd/aetc/passwd
	echo "sys:x:3:3:sys:/dev:/abin/false" >> out/rd/aetc/passwd
	echo "sync:x:4:100:sync:/abin:/abin/sync" >> out/rd/aetc/passwd
#	echo "mail:x:8:8:mail:/var/spool/mail:/bin/false" >> out/rd/aetc/passwd
#	echo "www-data:x:33:33:www-data:/var/www:/bin/false" >> out/rd/aetc/passwd
#	echo "operator:x:37:37:Operator:/var:/bin/false" >> out/rd/aetc/passwd
	echo "nobody:x:65534:65534:nobody:/home:/abin/false" >> out/rd/aetc/passwd
#
	echo "root::19701::::::" > out/rd/aetc/shadow
	echo "daemon:*:::::::" >> out/rd/aetc/shadow
	echo "bin:*:::::::" >> out/rd/aetc/shadow
	echo "sys:*:::::::" >> out/rd/aetc/shadow
	echo "sync:*:::::::" >> out/rd/aetc/shadow
	echo "mail:*:::::::" >> out/rd/aetc/shadow
	echo "www-data:*:::::::" >> out/rd/aetc/shadow
	echo "operator:*:::::::" >> out/rd/aetc/shadow
	echo "nobody:*:::::::" >> out/rd/aetc/shadow

out/fat/uInitrd: out/rd/aetc/inittab
	mkdir -p out/fat
	cd out/rd && find . -print | cpio -oH newc | gzip > ../Initrd
	mkimage -A arm64 -O linux -T ramdisk -C gzip -n uInitrd -d out/Initrd out/fat/uInitrd
	rm -fr out/Initrd
	$(SYNC)
	
# mmc-fat = 190MiB = 389120 blks
out/mmc-fat.bin: out/fat/boot.scr out/fat/orangepiEnv.txt out/fat/Image out/fat/uInitrd
	mkdir -p tmp/mnt
	dd of=$@ if=/dev/zero bs=1M count=0 seek=190
	/sbin/mkfs.fat -F 32 -n "opi_boot" -i A77ACF93 $@
	sudo mount $@ tmp/mnt/
	sudo cp --force --no-preserve=all --recursive out/fat/* tmp/mnt/
	$(SYNC)
	sudo umount $@
	$(SYNC)
	rm -fr tmp/mnt/
	
out/mmc.img: parts/u-boot/uboot-head.bin parts/u-boot/uboot-tail.bin out/mmc-fat.bin
	dd of=$@ if=/dev/zero bs=1M count=0 seek=201
	dd of=$@ if=parts/u-boot/uboot-head.bin seek=64 conv=notrunc
	dd of=$@ if=parts/u-boot/uboot-tail.bin seek=16384 conv=notrunc
	dd of=$@ if=out/mmc-fat.bin seek=20480 conv=notrunc
	$(SYNC)
	/sbin/parted -s $@ mklabel gpt
	/sbin/parted -s $@ unit s mkpart bootfs 20480 409599
	$(SYNC)

mmc: out/mmc.img

parts/rkdeveloptool/src/main.cpp: pkg/rkdeveloptool.cpio.zst
	mkdir -p parts/rkdeveloptool/src
	pv pkg/rkdeveloptool.cpio.zst | zstd -d | cpio -iduH newc -D parts/rkdeveloptool/src
	$(SYNC)

parts/rkdeveloptool/src/cfg/compile:parts/rkdeveloptool/src/main.cpp
	cd parts/rkdeveloptool/src && autoreconf -i

parts/rkdeveloptool/bld/Makefile: parts/rkdeveloptool/src/cfg/compile
	mkdir -p parts/rkdeveloptool/bld
	cd parts/rkdeveloptool/bld && ../src/configure CXXFLAGS="$(BASE_OPT_FLAGS)"

parts/rkdeveloptool/bld/rkdeveloptool: parts/rkdeveloptool/bld/Makefile
	cd parts/rkdeveloptool/bld && make $(JOBS) V=$(VERB)

out/rkdeveloptool: parts/rkdeveloptool/bld/rkdeveloptool
	mkdir -p out
	cp -far $< $@
	strip --strip-all $@

parts/u-boot/blobs/rk3588_spl_loader_v1.08.111.bin: parts/u-boot/blobs/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin

out/usb_loader.bin: parts/u-boot/blobs/rk3588_spl_loader_v1.08.111.bin
	mkdir -p out
	cd out && ln -sf ../parts/u-boot/blobs/rk3588_spl_loader_v1.08.111.bin usb_loader.bin

rkdeveloptool: out/rkdeveloptool out/usb_loader.bin

flash: out/mmc.img out/rkdeveloptool out/usb_loader.bin
	@echo "Connect usb-target, enter in maskrom, and press ENTER to continue"
	@read line
	cd out && sudo ./rkdeveloptool db usb_loader.bin && sudo ./rkdeveloptool wl 0 mmc.img && sudo ./rkdeveloptool rd 0


write_tst: out/mmc.img
#	@echo `ls /dev/mmcblk*boot0 | cut -c-12 | tr 01 10`
	@echo "Insert microSD to slot, and press ENTER to continue"
	@read line
	sudo dd if=`ls /dev/mmcblk*boot0 | cut -c-12 | tr 01 10` count=1 | hexdump -C


write_run: out/mmc.img
	@echo "Here is dev eMMC"
	ls /dev/mmcblk*boot0
	ls /dev/mmcblk*boot0 | cut -c-12
	@echo 'INFO: /dev/mmcblk*boot0 - is emmc, but "cut&tr" invert number for microSD'
	@echo "Here is dev microSD"
	ls /dev/mmcblk*boot0 | cut -c-12 | tr 01 10
	@echo ""
	@echo "Insert microSD (`ls /dev/mmcblk*boot0 | cut -c-12 | tr 01 10`) to slot, and press ENTER to continue."
	@echo 'If unsure, press Ctrl+C now !'
	@echo 'Check "lsblk" or use "make write_tst" for read only card test !'
	@echo 'If really sure, press ENTER...'
	@read line
	sudo dd if=out/mmc.img of=`ls /dev/mmcblk*boot0 | cut -c-12 | tr 01 10` bs=1M status=progress && sudo sync

# ============================= LFS



pkg/binutils-$(BINUTILS_VER).tar.xz:
	mkdir -p pkg
	wget -P pkg https://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VER).tar.xz
pkg/mpfr-$(MPFR_VER).tar.xz:
	mkdir -p pkg
	wget -P pkg https://www.mpfr.org/mpfr-4.1.0/mpfr-$(MPFR_VER).tar.xz
pkg/gmp-$(GMP_VER).tar.xz:
	mkdir -p pkg
	wget -P pkg https://ftp.gnu.org/gnu/gmp/gmp-$(GMP_VER).tar.xz
pkg/mpc-$(MPC_VER).tar.gz:
	mkdir -p pkg
	wget -P pkg https://ftp.gnu.org/gnu/mpc/mpc-$(MPC_VER).tar.gz
pkg/gcc-$(GCC_VER).tar.xz:
	mkdir -p pkg
	wget -P pkg https://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VER)/gcc-$(GCC_VER).tar.xz
pkg/glibc-$(GLIBC_VER).tar.xz:
	mkdir -p pkg
	wget -P pkg https://ftp.gnu.org/gnu/glibc/glibc-$(GLIBC_VER).tar.xz
pkg/glibc-$(GLIBC_VER)-fhs-1.patch:
	mkdir -p pkg
	wget -P pkg http://www.linuxfromscratch.org/patches/lfs/10.0/glibc-$(GLIBC_VER)-fhs-1.patch
pkg/m4-$(M4_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/m4/m4-$(M4_VER).tar.xz
pkg/ncurses-$(NCURSES_VER).tar.gz:
	wget -P pkg http://ftp.gnu.org/gnu/ncurses/ncurses-$(NCURSES_VER).tar.gz
pkg/bash-$(BASH_VER).tar.gz:
	wget -P pkg http://ftp.gnu.org/gnu/bash/bash-$(BASH_VER).tar.gz
pkg/coreutils-$(CORE_UTILS_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/coreutils/coreutils-$(CORE_UTILS_VER).tar.xz
pkg/diffutils-$(DIFF_UTILS_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/diffutils/diffutils-$(DIFF_UTILS_VER).tar.xz
pkg/file-$(FILE_VER).tar.gz:
	wget -P pkg ftp://ftp.astron.com/pub/file/file-$(FILE_VER).tar.gz
pkg/findutils-$(FIND_UTILS_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/findutils/findutils-$(FIND_UTILS_VER).tar.xz
pkg/gawk-$(GAWK_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/gawk/gawk-$(GAWK_VER).tar.xz
pkg/grep-$(GREP_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/grep/grep-$(GREP_VER).tar.xz
pkg/gzip-$(GZIP_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/gzip/gzip-$(GZIP_VER).tar.xz
pkg/make-$(MAKE_VER).tar.gz:
	wget -P pkg http://ftp.gnu.org/gnu/make/make-$(MAKE_VER).tar.gz
pkg/patch-$(PATCH_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/patch/patch-$(PATCH_VER).tar.xz
pkg/sed-$(SED_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/sed/sed-$(SED_VER).tar.xz
pkg/tar-$(TAR_VER).tar.xz:
	wget -P pkg http://ftp.gnu.org/gnu/tar/tar-$(TAR_VER).tar.xz
pkg/xz-$(XZ_VER).tar.xz:
	wget -P pkg https://tukaani.org/xz/xz-$(XZ_VER).tar.xz


parts/host-cross-binutils/binutils-$(BINUTILS_VER)/README: pkg/binutils-$(BINUTILS_VER).tar.xz out/fat/Image
	mkdir -p parts/host-cross-binutils
	tar -xJf $< -C parts/host-cross-binutils && touch $@
parts/host-cross-binutils/bld1-host/Makefile: parts/host-cross-binutils/binutils-$(BINUTILS_VER)/README
	mkdir -p parts/host-cross-binutils/bld1-host
	cd parts/host-cross-binutils/bld1-host && ../binutils-$(BINUTILS_VER)/configure $(BINUTILS_OPT)
parts/host-cross-binutils/bld1-host/binutils/addr2line: parts/host-cross-binutils/bld1-host/Makefile
	cd parts/host-cross-binutils/bld1-host && make $(JOBS) V=$(VERB)
$(LFS)/tools/bin/$(LFS_TGT)-addr2line: parts/host-cross-binutils/bld1-host/binutils/addr2line
	cd parts/host-cross-binutils/bld1-host && make install

#binutils:$(LFS)/tools/bin/$(LFS_TGT)-addr2line

parts/host-cross-gcc/gcc-$(GCC_VER)/README: pkg/gcc-$(GCC_VER).tar.xz $(LFS)/tools/bin/$(LFS_TGT)-addr2line
	mkdir -p parts/host-cross-gcc
	tar -xJf $< -C parts/host-cross-gcc && touch $@
parts/host-cross-gcc/gcc-$(GCC_VER)/gmp/README: pkg/gmp-$(GMP_VER).tar.xz parts/host-cross-gcc/gcc-$(GCC_VER)/README
	tar -xJf $< -C parts/host-cross-gcc/gcc-$(GCC_VER)
	cd parts/host-cross-gcc/gcc-$(GCC_VER) && mv -v gmp-$(GMP_VER) gmp && touch gmp/README
parts/host-cross-gcc/gcc-$(GCC_VER)/mpfr/README: pkg/mpfr-$(MPFR_VER).tar.xz parts/host-cross-gcc/gcc-$(GCC_VER)/README
	tar -xJf $< -C parts/host-cross-gcc/gcc-$(GCC_VER) 			
	cd parts/host-cross-gcc/gcc-$(GCC_VER) && mv -v mpfr-$(MPFR_VER) mpfr && touch mpfr/README
parts/host-cross-gcc/gcc-$(GCC_VER)/mpc/README: pkg/mpc-$(MPC_VER).tar.gz parts/host-cross-gcc/gcc-$(GCC_VER)/README
	tar -xzf $< -C parts/host-cross-gcc/gcc-$(GCC_VER)
	cd parts/host-cross-gcc/gcc-$(GCC_VER) && mv -v mpc-$(MPC_VER) mpc && touch mpc/README
parts/host-cross-gcc/bld1-host/Makefile: parts/host-cross-gcc/gcc-$(GCC_VER)/README parts/host-cross-gcc/gcc-$(GCC_VER)/gmp/README parts/host-cross-gcc/gcc-$(GCC_VER)/mpfr/README parts/host-cross-gcc/gcc-$(GCC_VER)/mpc/README
	mkdir -p parts/host-cross-gcc/bld1-host
	cd parts/host-cross-gcc/bld1-host && ../gcc-$(GCC_VER)/configure $(GCC_OPT)
$(LFS)/tools/bin/$(LFS_TGT)-gcc: parts/host-cross-gcc/bld1-host/Makefile
	cd parts/host-cross-gcc/bld1-host && make $(JOBS) V=$(VERB) && make install
	cd parts/host-cross-gcc/bld1-host && cd ../ && cat gcc-$(GCC_VER)/gcc/limitx.h gcc-$(GCC_VER)/gcc/glimits.h gcc-$(GCC_VER)/gcc/limity.h > $(LFS)/tools/lib/gcc/$(LFS_TGT)/$(GCC_VER)/install-tools/include/limits.h

#gcc: $(LFS)/tools/bin/$(LFS_TGT)-gcc


$(LFS)/usr/include/asm/ioctl.h: out/rd/kermod/include/asm/ioctl.h
	mkdir -p $(LFS)/usr/lib
	cd $(LFS) && ln -fsv usr/lib lib
	mkdir -p $(LFS)/usr/bin
	cd $(LFS) && ln -fsv usr/bin bin
	mkdir -p $(LFS)/usr/sbin
	cd $(LFS) && ln -fsv usr/sbin sbin
	mkdir -p $(LFS)/usr/etc
	cd $(LFS) && ln -fsv usr/etc etc
	mkdir -p $(LFS)/usr/include
	cp -far out/rd/kermod/include/* $(LFS)/usr/include
#$(LFS)/lib/ld-lsb.so.3: /lib/ld-linux-aarch64.so.1
#	mkdir -p $(LFS)/lib
#	ln -sfv $< $@
parts/host-glibc/glibc-$(GLIBC_VER)-fhs-1.patch: pkg/glibc-$(GLIBC_VER)-fhs-1.patch
	mkdir -p parts/host-glibc
	cp -far $< $@
parts/host-glibc/glibc-$(GLIBC_VER)/README: pkg/glibc-$(GLIBC_VER).tar.xz parts/host-glibc/glibc-$(GLIBC_VER)-fhs-1.patch $(LFS)/usr/include/asm/ioctl.h $(LFS)/tools/bin/$(LFS_TGT)-gcc
	mkdir -p parts/host-glibc
	tar -xJf $< -C parts/host-glibc && touch $@ && cd parts/host-glibc/glibc-$(GLIBC_VER) && patch -Np1 -i ../glibc-$(GLIBC_VER)-fhs-1.patch
	sed -i '30 a DIAG_PUSH_NEEDS_COMMENT;' parts/host-glibc/glibc-$(GLIBC_VER)/locale/weight.h
	sed -i '31 a DIAG_IGNORE_Os_NEEDS_COMMENT (8, "-Wmaybe-uninitialized");' parts/host-glibc/glibc-$(GLIBC_VER)/locale/weight.h
	sed -i '33 a DIAG_POP_NEEDS_COMMENT;' parts/host-glibc/glibc-$(GLIBC_VER)/locale/weight.h
parts/host-glibc/host.txt: parts/host-glibc/glibc-$(GLIBC_VER)/README
	parts/host-glibc/glibc-$(GLIBC_VER)/scripts/config.guess > $@
parts/host-glibc/bld/Makefile: parts/host-glibc/host.txt
	mkdir -p parts/host-glibc/bld
	cd parts/host-glibc/bld && ../glibc-$(GLIBC_VER)/configure --build=`cat ../host.txt` $(GLIBC_OPT) libc_cv_slibdir=/lib
$(LFS)/lib/ld-$(GLIBC_VER).so: parts/host-glibc/bld/Makefile
	cd parts/host-glibc/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
	$(LFS)/tools/libexec/gcc/$(LFS_TGT)/$(GCC_VER)/install-tools/mkheaders

#glibc: $(LFS)/lib/ld-$(GLIBC_VER).so

parts/host-cross-gcc/bld_libcpp1/Makefile: $(LFS)/lib/ld-$(GLIBC_VER).so
	mkdir -p parts/host-cross-gcc/bld_libcpp1
	cd parts/host-cross-gcc/bld_libcpp1 && ../gcc-$(GCC_VER)/libstdc++-v3/configure --build=`cat ../../host-glibc/host.txt` $(LIBCPP_OPT)

$(LFS)/tools/$(LFS_TGT)/include/c++/$(GCC_VER)/stdlib.h: parts/host-cross-gcc/bld_libcpp1/Makefile
	cd parts/host-cross-gcc/bld_libcpp1 && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install

#libcpp: $(LFS)/tools/$(LFS_TGT)/include/c++/$(GCC_VER)/stdlib.h

parts/cross-m4/m4-$(M4_VER)/README: pkg/m4-$(M4_VER).tar.xz $(LFS)/tools/$(LFS_TGT)/include/c++/$(GCC_VER)/stdlib.h
	mkdir -p parts/cross-m4
	tar -xJf $< -C parts/cross-m4 && touch $@
	sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' parts/cross-m4/m4-$(M4_VER)/lib/*.c
	echo "#define _IO_IN_BACKUP 0x100" >> parts/cross-m4/m4-$(M4_VER)/lib/stdio-impl.h
parts/cross-m4/bld/Makefile: parts/cross-m4/m4-$(M4_VER)/README
	mkdir -p parts/cross-m4/bld
	cd parts/cross-m4/bld && ../m4-$(M4_VER)/configure --build=`cat ../../host-glibc/host.txt` $(M4_OPT)
$(LFS)/usr/bin/m4: parts/cross-m4/bld/Makefile
	cd parts/cross-m4/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
m4: $(LFS)/usr/bin/m4


parts/cross-ncurses/ncurses-$(NCURSES_VER)/README: pkg/ncurses-$(NCURSES_VER).tar.gz $(LFS)/usr/bin/m4
	mkdir -p parts/cross-ncurses
	tar -xzf $< -C parts/cross-ncurses && touch $@
	sed -i s/mawk// parts/cross-ncurses/ncurses-$(NCURSES_VER)/configure
$(LFS)/usr/lib/libncursesw.so.$(NCURSES_VER): parts/cross-ncurses/ncurses-$(NCURSES_VER)/README
	mkdir -p parts/cross-ncurses/bld
#	cd parts/cross-ncurses/bld && ../ncurses-$(NCURSES_VER)/configure && make -C include && make -C progs tic && export TIC_PATH=$(LFS)/../parts/cross-ncurses/bld/progs/tic && ../ncurses-$(NCURSES_VER)/configure --build=`cat ../../host-glibc/host.txt` --with-build-cc=`cat ../../host-glibc/host.txt` $(NCURSES_OPT) && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) TIC_PATH=$(LFS)/../parts/cross-ncurses/bld/progs/tic install
	cd parts/cross-ncurses/bld && ../ncurses-$(NCURSES_VER)/configure && make -C include && make -C progs tic && ../ncurses-$(NCURSES_VER)/configure --build=`cat ../../host-glibc/host.txt` --with-build-cc=`cat ../../host-glibc/host.txt` $(NCURSES_OPT) && make $(JOBS) V=$(VERB) && make LD_LIBRARY_PATH=$(LFS)/../parts/cross-ncurses/bld/lib DESTDIR=$(LFS) TIC_PATH=$(LFS)/../parts/cross-ncurses/bld/progs/tic install
	echo "INPUT(-lncursesw)" > $(LFS)/usr/lib/libncurses.so
	cd $(LFS)/lib && ln -sfv libncursesw.so.6 libtinfo.so.6
#	mv -v $(LFS)/usr/lib/libncursesw.so.6* $(LFS)/lib
#	cd $(LFS)/usr/lib && ln -sfv ../../lib/libncursesw.so.6 libncursesw.so
ncu: $(LFS)/usr/lib/libncursesw.so.$(NCURSES_VER)

parts/cross-bash/bash-$(BASH_VER)/README: pkg/bash-$(BASH_VER).tar.gz $(LFS)/usr/lib/libncursesw.so.$(NCURSES_VER)
	mkdir -p parts/cross-bash
	tar -xzf $< -C parts/cross-bash && touch $@
parts/cross-bash/bld/Makefile: parts/cross-bash/bash-$(BASH_VER)/README
	mkdir -p parts/cross-bash/bld
	cd parts/cross-bash/bld && ../bash-$(BASH_VER)/configure --build=`cat ../../host-glibc/host.txt` $(BASH_OPT)
$(LFS)/usr/bin/bash: parts/cross-bash/bld/Makefile
	cd parts/cross-bash/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
#	mkdir -p $(LFS)/bin
#	mv $(LFS)/usr/bin/bash $(LFS)/bin
	cd $(LFS)/usr/bin && ln -sf bash sh
bash: $(LFS)/usr/bin/bash

parts/cross-coreutils/coreutils-$(CORE_UTILS_VER)/README: pkg/coreutils-$(CORE_UTILS_VER).tar.xz $(LFS)/usr/bin/bash
	mkdir -p parts/cross-coreutils
	tar -xJf $< -C parts/cross-coreutils && touch $@
	sed -i "s/SYS_getdents/SYS_getdents64/" parts/cross-coreutils/coreutils-$(CORE_UTILS_VER)/src/ls.c
parts/cross-coreutils/bld/Makefile: parts/cross-coreutils/coreutils-$(CORE_UTILS_VER)/README
	mkdir -p parts/cross-coreutils/bld
	cd parts/cross-coreutils/bld && ../coreutils-$(CORE_UTILS_VER)/configure --build=`cat ../../host-glibc/host.txt` $(CORE_UTILS_OPT)
$(LFS)/usr/sbin/chroot: parts/cross-coreutils/bld/Makefile
	cd parts/cross-coreutils/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
#	mkdir -p $(LFS)/bin
	mkdir -p $(LFS)/usr/sbin
#	mv -v $(LFS)/usr/bin/cat $(LFS)/bin
#	mv -v $(LFS)/usr/bin/chgrp $(LFS)/bin
#	mv -v $(LFS)/usr/bin/chmod $(LFS)/bin
#	mv -v $(LFS)/usr/bin/chown $(LFS)/bin
#	mv -v $(LFS)/usr/bin/cp $(LFS)/bin
#	mv -v $(LFS)/usr/bin/date $(LFS)/bin
#	mv -v $(LFS)/usr/bin/dd $(LFS)/bin
#	mv -v $(LFS)/usr/bin/df $(LFS)/bin
#	mv -v $(LFS)/usr/bin/echo $(LFS)/bin
#	mv -v $(LFS)/usr/bin/false $(LFS)/bin
#	mv -v $(LFS)/usr/bin/ln $(LFS)/bin
#	mv -v $(LFS)/usr/bin/ls $(LFS)/bin
#	mv -v $(LFS)/usr/bin/mkdir $(LFS)/bin
#	mv -v $(LFS)/usr/bin/mknod $(LFS)/bin
#	mv -v $(LFS)/usr/bin/mv $(LFS)/bin
#	mv -v $(LFS)/usr/bin/pwd $(LFS)/bin
#	mv -v $(LFS)/usr/bin/rm $(LFS)/bin
#	mv -v $(LFS)/usr/bin/rmdir $(LFS)/bin
#	mv -v $(LFS)/usr/bin/stty $(LFS)/bin
#	mv -v $(LFS)/usr/bin/sync $(LFS)/bin
#	mv -v $(LFS)/usr/bin/true $(LFS)/bin
#	mv -v $(LFS)/usr/bin/uname $(LFS)/bin
#	mv -v $(LFS)/usr/bin/head $(LFS)/bin
#	mv -v $(LFS)/usr/bin/nice $(LFS)/bin
#	mv -v $(LFS)/usr/bin/sleep $(LFS)/bin
#	mv -v $(LFS)/usr/bin/touch $(LFS)/bin
	mv -v $(LFS)/usr/bin/chroot $(LFS)/usr/sbin
	mkdir -pv $(LFS)/usr/share/man/man8
	mv -v $(LFS)/usr/share/man/man1/chroot.1 $(LFS)/usr/share/man/man8/chroot.8
	sed -i 's/"1"/"8"/' $(LFS)/usr/share/man/man8/chroot.8
cor: $(LFS)/usr/sbin/chroot

parts/cross-diffutils/diffutils-$(DIFF_UTILS_VER)/README: pkg/diffutils-$(DIFF_UTILS_VER).tar.xz $(LFS)/usr/sbin/chroot
	mkdir -p parts/cross-diffutils
	tar -xJf $< -C parts/cross-diffutils && touch $@

parts/cross-diffutils/bld/Makefile: parts/cross-diffutils/diffutils-$(DIFF_UTILS_VER)/README
	mkdir -p parts/cross-diffutils/bld
	cd parts/cross-diffutils/bld && ../diffutils-$(DIFF_UTILS_VER)/configure $(DIFF_UTILS_OPT)

$(LFS)/usr/bin/diff: parts/cross-diffutils/bld/Makefile
	cd parts/cross-diffutils/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install

dif: $(LFS)/usr/bin/diff

parts/cross-file/file-$(FILE_VER)/README: pkg/file-$(FILE_VER).tar.gz $(LFS)/usr/bin/diff
	mkdir -p parts/cross-file
	tar -xzf $< -C parts/cross-file && touch $@

parts/cross-file/bld/Makefile: parts/cross-file/file-$(FILE_VER)/README
	mkdir -p parts/cross-file/bld
	cd parts/cross-file/bld && ../file-$(FILE_VER)/configure $(FILE_OPT)

$(LFS)/usr/bin/file: parts/cross-file/bld/Makefile
	cd parts/cross-file/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install

fil: $(LFS)/usr/bin/file

parts/cross-findutils/findutils-$(FIND_UTILS_VER)/README: pkg/findutils-$(FIND_UTILS_VER).tar.xz $(LFS)/usr/bin/file
	mkdir -p parts/cross-findutils
	tar -xJf $< -C parts/cross-findutils && touch $@
parts/cross-findutils/bld/Makefile: parts/cross-findutils/findutils-$(FIND_UTILS_VER)/README
	mkdir -p parts/cross-findutils/bld
	cd parts/cross-findutils/bld && ../findutils-$(FIND_UTILS_VER)/configure --build=`cat ../../host-glibc/host.txt` $(FIND_UTILS_OPT)
$(LFS)/usr/bin/find: parts/cross-findutils/bld/Makefile
	cd parts/cross-findutils/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
#	mv -v $(LFS)/usr/bin/find $(LFS)/bin
#	sed -i 's|find:=${BINDIR}|find:=/bin|' $(LFS)/usr/bin/updatedb
find: $(LFS)/usr/bin/find

parts/cross-gawk/gawk-$(GAWK_VER)/README: pkg/gawk-$(GAWK_VER).tar.xz $(LFS)/usr/bin/find
	mkdir -p parts/cross-gawk
	tar -xJf $< -C parts/cross-gawk && touch $@
	sed -i 's/extras//' parts/cross-gawk/gawk-$(GAWK_VER)/Makefile.in
parts/cross-gawk/bld/Makefile: parts/cross-gawk/gawk-$(GAWK_VER)/README
	mkdir -p parts/cross-gawk/bld
	cd parts/cross-gawk/bld && ../gawk-$(GAWK_VER)/configure --build=`cat ../../host-glibc/host.txt` $(GAWK_OPT)
$(LFS)/usr/bin/gawk: parts/cross-gawk/bld/Makefile
	cd parts/cross-gawk/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
gawk: $(LFS)/usr/bin/gawk

parts/cross-grep/grep-$(GREP_VER)/README: pkg/grep-$(GREP_VER).tar.xz $(LFS)/usr/bin/gawk
	mkdir -p parts/cross-grep
	tar -xJf $< -C parts/cross-grep && touch $@
parts/cross-grep/bld/Makefile: parts/cross-grep/grep-$(GREP_VER)/README
	mkdir -p parts/cross-grep/bld
	cd parts/cross-grep/bld && ../grep-$(GREP_VER)/configure $(GREP_OPT)
$(LFS)/usr/bin/grep: parts/cross-grep/bld/Makefile
	cd parts/cross-grep/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
grep: $(LFS)/usr/bin/grep

parts/cross-gzip/gzip-$(GZIP_VER)/README: pkg/gzip-$(GZIP_VER).tar.xz $(LFS)/usr/bin/grep
	mkdir -p parts/cross-gzip
	tar -xJf $< -C parts/cross-gzip && touch $@
parts/cross-gzip/bld/Makefile: parts/cross-gzip/gzip-$(GZIP_VER)/README
	mkdir -p parts/cross-gzip/bld
	cd parts/cross-gzip/bld && ../gzip-$(GZIP_VER)/configure $(GZIP_OPT)
$(LFS)/usr/bin/gzip: parts/cross-gzip/bld/Makefile
	cd parts/cross-gzip/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
#	mv -v $(LFS)/usr/bin/gzip $(LFS)/bin
gzip: $(LFS)/usr/bin/gzip

parts/cross-make/make-$(MAKE_VER)/README: pkg/make-$(MAKE_VER).tar.gz $(LFS)/usr/bin/gzip
	mkdir -p parts/cross-make
	tar -xzf $< -C parts/cross-make && touch $@
parts/cross-make/bld/Makefile: parts/cross-make/make-$(MAKE_VER)/README
	mkdir -p parts/cross-make/bld
	cd parts/cross-make/bld && ../make-$(MAKE_VER)/configure --build=`cat ../../host-glibc/host.txt` $(MAKE_OPT)
$(LFS)/usr/bin/make: parts/cross-make/bld/Makefile
	cd parts/cross-make/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
mak: $(LFS)/usr/bin/make

parts/cross-patch/patch-$(PATCH_VER)/README: pkg/patch-$(PATCH_VER).tar.xz $(LFS)/usr/bin/make
	mkdir -p parts/cross-patch
	tar -xJf $< -C parts/cross-patch && touch $@
parts/cross-patch/bld/Makefile: parts/cross-patch/patch-$(PATCH_VER)/README
	mkdir -p parts/cross-patch/bld
	cd parts/cross-patch/bld && ../patch-$(PATCH_VER)/configure --build=`cat ../../host-glibc/host.txt` $(PATCH_OPT)
$(LFS)/usr/bin/patch: parts/cross-patch/bld/Makefile
	cd parts/cross-patch/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
pat: $(LFS)/usr/bin/patch

parts/cross-sed/sed-$(SED_VER)/README: pkg/sed-$(SED_VER).tar.xz $(LFS)/usr/bin/patch
	mkdir -p parts/cross-sed
	tar -xJf $< -C parts/cross-sed && touch $@
parts/cross-sed/bld/Makefile: parts/cross-sed/sed-$(SED_VER)/README
	mkdir -p parts/cross-sed/bld
	cd parts/cross-sed/bld && ../sed-$(SED_VER)/configure $(SED_OPT)
$(LFS)/usr/bin/sed: parts/cross-sed/bld/Makefile
	cd parts/cross-sed/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
sed: $(LFS)/usr/bin/sed

parts/cross-tar/tar-$(TAR_VER)/README: pkg/tar-$(TAR_VER).tar.xz $(LFS)/usr/bin/sed
	mkdir -p parts/cross-tar
	tar -xJf $< -C parts/cross-tar && touch $@
parts/cross-tar/bld/Makefile: parts/cross-tar/tar-$(TAR_VER)/README
	mkdir -p parts/cross-tar/bld
	cd parts/cross-tar/bld && ../tar-$(TAR_VER)/configure --build=`cat ../../host-glibc/host.txt` $(TAR_OPT)
$(LFS)/usr/bin/tar: parts/cross-tar/bld/Makefile
	cd parts/cross-tar/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
tar: $(LFS)/usr/bin/tar

parts/cross-xz/xz-$(XZ_VER)/README: pkg/xz-$(XZ_VER).tar.xz $(LFS)/usr/bin/tar
	mkdir -p parts/cross-xz
	tar -xJf $< -C parts/cross-xz && touch $@
parts/cross-xz/bld/Makefile: parts/cross-xz/xz-$(XZ_VER)/README
	mkdir -p parts/cross-xz/bld
	cd parts/cross-xz/bld && ../xz-$(XZ_VER)/configure --build=`cat ../../host-glibc/host.txt` $(XZ_OPT)
$(LFS)/usr/bin/xz: parts/cross-xz/bld/Makefile
	cd parts/cross-xz/bld && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
#	mv -v $(LFS)/usr/bin/lzma $(LFS)/bin
#	mv -v $(LFS)/usr/bin/unlzma $(LFS)/bin
#	mv -v $(LFS)/usr/bin/lzcat $(LFS)/bin
#	mv -v $(LFS)/usr/bin/xz $(LFS)/bin
#	mv -v $(LFS)/usr/bin/unxz $(LFS)/bin
#	mv -v $(LFS)/usr/bin/xzcat $(LFS)/bin
#	mv -v $(LFS)/usr/lib/liblzma.so.* $(LFS)/lib
#	cd $(LFS)/usr/lib && ln -sfv ../../lib/liblzma.so.$(XZ_VER) liblzma.so
xz: $(LFS)/usr/bin/xz

parts/host-cross-binutils/bld2-cross/Makefile: $(LFS)/usr/bin/xz
	mkdir -p parts/host-cross-binutils/bld2-cross
	cd parts/host-cross-binutils/bld2-cross && CC=$(LFS)/tools/bin/$(LFS_TGT)-gcc AR=$(LFS)/tools/bin/$(LFS_TGT)-ar RANLIB=$(LFS)/tools/bin/$(LFS_TGT)-ranlib ../binutils-$(BINUTILS_VER)/configure --build=`cat ../../host-glibc/host.txt` $(BINUTILS_OPT2)
$(LFS)/usr/$(LFS_TGT)/bin/ar: parts/host-cross-binutils/bld2-cross/Makefile
	cd parts/host-cross-binutils/bld2-cross && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
bin2: $(LFS)/usr/$(LFS_TGT)/bin/ar

parts/host-cross-gcc/bld2-cross/Makefile: $(LFS)/usr/$(LFS_TGT)/bin/ar
	mkdir -p parts/host-cross-gcc/bld2-cross
	cd parts/host-cross-gcc/bld2-cross && mkdir -pv $(LFS_TGT)/libgcc && cd $(LFS_TGT)/libgcc && ln -sfv ../../../gcc-$(GCC_VER)/libgcc/gthr-posix.h gthr-posix.h
	cd parts/host-cross-gcc/bld2-cross && CC=$(LFS)/tools/bin/$(LFS_TGT)-gcc AR=$(LFS)/tools/bin/$(LFS_TGT)-ar RANLIB=$(LFS)/tools/bin/$(LFS_TGT)-ranlib ../gcc-$(GCC_VER)/configure --build=`cat ../../host-glibc/host.txt` $(GCC_OPT2)
gcc2: parts/host-cross-gcc/bld2-cross/Makefile
	cd parts/host-cross-gcc/bld2-cross && make $(JOBS) V=$(VERB) && make DESTDIR=$(LFS) install
