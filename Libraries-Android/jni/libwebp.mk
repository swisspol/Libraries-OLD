LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PATH               := $(LOCAL_PATH)/libwebp/src
LOCAL_MODULE             := webp
LOCAL_SRC_FILES          := dec/alpha.c \
                            dec/buffer.c \
                            dec/frame.c \
                            dec/idec.c \
                            dec/io.c \
                            dec/layer.c \
                            dec/quant.c \
                            dec/tree.c \
                            dec/vp8.c \
                            dec/vp8l.c \
                            dec/webp.c \
                            demux/demux.c \
                            dsp/cpu.c \
                            dsp/dec_neon.c.arm.neon \
                            dsp/dec.c \
                            dsp/enc_neon.c.arm.neon \
                            dsp/enc.c \
                            dsp/lossless.c \
                            dsp/upsampling_neon.c.arm.neon \
                            dsp/upsampling.c \
                            dsp/yuv.c \
                            enc/alpha.c \
                            enc/analysis.c \
                            enc/backward_references.c \
                            enc/config.c \
                            enc/cost.c \
                            enc/filter.c \
                            enc/frame.c \
                            enc/histogram.c \
                            enc/iterator.c \
                            enc/layer.c \
                            enc/picture.c \
                            enc/quant.c \
                            enc/syntax.c \
                            enc/token.c \
                            enc/tree.c \
                            enc/vp8l.c \
                            enc/webpenc.c \
                            mux/muxedit.c \
                            mux/muxinternal.c \
                            mux/muxread.c \
                            utils/bit_reader.c \
                            utils/bit_writer.c \
                            utils/color_cache.c \
                            utils/filters.c \
                            utils/huffman_encode.c \
                            utils/huffman.c \
                            utils/quant_levels_dec.c \
                            utils/quant_levels.c \
                            utils/rescaler.c \
                            utils/thread.c \
                            utils/utils.c
LOCAL_STATIC_LIBRARIES   := cpufeatures

include $(BUILD_STATIC_LIBRARY)

$(call import-module,android/cpufeatures)
