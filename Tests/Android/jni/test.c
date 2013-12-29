#include <jni.h>
#include <string.h>

#include "libraries.h"

jstring Java_com_example_test_Test_test(JNIEnv* env, jobject thiz) {
  test_libraries();
  return (*env)->NewStringUTF(env, "OK");
}
