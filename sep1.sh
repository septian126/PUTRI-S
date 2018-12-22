#!/bin/bash
#

#Custom Build Script

#
# Copyright © 2016, "Pavu(ZaMaSu)" <pravinchaudharyn@gmail.com>
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#

# Init Script
KERNEL_DIR=$PWD
KERNEL="Image.gz-dtb"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
BASE_VER="Cemong"
VER="-T1-$(date +"%Y-%m-%d"-%H%M)-"
BUILD_START=$(date +"%s")
KERNEL_VER="T1"

# Color Code Script
black='\e[0;30m'        # Black
red='\e[0;31m'          # Red
green='\e[0;32m'        # Green
yellow='\e[0;33m'       # Yellow
blue='\e[0;34m'         # Blue
purple='\e[0;35m'       # Purple
cyan='\e[0;36m'         # Cyan
white='\e[0;37m'        # White
nocol='\033[0m'         # Default

# Tweakable Stuff
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Cemong_Septian"
export KBUILD_BUILD_HOST="putri"
export CROSS_COMPILE="/home/cemong/redmi-note5/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export KBUILD_COMPILER_STRING=$(/home/cemong/redmi-note5/linux-x86/clang-r346389b/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
#COMPILATION SCRIPTS
echo -e "${green}"
echo "--------------------------------------------------------"
echo "      Initializing build to compile Ver: $VER    "
echo "--------------------------------------------------------"

echo -e "$yellow***********************************************"
echo "         Creating Output Directory: out      "
echo -e "***********************************************$nocol"

mkdir -p out

echo -e "$red***********************************************"
echo "          Cleaning Up Before Compile          "
echo -e "***********************************************$nocol"

make O=out clean 
make O=out mrproper

echo -e "$yellow***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************$nocol"

make O=out ARCH=arm64 sept_defconfig

echo -e "$yellow***********************************************"
echo "          Cooking septian!!        "
echo -e "***********************************************$nocol"

make -j$(nproc --all) O=out ARCH=arm64 \

echo -e "$yellow***********************************************"
echo "          Copying zImage        "
echo -e "***********************************************$nocol"

cp out/arch/arm64/boot/Image.gz-dtb AnyKernel2/zImage

echo -e "$yellow***********************************************"
echo "          Making Flashable Zip        "
echo -e "***********************************************$nocol"

cd AnyKernel2
zip -r9 $BASE_VER-$KERNEL_VER.zip * -x README.md $BASE_VER-$KERNEL_VER.zip

if ! [ -a $ZIMAGE ];
then
echo -e "$Red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi


#BUILD TIME
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

