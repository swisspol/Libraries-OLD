#!/bin/sh

# Set up environment
export DEVELOPER=`xcode-select --print-path`
export MAC_SDK="10.9"
export MAC_MIN_VERSION="10.6"
export IPHONE_SDK="7.0"
export IPHONE_MIN_VERSION="5.0"

# Build Mac libraries
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libsqlite3"
  ./build-libsqlite3.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libexif"
  ./build-libexif.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libjpeg-turbo"
  ./build-libjpeg-turbo.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/liblcms2"
  ./build-liblcms2.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libprotobuf"
  ./build-libprotobuf.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libpng"
  ./build-libpng.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libwebp"
  ./build-libwebp.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libexpat"
  ./build-libexpat.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libexiv2"
  ./build-libexiv2.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/liblept"
  ./build-liblept.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libtesseract"
  ./build-libtesseract.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libmp3lame"
  ./build-libmp3lame.sh
)
(
  export PLATFORMS="MacOSX-X86_64 MacOSX-I386"
  export DESTINATION="../Libraries-Mac/libffmpeg"
  ./build-libffmpeg.sh
)

# Build iOS libraries
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libsqlite3"
  ./build-libsqlite3.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libexif"
  ./build-libexif.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libjpeg-turbo"
  ./build-libjpeg-turbo.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/liblcms2"
  ./build-liblcms2.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libprotobuf"
  ./build-libprotobuf.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libpng"
  ./build-libpng.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libwebp"
  ./build-libwebp.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libexpat"
  ./build-libexpat.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libexiv2"
  ./build-libexiv2.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/liblept"
  ./build-liblept.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libtesseract"
  ./build-libtesseract.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libmp3lame"
  ./build-libmp3lame.sh
)
(
  export PLATFORMS="iPhone-Simulator iPhoneOS-V7 iPhoneOS-V7s"
  export DESTINATION="../Libraries-iOS/libffmpeg"
  ./build-libffmpeg.sh
)
