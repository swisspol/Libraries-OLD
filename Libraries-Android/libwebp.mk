LOCAL_PATH := $(call my-dir)/libwebp

include $(CLEAR_VARS)

LOCAL_MODULE             := webp
LOCAL_SRC_FILES          := libwebp.a
LOCAL_EXPORT_C_INCLUDES  := $(LOCAL_PATH)
LOCAL_STATIC_LIBRARIES   := cpufeatures

include $(PREBUILT_STATIC_LIBRARY)

$(call import-module,android/cpufeatures)
