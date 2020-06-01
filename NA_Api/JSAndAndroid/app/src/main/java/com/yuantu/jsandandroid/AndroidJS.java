package com.yuantu.jsandandroid;

import android.content.Context;
import android.webkit.JavascriptInterface;
import android.widget.Toast;

public class AndroidJS {

    public interface AndroidToJSInterface {
        void androidToJS(String str);
    }
    public AndroidToJSInterface androidToJSInterface;
    public void setAndroidToJSInterface(AndroidToJSInterface androidToJSInterface) {
        this.androidToJSInterface = androidToJSInterface;
    }

    @JavascriptInterface
    public void showToast(String str) {
        System.out.println("JS调用了Android:-------" + str);
        if (androidToJSInterface != null) {
            androidToJSInterface.androidToJS("Android 调用了JS:alert");
        }
    }
}
