BASE_PATH := $(call my-dir)
THIRD_PARTY_PATH := $(BASE_PATH)/../../../Libraries-Android

include $(CLEAR_VARS)

LOCAL_PATH := $(BASE_PATH)

LOCAL_MODULE           := test
LOCAL_CPP_EXTENSION    := .cc
LOCAL_CFLAGS           := -std=c99 -DNDEBUG
LOCAL_C_INCLUDES       := ../..
LOCAL_SRC_FILES        := test.c ../../libraries.cc
LOCAL_STATIC_LIBRARIES := jpeg lcms2 png sqlite3 webp exif protobuf
LOCAL_LDLIBS           := -L$(SYSROOT)/usr/lib -lz

include $(BUILD_SHARED_LIBRARY)

include $(THIRD_PARTY_PATH)/libjpeg-turbo.mk \
        $(THIRD_PARTY_PATH)/liblcms2.mk \
        $(THIRD_PARTY_PATH)/libpng.mk \
        $(THIRD_PARTY_PATH)/libsqlite3.mk \
        $(THIRD_PARTY_PATH)/libwebp.mk \
        $(THIRD_PARTY_PATH)/libexif.mk \
        $(THIRD_PARTY_PATH)/libprotobuf.mk
