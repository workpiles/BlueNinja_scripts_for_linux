#! /bin/bash

export TZ1_BASE=../Cerevo/CDP-TZ01B/
export INSTALL_FILES=install_files/

cd ${INSTALL_FILES}

# Create directories.
if [ ! -e ${TZ1_BASE} ]; then
	mkdir -p ${TZ1_BASE}
fi

echo "Setup tool chain."
if [ ! -e ${TZ1_BASE}tools ]; then
	mkdir ${TZ1_BASE}tools
fi

if [ ! -e gcc-arm-none-eabi-4_9-2015q1-20150306-linux.tar.bz2 ]; then
	wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q1-update/+download/gcc-arm-none-eabi-4_9-2015q1-20150306-linux.tar.bz2
fi
tar -jxf gcc-arm-none-eabi-4_9-2015q1-20150306-linux.tar.bz2 -C ${TZ1_BASE}tools --strip=1

echo "Setup SDKs"
if [ ! -e ${TZ1_BASE}sdk ]; then
	mkdir ${TZ1_BASE}sdk
fi
# CMSIS
if [ ! -e ${TZ1_BASE}sdk/ARM.CMSIS ]; then
	mkdir ${TZ1_BASE}sdk/ARM.CMSIS
fi

if [ -e "ARM.CMSIS.3.20.4.pack" ]; then
	unzip -qd ${TZ1_BASE}sdk/ARM.CMSIS ARM.CMSIS.3.20.4.pack
elif [ -e "ARM.CMSIS.3.20.4.zip" ]; then
	unzip -qd ${TZ1_BASE}sdk/ARM.CMSIS ARM.CMSIS.3.20.4.zip
else 
	echo "ARM.CMSIS.3.20.4 is notfound."	
	exit
fi

# TZ10xx_DFP
if [ ! -e "${TZ1_BASE}sdk/TOSHIBA.TZ10xx_DFP" ]; then
	mkdir "${TZ1_BASE}sdk/TOSHIBA.TZ10xx_DFP"
fi

if [ ! -e "TOSHIBA.TZ10xx_DFP.1.31.1.pack" ]; then
	echo "TOSHIBA.TZ10xx_DFP.1.31.1.pack is notfound."
	exit
fi
unzip -qd ${TZ1_BASE}sdk/TOSHIBA.TZ10xx_DFP TOSHIBA.TZ10xx_DFP.1.31.1.pack

echo "GNU tool TZ10xx Support"
cp tz10xx.specs ${TZ1_BASE}tools/arm-none-eabi/lib
${TZ1_BASE}tools/bin/arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mthumb-interwork -march=armv7e-m -mfloat-abi=soft -std=c99 -g -O0 -c tz10xx-crt0.c -o ${TZ1_BASE}tools/arm-none-eabi/lib/tz10xx-crt0.o

echo "This script isn't install OpenOCD."
echo "OpenOCD can be installed using apt."

echo "Setup Scripts."
cp -r ../_TZ1/* ${TZ1_BASE}

echo "DONE"
