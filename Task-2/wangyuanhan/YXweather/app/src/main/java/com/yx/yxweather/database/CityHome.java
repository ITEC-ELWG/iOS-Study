package com.yx.yxweather.database;

import android.content.Context;

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
public class CityHome {
    private Context context;

    public CityHome(Context context) {
        this.context = context;
    }

    public void saveHomeCity(String code) {
        FileOutputStream out;
        BufferedWriter writer = null;

        try {
            out = context.openFileOutput("cityhome", Context.MODE_PRIVATE);
            writer = new BufferedWriter(new OutputStreamWriter(out));
            writer.write(code);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (writer != null) {
                    writer.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public String loadHomeCity() {
        FileInputStream in;
        BufferedReader reader = null;
        StringBuilder code = new StringBuilder();

        try {
            in = context.openFileInput("cityhome");
            reader = new BufferedReader(new InputStreamReader(in));
            String line;
            while ((line = reader.readLine()) != null) {
                code.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return code.toString();
    }
}
