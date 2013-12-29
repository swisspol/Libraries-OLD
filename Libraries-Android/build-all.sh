#!/bin/sh
set -ex

SQLITE3_VERSION="3080100"
LCMS2_VERSION="2.5"
JPEG_VERSION="1.3.0"
EXIF_VERSION="0.6.21"
PNG_VERSION="1.6.6"
WEBP_VERSION="0.3.1"
PROTOBUF_VERSION="2.5.0"

# Setup
cd "jni"
rm -rf "../libs"
rm -rf "../obj"

# Download SQLite3
if [ ! -f "sqlite-autoconf-$SQLITE3_VERSION.tar.gz" ]
then
  curl -O "http://www.sqlite.org/2013/sqlite-autoconf-$SQLITE3_VERSION.tar.gz"
fi
rm -rf "sqlite-autoconf-$SQLITE3_VERSION"
tar -xvf "sqlite-autoconf-$SQLITE3_VERSION.tar.gz"
# rm -f "sqlite-autoconf-$SQLITE3_VERSION.tar.gz"
ln -sf "sqlite-autoconf-$SQLITE3_VERSION" "sqlite-autoconf"

# Download LittleCMS2
if [ ! -f "lcms2-$LCMS2_VERSION.tar.gz" ]
then
  curl -O "http://jaist.dl.sourceforge.net/project/lcms/lcms/$LCMS2_VERSION/lcms2-$LCMS2_VERSION.tar.gz"
fi
rm -rf "lcms2-$LCMS2_VERSION"
tar -xvf "lcms2-$LCMS2_VERSION.tar.gz"
# rm -f "lcms2-$LCMS2_VERSION.tar.gz"
ln -sf "lcms2-$LCMS2_VERSION" "lcms2"

# Download LibJPEG-Turbo
if [ ! -f "libjpeg-turbo-$JPEG_VERSION.tar.gz" ]
then
  curl -O "http://superb-dca2.dl.sourceforge.net/project/libjpeg-turbo/$JPEG_VERSION/libjpeg-turbo-$JPEG_VERSION.tar.gz"
fi
rm -rf "libjpeg-turbo-$JPEG_VERSION"
tar -xvf "libjpeg-turbo-$JPEG_VERSION.tar.gz"
# rm -f "libjpeg-turbo-$JPEG_VERSION.tar.gz"
pushd "libjpeg-turbo-$JPEG_VERSION"
if [ `uname` == "Darwin" ]; then
  ./configure --with-jpeg8 --host arm-apple-darwin
else
  ./configure --with-jpeg8 --host arm-linux
fi
popd
ln -sf "libjpeg-turbo-$JPEG_VERSION" "libjpeg-turbo"

# Download LibExif
if [ ! -f "libexif-$EXIF_VERSION.tar.bz2" ]
then
  curl -O "http://switch.dl.sourceforge.net/project/libexif/libexif/$EXIF_VERSION/libexif-$EXIF_VERSION.tar.bz2"
fi
rm -rf "libexif-$EXIF_VERSION"
tar -xvf "libexif-$EXIF_VERSION.tar.bz2"
# rm -f "libexif-$EXIF_VERSION.tar.bz2"
pushd "libexif-$EXIF_VERSION"
if [ `uname` == "Darwin" ]; then
  ./configure --host arm-apple-darwin
else
  ./configure --host arm-linux
fi
popd
ln -sf "libexif-$EXIF_VERSION" "libexif"

# Download LibPNG
if [ ! -f "libpng-$PNG_VERSION.tar.gz" ]
then
  curl -O "http://hivelocity.dl.sourceforge.net/project/libpng/libpng16/$PNG_VERSION/libpng-$PNG_VERSION.tar.gz"
fi
rm -rf "libpng-$PNG_VERSION"
tar -xvf "libpng-$PNG_VERSION.tar.gz"
# rm -f "libpng-$PNG_VERSION.tar.gz"
pushd "libpng-$PNG_VERSION"
cp "scripts/pnglibconf.h.prebuilt" "pnglibconf.h"
popd
ln -sf "libpng-$PNG_VERSION" "libpng"

# Download LibWebP
if [ ! -f "libwebp-$WEBP_VERSION.tar.gz" ]
then
  curl -O "https://webp.googlecode.com/files/libwebp-$WEBP_VERSION.tar.gz"
fi
rm -rf "libwebp-$WEBP_VERSION"
tar -xvf "libwebp-$WEBP_VERSION.tar.gz"
# rm -f "libwebp-$WEBP_VERSION.tar.gz"
ln -sf "libwebp-$WEBP_VERSION" "libwebp"

# Download LibProtobuf
if [ ! -f "protobuf-$PROTOBUF_VERSION.tar.gz" ]
then
  curl -O "http://protobuf.googlecode.com/files/protobuf-$PROTOBUF_VERSION.tar.gz"
fi
rm -rf "protobuf-$PROTOBUF_VERSION"
tar -xvf "protobuf-$PROTOBUF_VERSION.tar.gz"
# rm -f "protobuf-$PROTOBUF_VERSION.tar.gz"
pushd "protobuf-$PROTOBUF_VERSION"
if [ `uname` == "Darwin" ]; then
  ./configure --host arm-apple-darwin
else
  ./configure --host arm-linux
fi
popd
ln -sf "protobuf-$PROTOBUF_VERSION" "protobuf"

# Build
$NDK_BUILD -B V=1

# Package libsqlite3
rm -rf "../libsqlite3"
mkdir "../libsqlite3"
mv "../obj/local/armeabi-v7a/libsqlite3.a" "../libsqlite3/"
mv "sqlite-autoconf/sqlite3.h" "../libsqlite3/"
mv "sqlite-autoconf/sqlite3ext.h" "../libsqlite3/"

# Package lcms2
rm -rf "../liblcms2"
mkdir "../liblcms2"
mv "../obj/local/armeabi-v7a/liblcms2.a" "../liblcms2/"
mv "lcms2/include/lcms2.h" "../liblcms2/"
mv "lcms2/include/lcms2_plugin.h" "../liblcms2/"

# Package libjpeg-turbo
rm -rf "../libjpeg-turbo"
mkdir "../libjpeg-turbo"
mv "../obj/local/armeabi-v7a/libjpeg.a" "../libjpeg-turbo/"
mv "libjpeg-turbo/jconfig.h" "../libjpeg-turbo/"
mv "libjpeg-turbo/jerror.h" "../libjpeg-turbo/"
mv "libjpeg-turbo/jmorecfg.h" "../libjpeg-turbo/"
mv "libjpeg-turbo/jpeglib.h" "../libjpeg-turbo/"
mv "libjpeg-turbo/turbojpeg.h" "../libjpeg-turbo/"

# Package libexif
rm -rf "../libexif"
mkdir "../libexif"
mv "../obj/local/armeabi-v7a/libexif.a" "../libexif/"
mkdir "../libexif/libexif"
mv "libexif/libexif/_stdint.h" "../libexif/libexif/"
mv "libexif/libexif/exif-byte-order.h" "../libexif/libexif/"
mv "libexif/libexif/exif-content.h" "../libexif/libexif/"
mv "libexif/libexif/exif-data-type.h" "../libexif/libexif/"
mv "libexif/libexif/exif-data.h" "../libexif/libexif/"
mv "libexif/libexif/exif-entry.h" "../libexif/libexif/"
mv "libexif/libexif/exif-format.h" "../libexif/libexif/"
mv "libexif/libexif/exif-ifd.h" "../libexif/libexif/"
mv "libexif/libexif/exif-loader.h" "../libexif/libexif/"
mv "libexif/libexif/exif-log.h" "../libexif/libexif/"
mv "libexif/libexif/exif-mem.h" "../libexif/libexif/"
mv "libexif/libexif/exif-mnote-data.h" "../libexif/libexif/"
mv "libexif/libexif/exif-tag.h" "../libexif/libexif/"
mv "libexif/libexif/exif-utils.h" "../libexif/libexif/"

# Package libpng
rm -rf "../libpng"
mkdir "../libpng"
mv "../obj/local/armeabi-v7a/libpng.a" "../libpng/"
mv "libpng/png.h" "../libpng/"
mv "libpng/pngconf.h" "../libpng/"
mv "libpng/pnglibconf.h" "../libpng/"

# Package libwebp
rm -rf "../libwebp"
mkdir "../libwebp"
mv "../obj/local/armeabi-v7a/libwebp.a" "../libwebp/"
mkdir "../libwebp/webp"
mv "libwebp/src/webp/decode.h" "../libwebp/webp/"
mv "libwebp/src/webp/encode.h" "../libwebp/webp/"
mv "libwebp/src/webp/types.h" "../libwebp/webp/"

# Package libprotobuf
rm -rf "../libprotobuf"
mkdir "../libprotobuf"
mv "../obj/local/armeabi-v7a/libprotobuf.a" "../libprotobuf/"
mkdir "../libprotobuf/google"
mkdir "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/descriptor_database.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/descriptor.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/descriptor.pb.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/descriptor.proto" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/dynamic_message.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/extension_set.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/generated_enum_reflection.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/generated_message_reflection.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/generated_message_util.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/message_lite.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/message.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/reflection_ops.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/repeated_field.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/service.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/text_format.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/unknown_field_set.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/wire_format_lite_inl.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/wire_format_lite.h" "../libprotobuf/google/protobuf"
mv "protobuf/src/google/protobuf/wire_format.h" "../libprotobuf/google/protobuf"
mkdir "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/code_generator.h" "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/command_line_interface.h" "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/importer.h" "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/parser.h" "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/plugin.h" "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/plugin.pb.h" "../libprotobuf/google/protobuf/compiler"
mv "protobuf/src/google/protobuf/compiler/plugin.proto" "../libprotobuf/google/protobuf/compiler"
mkdir "../libprotobuf/google/protobuf/compiler/cpp"
mv "protobuf/src/google/protobuf/compiler/cpp/cpp_generator.h" "../libprotobuf/google/protobuf/compiler/cpp"
mkdir "../libprotobuf/google/protobuf/compiler/java"
mv "protobuf/src/google/protobuf/compiler/java/java_generator.h" "../libprotobuf/google/protobuf/compiler/java"
mkdir "../libprotobuf/google/protobuf/compiler/python"
mv "protobuf/src/google/protobuf/compiler/python/python_generator.h" "../libprotobuf/google/protobuf/compiler/python"
mkdir "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/coded_stream.h" "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/gzip_stream.h" "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/printer.h" "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/tokenizer.h" "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/zero_copy_stream_impl_lite.h" "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/zero_copy_stream_impl.h" "../libprotobuf/google/protobuf/io"
mv "protobuf/src/google/protobuf/io/zero_copy_stream.h" "../libprotobuf/google/protobuf/io"
mkdir "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_atomicword_compat.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_pnacl.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/common.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/template_util.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_arm_gcc.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_macosx.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_x86_gcc.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/once.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/type_traits.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_arm_qnx.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_mips_gcc.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/atomicops_internals_x86_msvc.h" "../libprotobuf/google/protobuf/stubs"
mv "protobuf/src/google/protobuf/stubs/platform_macros.h" "../libprotobuf/google/protobuf/stubs"

# Clean up
rm -f "sqlite-autoconf"
rm -rf "sqlite-autoconf-$SQLITE3_VERSION"
rm -f "lcms2"
rm -rf "lcms2-$LCMS2_VERSION"
rm -f "libjpeg-turbo"
rm -rf "libjpeg-turbo-$JPEG_VERSION"
rm -f "libexif"
rm -rf "libexif-$EXIF_VERSION"
rm -f "libpng"
rm -rf "libpng-$PNG_VERSION"
rm -f "libwebp"
rm -rf "libwebp-$WEBP_VERSION"
rm -f "protobuf"
rm -rf "protobuf-$PROTOBUF_VERSION"
rm -rf "../libs"
rm -rf "../obj"
