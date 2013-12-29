package com.example.test;

import android.app.Activity;
import android.widget.TextView;
import android.os.Bundle;

public class Test extends Activity
{
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    
    TextView  tv = new TextView(this);
    tv.setText( test() );
    setContentView(tv);
  }
  
  /* Implemented by native library */
  public native String test();
  
  static {
    System.loadLibrary("test");
  }
}
