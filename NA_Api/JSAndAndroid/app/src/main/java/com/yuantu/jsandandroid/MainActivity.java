package com.yuantu.jsandandroid;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private Button my_btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //1
        webView = findViewById(R.id.my_webView);
        //2
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true); // 与js的交互权限
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true); // 允许js弹窗


        //JS调用Android
        AndroidJS androidJS = new AndroidJS();
        webView.addJavascriptInterface(androidJS, "my_test");
        androidJS.setAndroidToJSInterface(new AndroidJS.AndroidToJSInterface() {
            @Override
            public void androidToJS(String str) {
                android2JsAction("你好!");
            }
        });

        //3
        String htmlUrl = "file:///android_asset/JSAndNA.html";
        webView.loadUrl(htmlUrl);
    }

    //Android调用JS
    void android2JsAction(final String str) {

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String jsAction = "alertWithStr('" + str + "')";
                webView.evaluateJavascript(jsAction, new ValueCallback<String>() {
                    @Override
                    public void onReceiveValue(String value) {
                        //
                        System.out.println("-------js返回的结果:value===" + value);
                    }
                });
            }
        });

    }


}


