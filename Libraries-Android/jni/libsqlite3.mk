LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PATH               := $(LOCAL_PATH)/sqlite-autoconf
LOCAL_MODULE             := sqlite3
LOCAL_CFLAGS             := -DSQLITE_THREADSAFE=2
LOCAL_SRC_FILES          := sqlite3.c

include $(BUILD_STATIC_LIBRARY)
