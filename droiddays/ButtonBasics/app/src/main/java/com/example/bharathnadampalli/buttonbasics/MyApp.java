package com.example.bharathnadampalli.buttonbasics;

import android.app.Application;
import android.content.res.Configuration;
import android.util.Log;

public class MyApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Log.i("MyApp","OnCreate");
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        Log.i("MyApp","OnMemory");
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        Log.i("MyApp","OnConfigurationChanged");
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        Log.i("MyApp","OnTerminate");
    }
}
