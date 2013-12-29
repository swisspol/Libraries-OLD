LOCAL_PATH := $(call my-dir)/liblcms2

include $(CLEAR_VARS)

LOCAL_MODULE             := lcms2
LOCAL_SRC_FILES          := liblcms2.a
LOCAL_EXPORT_C_INCLUDES  := $(LOCAL_PATH)

include $(PREBUILT_STATIC_LIBRARY)
