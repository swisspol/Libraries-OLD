#!/bin/sh
set -ex

VERSION="2.5.0"

# Download source
if [ ! -f "protobuf-${VERSION}.tar.gz" ]
then
  curl -O "http://protobuf.googlecode.com/files/protobuf-${VERSION}.tar.gz"
fi

# Extract source
rm -rf "protobuf-${VERSION}"
tar -xvf "protobuf-${VERSION}.tar.gz"

# Build protoc (standalone)
pushd "protobuf-${VERSION}"
./configure --enable-static --disable-shared
make -j4
mv -f "src/protoc" "/tmp/protoc"
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
    export CXX=`xcrun -find g++`
    export CXXFLAGS="-arch ${ARCH} -isysroot ${SDKROOT} -I${SDKROOT}/usr/include"
    export LD=`xcrun -find ld`
    export LDFLAGS="-arch ${ARCH} -isysroot ${SDKROOT} -L${SDKROOT}/usr/lib"
    export CPPFLAGS="${CFLAGS}"
    if [ "${PLATFORM}" == "MacOSX" ]
    then
      export CFLAGS="${CFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
      export CXXFLAGS="${CXXFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -mmacosx-version-min=${MAC_MIN_VERSION}"
    else
      export CFLAGS="${CFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      export CXXFLAGS="${CXXFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
      export LDFLAGS="${LDFLAGS} -miphoneos-version-min=${IPHONE_MIN_VERSION}"
    fi
    
    pushd "protobuf-${VERSION}"
    ./configure --host=i386-apple-darwin --build=${ARCH}-apple-darwin --target=${ARCH}-apple-darwin --enable-static --disable-shared --prefix=${ROOTDIR} --with-protoc=/tmp/protoc
    make clean
    make -j4
    make install
    popd
  )
  
  if [ -e "${DESTINATION}/lib/libprotobuf.a" ]
  then
    libtool -static "${DESTINATION}/lib/libprotobuf.a" "${ROOTDIR}/lib/libprotobuf.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libprotobuf.a"
    libtool -static "${DESTINATION}/lib/libprotobuf-lite.a" "${ROOTDIR}/lib/libprotobuf-lite.a" -o "${DESTINATION}/lib/lib.a"
    mv "${DESTINATION}/lib/lib.a" "${DESTINATION}/lib/libprotobuf-lite.a"
  else
    ditto "${ROOTDIR}/include" "${DESTINATION}/include"
    libtool -static "${ROOTDIR}/lib/libprotobuf.a" -o "${DESTINATION}/lib/libprotobuf.a"
    libtool -static "${ROOTDIR}/lib/libprotobuf-lite.a" -o "${DESTINATION}/lib/libprotobuf-lite.a"
  fi
  
  rm -rf "${ROOTDIR}"
done

# Clean up
rm -rf "protobuf-${VERSION}"
# rm -f "protobuf-${VERSION}.tar.gz"
