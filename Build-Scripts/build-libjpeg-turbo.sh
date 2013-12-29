#!/bin/sh
set -ex

VERSION="1.3.0"
NASM_VERSION="2.10.09"

# Download NASM
if [ ! -f "nasm-${NASM_VERSION}-macosx.zip" ]
then
  curl -O "http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/macosx/nasm-${NASM_VERSION}-macosx.zip"
fi

# Extract NASM
rm -rf "nasm-${NASM_VERSION}"
unzip "nasm-${NASM_VERSION}-macosx.zip"
NASM_PATH="`pwd`/nasm-${NASM_VERSION}/nasm"

# Download source
if [ ! -f "libjpeg-turbo-${VERSION}.tar.gz" ]
then
  curl -O "http://softlayer-dal.dl.sourceforge.net/project/libjpeg-turbo/${VERSION}/libjpeg-turbo-${VERSION}.tar.gz"
fi

# Extract source
rm -rf "libjpeg-turbo-${VERSION}"
tar -xvf "libjpeg-turbo-${VERSION}.tar.gz"

# Download gas preprocessor and add to $PATH
if [ ! -f "gas-preprocessor-master.zip" ]
then
  curl -o "gas-preprocessor-master.zip" "https://codeload.github.com/yuvi/gas-preprocessor/zip/master"
fi
rm -rf "gas-preprocessor-master"
unzip "gas-preprocessor-master.zip"
pushd "gas-preprocessor-master"
chmod a+x "gas-preprocessor.pl"
export PATH=$PATH:`pwd`
popd

# Build
rm -rf "${DESTINATION}"
mkdir -p "${DESTINATION}"
mkdir -p "${DESTINATION}/include"
mkdir -p "${DESTINATION}/lib"
for PLATFORM in ${PLATFORMS}
do
  ROOTDIR="/tmp/${PLATFORM}"
  if [ "${PLATFORM}" == "MacOSX-X86_64" ]
  then
    PLATFORM="MacOSX"
    ARCH="x86_64"
  elif [ "${PLATFORM}" == "MacOSX-I386" ]
  then
    PLATFORM="MacOSX"
    ARCH="i386"
  elif [ "${PLATFORM}" == "iPhone-Simulator" ]
  then
    PLATFORM="iPhoneSimulator"
    ARCH="i386"
  elif [ "${PLATFORM}" == "iPhoneOS-V7" ]
  then
    PLATFORM="iPhoneOS"
    ARCH="armv7"
  elif [ "${PLATFORM}" == "iPhoneOS-V7s" ]
  then
    PLATFORM="iPhoneOS"
    ARCH="armv7s"
  elif [ "${PLATFORM}" == "iPhoneOS-V6" ]
  then
    PLATFORM="iPhoneOS"
    ARCH="armv6"
  else
    exit 1
  fi
  rm -rf "${ROOTDIR}"
  mkdir -p "${ROOTDIR}"
  
  (
    pushd "libjpeg-turbo-${VERSION}"
    
    if [ "${PLATFORM}" == "iPhoneOS" ]
    then
    export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
      export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${IPHONE_SDK}.sdk"
      export CC=`xcrun -find gcc`
      export LD=`xcrun -find ld`
      export IOS_CFLAGS="-arch ${ARCH}"
      export CFLAGS="-O3 ${IOS_CFLAGS} -isysroot ${SDKROOT}"
      export LDFLAGS="${IOS_CFLAGS} -isysroot ${SDKROOT}"
      export CPPFLAGS="${CFLAGS}"
      export CFLAGS="${CFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      ./configure --with-jpeg8 --host arm-apple-darwin --enable-static --disable-shared --prefix=${ROOTDIR}
    elif [ "${PLATFORM}" == "iPhoneSimulator" ]
    then
      export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
      export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${IPHONE_SDK}.sdk"
      export CC=`xcrun -find gcc`
      export LD=`xcrun -find ld`
      export CFLAGS="-O3 -m32 -isysroot ${SDKROOT} -I${SDKROOT}/usr/include"
      export LDFLAGS="-m32 -isysroot ${SDKROOT} -L${SDKROOT}/usr/lib"
      export CPPFLAGS="${CFLAGS}"
      export CFLAGS="${CFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      ./configure --without-simd --with-jpeg8 --host=${ARCH}-apple-darwin --enable-static --disable-shared --prefix=${ROOTDIR}  # TODO: Enable SIMD support
    else
      export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
      export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${MAC_SDK}.sdk"
      export CC=`xcrun -find gcc`
      export LD=`xcrun -find ld`
      if [ "${ARCH}" == "i386" ]
      then
        export CFLAGS="-O3 -m32 -isysroot ${SDKROOT} -I${SDKROOT}/usr/include"
        export LDFLAGS="-m32 -isysroot ${SDKROOT} -L${SDKROOT}/usr/lib"
      else
        export CFLAGS="-O3 -isysroot ${SDKROOT} -I${SDKROOT}/usr/include"
        export LDFLAGS="-isysroot ${SDKROOT} -L${SDKROOT}/usr/lib"
      fi
      export CPPFLAGS="${CFLAGS}"
      export CFLAGS="${CFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
      ./configure NASM=${NASM_PATH} --with-jpeg8 --host=${ARCH}-apple-darwin --enable-static --disable-shared --prefix=${ROOTDIR}
    fi
    
    make clean
    make -j4
    make install
    popd
  )
  
  if [ -e "${DESTINATION}/lib/libjpeg.a" ]
  then
    libtool -static "${DESTINATION}/lib/libjpeg.a" "${ROOTDIR}/lib/libjpeg.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libjpeg.a"
  else
    ditto "${ROOTDIR}/include" "${DESTINATION}/include"
    libtool -static "${ROOTDIR}/lib/libjpeg.a" -o "${DESTINATION}/lib/libjpeg.a"
  fi
  
  rm -rf "${ROOTDIR}"
done

# Clean up
rm -rf "gas-preprocessor-master"
# rm -f "gas-preprocessor-master.zip"
rm -rf "libjpeg-turbo-${VERSION}"
# rm -f "libjpeg-turbo-${VERSION}.tar.gz"
rm -rf "nasm-${NASM_VERSION}"
# rm -f "nasm-${NASM_VERSION}-macosx.zip"
