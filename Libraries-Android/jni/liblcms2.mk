LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PATH               := $(LOCAL_PATH)/lcms2/src
LOCAL_MODULE             := lcms2
LOCAL_C_INCLUDES         := $(LOCAL_PATH)/../include
LOCAL_SRC_FILES          := cmscam02.c \
                            cmscgats.c \
                            cmscnvrt.c \
                            cmserr.c \
                            cmsgamma.c \
                            cmsgmt.c \
                            cmshalf.c \
                            cmsintrp.c \
                            cmsio0.c \
                            cmsio1.c \
                            cmslut.c \
                            cmsmd5.c \
                            cmsmtrx.c \
                            cmsnamed.c \
                            cmsopt.c \
                            cmspack.c \
                            cmspcs.c \
                            cmsplugin.c \
                            cmsps2.c \
                            cmssamp.c \
                            cmssm.c \
                            cmstypes.c \
                            cmsvirt.c \
                            cmswtpnt.c \
                            cmsxform.c

include $(BUILD_STATIC_LIBRARY)
