LOCAL_PATH := $(call my-dir)/libjpeg-turbo

include $(CLEAR_VARS)

LOCAL_MODULE             := jpeg
LOCAL_SRC_FILES          := libjpeg.a
LOCAL_EXPORT_C_INCLUDES  := $(LOCAL_PATH)

include $(PREBUILT_STATIC_LIBRARY)
