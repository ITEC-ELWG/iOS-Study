package com.yx.yxweather.data;

import android.os.Handler;
import android.os.Message;

import com.yx.yxweather.activity.MainActivity;
import com.yx.yxweather.http.HttpData;
import com.yx.yxweather.picture.BackgroundID;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by YX on 2015/12/10.
 */
public class Weather {
    private Handler handler;
    private int background;
    private String city;
    private String type;
    private String curTemp;
    private ArrayList<HashMap<String, String>> list;
    private String httpUrl = "http://apis.baidu.com/apistore/weatherservice/recentweathers?cityid=";
    private String httpArg = "";

    public Weather(Handler handler, String httpArg) {
        this.handler = handler;
        this.httpArg = httpArg;
        init();
    }

    public int getBackground() {
        return background;
    }

    public String getCity() {
        return city;
    }

    public String getType() {
        return type;
    }

    public String getCurTemp() {
        return curTemp;
    }

    public ArrayList<HashMap<String, String>> getList() {
        return list;
    }

    private void init() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                list = new ArrayList<>();
                try {
//                    Thread.sleep(1000); // test
                    String result = new HttpData(httpUrl, httpArg).getData();
                    parseJSON(result);

                    Message message = new Message();
                    message.what = MainActivity.END;
                    handler.sendMessage(message);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private void parseJSON(String result) {
        try {
            JSONObject jsonObject = new JSONObject(result);

            JSONObject retData = jsonObject.getJSONObject("retData");
            city = retData.getString("city");

            JSONObject today = retData.getJSONObject("today");
            type = today.getString("type");
            background = new BackgroundID(type).getBackgroundID();
            curTemp = today.getString("curTemp");
            HashMap<String, String> tempToday = new HashMap<>();
            tempToday.put(MainActivity.WEATHER_WEEK, today.getString("week"));
            tempToday.put(MainActivity.WEATHER_TYPE, today.getString("type"));
            tempToday.put(MainActivity.WEATHER_TEMPERATURE, today.getString("lowtemp") + " ~ " + today.getString("hightemp"));
            list.add(tempToday);

            JSONArray forecast = retData.getJSONArray("forecast");
            for (int i = 0; i < forecast.length(); i++) {
                JSONObject tempJson = (JSONObject) forecast.get(i);
                HashMap<String, String> tempHash = new HashMap<>();
                tempHash.put(MainActivity.WEATHER_WEEK, tempJson.getString("week"));
                tempHash.put(MainActivity.WEATHER_TYPE, tempJson.getString("type"));
                tempHash.put(MainActivity.WEATHER_TEMPERATURE, tempJson.getString("lowtemp") + " ~ " + today.getString("hightemp"));
                list.add(tempHash);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
