#!/bin/bash

#
# This script builds a set of GNU tool chain for ARM cpu.
# July 2011, create by Tanggeliang(tang.geliang@zte.com.cn).
#

set -e

VERSION=1.0
TARGET=arm-linux-gnueabi
PREFIX=/home/quanjunlin/toolchain/opt/${TARGET}-tools-${VERSION}
WORKDIR=$(pwd)
SOURCES=${WORKDIR}/sources
STAMPS=${WORKDIR}/stamps
MAKE=make
PROCS=2

BINUTILS_REV=2.20.1
GMP_REV=5.0.1
MPFR_REV=3.0.0
MPC_REV=0.8.2
GCC_REV=linaro-4.5-2011.05-0
LINUX_REV=2.6.20
LINUX_ARCH=arm
LINUX_MACH=realview-smp
GLIBC_REV=2.11
GLIBC_PORTS_REV=2.11
GLIBC_LIBGCC_EH_REV=2.11
GDB_REV=7.2

BINUTILS_URL=http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_REV}.tar.bz2
GCC_URL=http://launchpad.net/gcc-linaro/4.5/4.5-2011.05-0/+download/gcc-${GCC_REV}.tar.bz2
GLIBC_URL=http://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_REV}.tar.bz2
GDB_URL=http://ftp.gnu.org/gnu/gdb/gdb-${GDB_REV}.tar.bz2
GMP_URL=http://ftp.gnu.org/gnu/gmp/gmp-${GMP_REV}.tar.bz2
MPC_URL=http://www.multiprecision.org/mpc/download/mpc-${MPC_REV}.tar.gz
MPFR_URL=http://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_REV}.tar.bz2
LINUX_URL=http://ftp.kernel.org/pub/linux/kernel/v2.6/linux-${LINUX_REV}.tar.bz2
GLIBC_PORTS_URL=http://ftp.gnu.org/gnu/glibc/glibc-ports-${GLIBC_PORTS_REV}.tar.bz2

# Fetch a versioned file from a URL
function fetch {
    if [ ! -e ${SOURCES}/$1.tar.* ]; then
        echo "Downloading $1 sources..."
		cd ${SOURCES}
        wget -c  $2
		cd ..
    fi
}

# prerequest:
mkdir -p ${SOURCES}
mkdir -p ${PREFIX}
mkdir -p ${STAMPS}

fetch binutils-${BINUTILS_REV} ${BINUTILS_URL}
fetch gcc-${GCC_REV} ${GCC_URL}
fetch glibc-${GLIBC_REV} ${GLIBC_URL}
fetch gdb-${GDB_REV} ${GDB_URL}
fetch gmp-${GMP_REV} ${GMP_URL}
fetch mpc-${MPC_REV} ${MPC_URL}
fetch mpfr-${MPFR_REV} ${MPFR_URL}
fetch linux-${LINUX_REV} ${LINUX_URL}
fetch glibc-ports-${GLIBC_PORTS_REV} ${GLIBC_PORTS_URL}
touch ${STAMPS}/prerequest

# binutils
if [ ! -e ${STAMPS}/binutils-${BINUTILS_REV}.build ]; then
	tar -xvf ${SOURCES}/binutils-${BINUTILS_REV}.tar.bz2
	mkdir -p build/binutils && cd build/binutils
	echo "Configuring binutils-${BINUTILS_REV}"
	../../binutils-${BINUTILS_REV}/configure --prefix=${PREFIX} --target=${TARGET} --disable-shared --disable-nls --disable-werror
	echo "Building binutils-${BINUTILS_REV}"
	${MAKE} -j${PROCS}
	${MAKE} install
	cd ${WORKDIR}
	echo "Cleaning up binutils-${BINUTILS_REV}"
	touch ${STAMPS}/binutils-${BINUTILS_REV}.build
	rm -rf binutils-${BINUTILS_REV}
fi

# gcc1
if [ ! -e ${STAMPS}/gcc-${GCC_REV}-stag1.build ]; then
	tar -xvf ${SOURCES}/gcc-${GCC_REV}.tar.bz2
	cp gcc-${GCC_REV}/gcc/config/arm/t-linux gcc-${GCC_REV}/gcc/config/arm/t-linux.bak
	sed -i "s/-fomit-frame-pointer -fPIC/-fomit-frame-pointer -fPIC -Dinhibit_libc -D__gthr_posix_h/g" gcc-${GCC_REV}/gcc/config/arm/t-linux
	cd gcc-${GCC_REV}
	tar -xvf ${SOURCES}/gmp-${GMP_REV}.tar.bz2
	mv gmp-${GMP_REV} gmp
	tar -xvf ${SOURCES}/mpfr-${MPFR_REV}.tar.bz2
	mv mpfr-${MPFR_REV} mpfr
	tar -xvf ${SOURCES}/mpc-${MPC_REV}.tar.gz
	mv mpc-${MPC_REV} mpc
	cd ..
	mkdir -p build/gcc1 && cd build/gcc1
	echo "Configuring gcc-${GCC_REV}"
	OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
	export LD_LIBRARY_PATH=${TEMP_PREFIX}/lib:${LD_LIBRARY_PATH}
	../../gcc-${GCC_REV}/configure --prefix=${PREFIX} --target=${TARGET} --enable-languages="c" --with-gnu-ld --with-gnu-as --with-newlib --disable-nls --disable-shared --disable-threads --disable-libssp --disable-libmudflap --disable-libgomp
	echo "Building gcc-${GCC_REV}"
	${MAKE} -j${PROCS}
	${MAKE} install
	ln -sv ${PREFIX}/bin/${TARGET}-gcc ${PREFIX}/bin/${TARGET}-cc
	cd ${WORKDIR}
	touch ${STAMPS}/gcc-${GCC_REV}-stag1.build
fi

# linux-header
if [ ! -e ${STAMPS}/linux-header-${LINUX_REV}.build ]; then
	tar -xvf ${SOURCES}/linux-${LINUX_REV}.tar.bz2
	cd linux-${LINUX_REV}
	export PATH=${PREFIX}/bin:${PATH}
	${MAKE} distclean
	export PATH=${PREFIX}/bin:${PATH}
	echo "Building linux-header-${LINUX_REV}"
	${MAKE} ARCH=${LINUX_ARCH} CROSS_COMPILE=${TARGET}- ${LINUX_MACH}_defconfig
	${MAKE} ARCH=${LINUX_ARCH} CROSS_COMPILE=${TARGET}- --ignore-errors
	mkdir -p ${PREFIX}/${TARGET}/include
	cp -aR include/linux ${PREFIX}/${TARGET}/include/
	cp -aR include/asm-arm ${PREFIX}/${TARGET}/include/asm
	cp -aR include/asm-generic ${PREFIX}/${TARGET}/include/
	ln -s ${PREFIX}/${TARGET}/include ${PREFIX}/${TARGET}/sys-include
	cd ${WORKDIR}
	echo "Cleaning up linux-header-${LINUX_REV}"
	touch ${STAMPS}/linux-header-${LINUX_REV}.build
	rm -rf linux-${LINUX_REV}
fi

# glibc
if [ ! -e ${STAMPS}/glibc-${GLIBC_REV}.build ]; then
	tar -xvf ${SOURCES}/glibc-${GLIBC_REV}.tar.bz2
	tar -xvf ${SOURCES}/glibc-ports-${GLIBC_PORTS_REV}.tar.bz2 --directory=glibc-${GLIBC_REV}
	cd glibc-${GLIBC_REV}
	patch -Np1 -i ${SOURCES}/glibc-${GLIBC_LIBGCC_EH_REV}-libgcc_eh-1.patch
	cd ..
	mkdir -p build/glibc && cd build/glibc
	export PATH=${PREFIX}/bin:${PATH}
	export LD_LIBRARY_PATH=${OLD_LD_LIBRARY_PATH}
	echo "Configuring glibc-${GLIBC_REV}"
	CC=${TARGET}-gcc AR=${TARGET}-ar RANLIB=${TARGET}-ranlib ../../glibc-${GLIBC_REV}/configure --prefix=${PREFIX}/${TARGET} --host=${TARGET} --build=i686-pc-linux-gnu --with-headers=${PREFIX}/${TARGET}/include --enable-add-ons --with-binutils=${PREFIX}/${TARGET}/bin --with-tls --with-__thread --enable-sim --enable-nptl --enable-kernel=${LINUX_REV} --disable-profile --without-gd libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes
	echo "Building glibc-${GLIBC_REV}"
	${MAKE} -j${PROCS}
	${MAKE} install
	cd ${WORKDIR}
	echo "Cleaning up glibc-${GLIBC_REV}"
	touch ${STAMPS}/glibc-${GLIBC_REV}.build
	rm -rf glibc-${GLIBC_REV}
fi

# gcc2
if [ ! -e ${STAMPS}/gcc-${GCC_REV}-stag2.build ]; then
	cp gcc-${GCC_REV}/gcc/config/arm/t-linux.bak gcc-${GCC_REV}/gcc/config/arm/t-linux
	mkdir -p build/gcc2 && cd build/gcc2
	export PATH=${PREFIX}/bin:${PATH}
	echo "Configuring gcc-${GCC_REV}"
	../../gcc-${GCC_REV}/configure --prefix=${PREFIX} --target=${TARGET} --enable-languages="c,c++" --with-gnu-ld --with-gnu-as --disable-nls --disable-werror --enable-threads=posix --enable-shared --enable-__cxa_atexit --with-local-prefix=${PREFIX}/${TARGET}
	echo "Building gcc-${GCC_REV}"
	${MAKE} -j${PROCS}
	${MAKE} install
	echo "${PREFIX}/bin/arm-linux-readelf -a /$1 | gawk ''/Shared library/{print /$5}''" > ${PREFIX}/bin/arm-linux-ldd
	chmod a+x ${PREFIX}/bin/arm-linux-ldd
	cd ${WORKDIR}
	echo "Cleaning up gcc-${GCC_REV}"
	touch ${STAMPS}/gcc-${GCC_REV}-stag2.build
	rm -rf gcc-${GCC_REV}
fi

# gdb
if [ ! -e ${STAMPS}/gdb-${GDB_REV}.build ]; then
	tar -xvf ${SOURCES}/gdb-${GDB_REV}.tar.bz2
	mkdir -p build/gdb && cd build/gdb
	export PATH=${PREFIX}/bin:${PATH}
	echo "Configuring gdb-${GDB_REV}"
	../../gdb-${GDB_REV}/configure --prefix=${PREFIX} --target=${TARGET} --enable-shared --disable-werror
	echo "Building gdb-${GDB_REV}"
	${MAKE} -j${PROCS}
	${MAKE} install
	cd ${WORKDIR}
	echo "Cleaning up gdb-${GDB_REV}"
	touch ${STAMPS}/gdb-${GDB_REV}.build
	rm -rf gdb-${GDB_REV}
fi

#clean
	rm -rf build/*
	touch ${STAMPS}/clean

echo "done!"
