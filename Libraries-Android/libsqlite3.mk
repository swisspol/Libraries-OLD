LOCAL_PATH := $(call my-dir)/libsqlite3

include $(CLEAR_VARS)

LOCAL_MODULE             := sqlite3
LOCAL_SRC_FILES          := libsqlite3.a
LOCAL_EXPORT_C_INCLUDES  := $(LOCAL_PATH)

include $(PREBUILT_STATIC_LIBRARY)
