LOCAL_PATH := $(call my-dir)/libprotobuf

include $(CLEAR_VARS)

LOCAL_MODULE             := protobuf
LOCAL_SRC_FILES          := libprotobuf.a
LOCAL_EXPORT_C_INCLUDES  := $(LOCAL_PATH)

include $(PREBUILT_STATIC_LIBRARY)
