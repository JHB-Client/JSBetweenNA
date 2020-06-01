package com.yuantu.jsbridgeandandroid;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.webkit.ValueCallback;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {

    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //
        webView = findViewById(R.id.my_webView);
        //2
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true); // 与js的交互权限
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true); // 允许js弹窗


        //JS调用Android
        webView.setWebViewClient(new WebViewClient(){
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                String urlStr = request.getUrl().toString();

                String scheme = request.getUrl().getScheme();
                if (scheme.equals("test")) {
                    String jsonStr = urlStr.substring(7);
                    try {
                        JSONObject jsonObject = new JSONObject(jsonStr);
                        JSONObject model = jsonObject.getJSONObject("model");
                        String sel = jsonObject.getString("sel");
                        //
                        String jsonAction = sel + "('" + model.toString() + "')";
                        android2JsAction(jsonAction);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                return true;
            }
        });

        //3
        String htmlUrl = "file:///android_asset/JSBridge.html";
        webView.loadUrl(htmlUrl);
    }


    //Android调用JS
    void android2JsAction(final String str) {

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                webView.evaluateJavascript(str, new ValueCallback<String>() {
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
