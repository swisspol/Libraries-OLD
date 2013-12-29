BASE_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PATH := $(BASE_PATH)

LOCAL_MODULE           := android
LOCAL_STATIC_LIBRARIES := png webp jpeg lcms2 sqlite3 exif protobuf

include $(BUILD_SHARED_LIBRARY)

include $(BASE_PATH)/libsqlite3.mk \
        $(BASE_PATH)/liblcms2.mk \
        $(BASE_PATH)/libjpeg.mk \
        $(BASE_PATH)/libpng.mk \
        $(BASE_PATH)/libwebp.mk \
        $(BASE_PATH)/libexif.mk \
        $(BASE_PATH)/libprotobuf.mk
