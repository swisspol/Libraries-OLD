#include <stdio.h>

#include <sqlite3.h>
#include <jpeglib.h>
#include <webp/encode.h>
#include <png.h>
#include <lcms2.h>
#include <google/protobuf/io/zero_copy_stream_impl_lite.h>
#include <libexif/exif-data.h>
#include <exiv2/exiv2.hpp>
#include <leptonica/allheaders.h>
#include <tesseract/baseapi.h>
#include <lame/lame.h>
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavdevice/avdevice.h>
#include <libavfilter/avfilter.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libswresample/swresample.h>
#include <libswscale/swscale.h>
}

#include "libraries.h"

using namespace google::protobuf::io;

void test_libraries() {
  // Test libsqlite3
  sqlite3_libversion();
  
  // Test libjpeg-turbo
  struct jpeg_compress_struct cinfo;
  jpeg_create_compress(&cinfo);
  jpeg_destroy_compress(&cinfo);
  
  // Test libwebp
  WebPConfig config;
  WebPConfigInit(&config);
  
  // Test libpng
  png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
  png_destroy_write_struct(&png_ptr, NULL);
  
  // Test liblcms2
  cmsHPROFILE input_profile = cmsOpenProfileFromMem(NULL, 0);
  if (input_profile) {
    cmsCloseProfile(input_profile);
  }
  
  // Test libprotobuf-lite
  ArrayInputStream* stream = new ArrayInputStream(NULL, 0);
  delete stream;
  
  // Test libexif
  ExifData* exif = exif_data_new();
  exif_data_unref(exif);
  
  // Test libexiv2
  Exiv2::ExifData* data = new Exiv2::ExifData();
  delete data;
  
  // Test liblept
  PIX* pix = pixCreate(1, 1, 8);
  pixDestroy(&pix);
  
  // Test libtesseract
  tesseract::TessBaseAPI::Version();
  
  // Test libmp3lame
  lame_global_flags* flags = lame_init();
  lame_close(flags);
  
  // Test ffmpeg / libavcodec
  avcodec_version();
  
  // Test ffmpeg / libavdevice
  avdevice_version();
  
  // Test ffmpeg / libavfilter
  avfilter_version();
  
  // Test ffmpeg / libavformat
  avformat_version();
  
  // Test ffmpeg / libavutil
  avutil_version();
  
  // Test ffmpeg / libswresample
  swresample_version();
  
  // Test ffmpeg / libswscale
  swscale_version();
}
