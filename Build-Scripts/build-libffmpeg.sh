#!/bin/sh
set -ex

VERSION="2.1.3"
YASM_VERSION="1.2.0"
YASM_DIR="`pwd`/yasm"

# Download Yasm
if [ ! -f "yasm-${YASM_VERSION}.tar.gz" ]
then
  curl -O "http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz"
fi

# Extract Yasm
rm -rf "yasm-${YASM_VERSION}"
tar -xvf "yasm-${YASM_VERSION}.tar.gz"

# Build Yasm and append to $PATH
rm -rf "${YASM_DIR}"
pushd "yasm-${YASM_VERSION}"
./configure "--prefix=${YASM_DIR}"
make clean
make -j4
make install
popd
export PATH="$PATH:${YASM_DIR}/bin"

# Download gas preprocessor and append to $PATH
rm -f "gas-preprocessor.pl"
curl -L -O "https://raw.github.com/yuvi/gas-preprocessor/master/gas-preprocessor.pl"
chmod a+x "gas-preprocessor.pl"
export PATH="$PATH:`pwd`"

# Download source
if [ ! -f "ffmpeg-${VERSION}.tar.gz" ]
then
  curl -O "http://www.ffmpeg.org/releases/ffmpeg-${VERSION}.tar.gz"
fi

# Extract source
rm -rf "ffmpeg-${VERSION}"
tar -xvf "ffmpeg-${VERSION}.tar.gz"

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
  
  BASE=`pwd`
  LIBMP3LAME="${BASE}/${DESTINATION}/../libmp3lame"
  
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
    export CFLAGS="-arch ${ARCH} -isysroot ${SDKROOT} -I${SDKROOT}/usr/include -I${LIBMP3LAME}/include"
    export LD=`xcrun -find ld`
    export LDFLAGS="-arch ${ARCH} -isysroot ${SDKROOT} -L${SDKROOT}/usr/lib -L${LIBMP3LAME}/lib"
    export CPPFLAGS="${CFLAGS}"
    if [ "${PLATFORM}" == "MacOSX" ]
    then
      export CFLAGS="${CFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
    else
      export CFLAGS="${CFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION} -mfpu=neon"
      export LDFLAGS="${LDFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION} -mfpu=neon"
    fi
    
    pushd "ffmpeg-${VERSION}"
    if [ "${PLATFORM}" == "iPhoneOS" ]
    then
      ./configure --disable-programs --disable-doc --enable-libmp3lame --arch=${ARCH} --enable-cross-compile --target-os=darwin --cpu=cortex-a9 --disable-armv5te --enable-pic --disable-debug --enable-static --disable-shared --prefix=${ROOTDIR}
    elif [ "${PLATFORM}" == "iPhoneSimulator" ]
    then
      ./configure --disable-programs --disable-doc --enable-libmp3lame --arch=${ARCH} --disable-debug --enable-static --disable-shared --prefix=${ROOTDIR}
    else
      ./configure --disable-programs --disable-doc --enable-libmp3lame --arch=${ARCH} --disable-debug --enable-static --disable-shared --prefix=${ROOTDIR}
    fi
    rm -f "./-.d"  # Something is creating this file which break "make clean"
    make clean
    make -j4
    make install
    popd
  )
  
  if [ -e "${DESTINATION}/lib/libavcodec.a" ]
  then
    libtool -static "${DESTINATION}/lib/libavcodec.a" "${ROOTDIR}/lib/libavcodec.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libavcodec.a"
    libtool -static "${DESTINATION}/lib/libavdevice.a" "${ROOTDIR}/lib/libavdevice.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libavdevice.a"
    libtool -static "${DESTINATION}/lib/libavfilter.a" "${ROOTDIR}/lib/libavfilter.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libavfilter.a"
    libtool -static "${DESTINATION}/lib/libavformat.a" "${ROOTDIR}/lib/libavformat.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libavformat.a"
    libtool -static "${DESTINATION}/lib/libavutil.a" "${ROOTDIR}/lib/libavutil.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libavutil.a"
    libtool -static "${DESTINATION}/lib/libswresample.a" "${ROOTDIR}/lib/libswresample.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libswresample.a"
    libtool -static "${DESTINATION}/lib/libswscale.a" "${ROOTDIR}/lib/libswscale.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libswscale.a"
  else
    ditto "${ROOTDIR}/include" "${DESTINATION}/include"
    libtool -static "${ROOTDIR}/lib/libavcodec.a" -o "${DESTINATION}/lib/libavcodec.a"
    libtool -static "${ROOTDIR}/lib/libavdevice.a" -o "${DESTINATION}/lib/libavdevice.a"
    libtool -static "${ROOTDIR}/lib/libavfilter.a" -o "${DESTINATION}/lib/libavfilter.a"
    libtool -static "${ROOTDIR}/lib/libavformat.a" -o "${DESTINATION}/lib/libavformat.a"
    libtool -static "${ROOTDIR}/lib/libavutil.a" -o "${DESTINATION}/lib/libavutil.a"
    libtool -static "${ROOTDIR}/lib/libswresample.a" -o "${DESTINATION}/lib/libswresample.a"
    libtool -static "${ROOTDIR}/lib/libswscale.a" -o "${DESTINATION}/lib/libswscale.a"
  fi
  
  rm -rf "${ROOTDIR}"
done

# Clean up
rm -f "gas-preprocessor.pl"
rm -rf "ffmpeg-${VERSION}"
# rm -f "ffmpeg-${VERSION}.tar.gz"
rm -rf "${YASM_DIR}"
rm -rf "yasm-${YASM_VERSION}"
# rm -f "yasm-${YASM_VERSION}.tar.gz"
