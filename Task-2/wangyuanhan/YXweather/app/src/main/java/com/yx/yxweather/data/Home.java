package com.yx.yxweather.data;

import android.content.Context;
import android.content.SharedPreferences;
import android.widget.LinearLayout;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

/**
 * Created by YX on 2015/12/16.
 */
public class Home {
    private Context context;

    public Home(Context context) {
        this.context = context;
    }

    public void saveHome(int background, String code) {
        SharedPreferences.Editor editor = context.getSharedPreferences("data", Context.MODE_PRIVATE).edit();
        editor.putInt("background", background);
        editor.putString("code", code);
        editor.commit();
    }

    public int loadHomeBackground() {
        SharedPreferences preferences = context.getSharedPreferences("data", Context.MODE_PRIVATE);
        return preferences.getInt("background", 0);
    }

    public String loadHomeCode() {
        SharedPreferences preferences = context.getSharedPreferences("data", Context.MODE_PRIVATE);
        return preferences.getString("code", "");
    }
}
