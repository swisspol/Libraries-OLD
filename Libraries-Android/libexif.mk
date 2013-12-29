LOCAL_PATH := $(call my-dir)/libexif

include $(CLEAR_VARS)

LOCAL_MODULE             := exif
LOCAL_SRC_FILES          := libexif.a
LOCAL_EXPORT_C_INCLUDES  := $(LOCAL_PATH)

include $(PREBUILT_STATIC_LIBRARY)
