package co.ovlu;

import android.os.Build;
import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import org.jshybugger.DebugServiceClient;

public class OvluActivity extends Activity
{
    /** Called when the activity is first created. */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ovlu);
        /*if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
            WebView.setWebContentsDebuggingEnabled(true);
        }*/
        WebView webView = (WebView)findViewById(R.id.webView);
        Log.d("OvluActivity", "webView : " + webView);
        //System.out.println(webView);
        webView.setWebChromeClient(new WebChromeClient(){
            public void onConsoleMessage(String message, int lineNumber, String sourceID) {
            Log.d("Ovlu", message + " -- From line "
                                 + lineNumber + " of "
                                 + sourceID);
  }
        });
        
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setAllowFileAccessFromFileURLs(true); //Maybe you don't need this rule
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        webSettings.setDomStorageEnabled(true);
        
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        
        //DebugServiceClient.attachWebView(webView, this);

        //webView.loadUrl(DebugServiceClient.getDebugUrl("file:///android_asset/webapp/index.html"));
        webView.loadUrl("file:///android_asset/webapp/index.html");
 
    }
}
