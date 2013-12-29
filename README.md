Overview
========

This repository contains various open source libraries precompiled as static libraries and ready-to-use for OS X & iOS. The build scripts are also provided.

* libexif
* libexiv2
* libexpat
* libjpeg-turbo
* liblcms2
* liblept (with PNG & JPEG support)
* libpng
* libprotobuf
* libsqlite3
* libtesseract
* libwebp

Building
========

To (re)build all libraries for both OS X, iPhone Simulator and iPhone OS, simply run the "build-all.sh" command in Terminal while in the "Build-Scripts" directory.

The build scripts were tested on OS X 10.9 with Xcode 5.0.1.

**IMPORTANT:** Note that libjpeg-turbo does not currently build with NEON support for iPhone OS due to the change from LLVM-GCC-4.2 to Clang in Xcode 5. The libjpeg-turbo libraries for OS X and iOS are therefore the pre-built ones from http://sourceforge.net/projects/libjpeg-turbo/files/.

Using
=====

To use these libraries in your OS X or iOS Xcode projects, you will need to configure the build settings to reference the header ("include" directories) and library files ("lib" directories).

See the included test projects for an example.
