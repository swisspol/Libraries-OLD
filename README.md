Overview
========

This repository contains various open source libraries precompiled as static libraries and ready-to-use for OS X (i386, x86_64) & iOS (armv7, armv7s). The build scripts are also provided.

* libexif
* libexiv2
* libexpat
* libjpeg-turbo (*)
* liblcms2
* liblept (with PNG & JPEG support)
* libmp3lame
* libpng
* libprotobuf
* libsqlite3 (with default threading mode set to multi-threaded i.e. SQLITE_THREADSAFE=2)
* libtesseract
* libwebp

(*) See [this message](http://sourceforge.net/mailarchive/message.php?msg_id=31902239) from the libjpeg-turbo-users mailing list for important information about performance regression when using Clang instead of GCC to compile the library.

Building
========

To (re)build all libraries for both OS X, iPhone Simulator and iPhone OS, simply run the "build-all.sh" command in Terminal while in the "Build-Scripts" directory.

The build scripts were tested on OS X 10.9 with Xcode 5.0.1.

Using
=====

To use these libraries in your OS X or iOS Xcode projects, you will need to configure the build settings to reference the header ("include" directories) and library files ("lib" directories).

See the included test projects for an example.
