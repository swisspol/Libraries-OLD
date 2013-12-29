LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PATH               := $(LOCAL_PATH)/protobuf/src
LOCAL_MODULE             := protobuf
LOCAL_CFLAGS             := -std=gnu++11
LOCAL_C_INCLUDES         := $(LOCAL_PATH)/..
LOCAL_SRC_FILES          := google/protobuf/extension_set.cc \
                            google/protobuf/message_lite.cc \
                            google/protobuf/generated_message_util.cc \
                            google/protobuf/wire_format_lite.cc \
                            google/protobuf/repeated_field.cc \
                            google/protobuf/stubs/once.cc \
                            google/protobuf/stubs/common.cc \
                            google/protobuf/io/zero_copy_stream_impl_lite.cc \
                            google/protobuf/io/coded_stream.cc \
                            google/protobuf/io/zero_copy_stream.cc \
                            google/protobuf/stubs/stringprintf.cc

include $(BUILD_STATIC_LIBRARY)
