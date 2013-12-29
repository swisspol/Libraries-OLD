LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PATH               := $(LOCAL_PATH)/libjpeg-turbo
LOCAL_MODULE             := jpeg
LOCAL_ARM_NEON           := true
LOCAL_CFLAGS             := -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon
LOCAL_SRC_FILES          := jcapimin.c \
                            jcapistd.c \
                            jccoefct.c \
                            jccolor.c \
                            jcdctmgr.c \
                            jchuff.c \
                            jcinit.c \
                            jcmainct.c \
                            jcmarker.c \
                            jcmaster.c \
                            jcomapi.c \
                            jcparam.c \
                            jcphuff.c \
                            jcprepct.c \
                            jcsample.c \
                            jctrans.c \
                            jdapimin.c \
                            jdapistd.c \
                            jdatadst.c \
                            jdatasrc.c \
                            jdcoefct.c \
                            jdcolor.c \
                            jddctmgr.c \
                            jdhuff.c \
                            jdinput.c \
                            jdmainct.c \
                            jdmarker.c \
                            jdmaster.c \
                            jdmerge.c \
                            jdphuff.c \
                            jdpostct.c \
                            jdsample.c \
                            jdtrans.c \
                            jerror.c \
                            jfdctflt.c \
                            jfdctfst.c \
                            jfdctint.c \
                            jidctflt.c \
                            jidctfst.c \
                            jidctint.c \
                            jidctred.c \
                            jquant1.c \
                            jquant2.c \
                            jutils.c \
                            jmemmgr.c \
                            jmemnobs.c \
                            jaricom.c \
                            jcarith.c \
                            jdarith.c \
                            turbojpeg.c \
                            transupp.c \
                            jdatadst-tj.c \
                            jdatasrc-tj.c \
                            simd/jsimd_arm.c \
                            simd/jsimd_arm_neon.S

include $(BUILD_STATIC_LIBRARY)
