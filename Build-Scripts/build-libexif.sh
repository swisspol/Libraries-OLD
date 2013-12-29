#!/bin/sh
set -ex

VERSION="0.6.21"

# Download source
if [ ! -f "libexif-${VERSION}.tar.bz2" ]
then
  curl -O "http://switch.dl.sourceforge.net/project/libexif/libexif/${VERSION}/libexif-${VERSION}.tar.bz2"
fi

# Extract source
rm -rf "libexif-${VERSION}"
tar -xvf "libexif-${VERSION}.tar.bz2"

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
    if [ "${PLATFORM}" == "iPhoneOS" ]
    then
      export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
      export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${IPHONE_SDK}.sdk"
    elif [ "${PLATFORM}" == "iPhoneSimulator" ]
    then
      export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
      export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${IPHONE_SDK}.sdk"
    else
      export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
      export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${MAC_SDK}.sdk"
    fi
    export CC=`xcrun -find gcc`
    export CFLAGS="-arch ${ARCH} -isysroot ${SDKROOT} -I${SDKROOT}/usr/include"
    export LD=`xcrun -find ld`
    export LDFLAGS="-arch ${ARCH} -isysroot ${SDKROOT} -L${SDKROOT}/usr/lib"
    export CPPFLAGS="${CFLAGS}"
    if [ "${PLATFORM}" == "MacOSX" ]
    then
      export CFLAGS="${CFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
    else
      export CFLAGS="${CFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
    fi
    
    pushd "libexif-${VERSION}"
    ./configure --host=i386-apple-darwin --build=${ARCH}-apple-darwin --target=${ARCH}-apple-darwin --enable-static --disable-shared --prefix=${ROOTDIR}
    make clean
    make -j4
    make install
    popd
  )
  
  if [ -e "${DESTINATION}/lib/libexif.a" ]
  then
    libtool -static "${DESTINATION}/lib/libexif.a" "${ROOTDIR}/lib/libexif.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libexif.a"
  else
    ditto "${ROOTDIR}/include" "${DESTINATION}/include"
    libtool -static "${ROOTDIR}/lib/libexif.a" -o "${DESTINATION}/lib/libexif.a"
  fi
  
  rm -rf "${ROOTDIR}"
done

# Clean up
rm -rf "libexif-${VERSION}"
# rm -f "libexif-${VERSION}.tar.bz2"
