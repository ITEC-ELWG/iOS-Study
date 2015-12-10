package com.yx.yxweather.data;

import android.os.Handler;
import android.os.Message;

import com.yx.yxweather.activity.MainActivity;

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
    private String city;
    private String type;
    private String curTemp;
    private ArrayList<HashMap<String, String>> list;

    public Weather(Handler handler) {
        this.handler = handler;
        init();
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
                String httpUrl = "http://apis.baidu.com/apistore/weatherservice/recentweathers";
                String httpArg = "cityname=%E5%8C%97%E4%BA%AC&cityid=101010100";

                try {
                    Thread.sleep(1000); // test
                    String result = httpRequest(httpUrl, httpArg);
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

    private static String httpRequest(String httpUrl, String httpArg) {
        BufferedReader reader = null;
        String result = null;
        StringBuffer buffer = new StringBuffer();
        httpUrl = httpUrl + "?" + httpArg;

        try {
            URL url = new URL(httpUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("apikey",  "090af4ffa23943002a9388c59a9e3081");
            connection.connect();
            InputStream is = connection.getInputStream();
            reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String bufferRead = null;
            while ((bufferRead = reader.readLine()) != null) {
                buffer.append(bufferRead);
                buffer.append("\r\n");
            }
            reader.close();
            result = buffer.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private void parseJSON(String result) {
        try {
            JSONObject jsonObject = new JSONObject(result);

            JSONObject retData = jsonObject.getJSONObject("retData");
            System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>" + retData);
            city = retData.getString("city");

            JSONObject today = retData.getJSONObject("today");
            type = today.getString("type");
            curTemp = today.getString("curTemp");
            HashMap<String, String> tempToday = new HashMap<>();
            tempToday.put(MainActivity.WEEKLY_WEEK, today.getString("week"));
            tempToday.put(MainActivity.WEEKLY_TYPE, today.getString("type"));
            tempToday.put(MainActivity.WEEKLY_TEMPERATURE, today.getString("lowtemp") + " ~ " + today.getString("hightemp"));
            list.add(tempToday);

            JSONArray forecast = retData.getJSONArray("forecast");
            for (int i = 0; i < forecast.length(); i++) {
                JSONObject tempJson = (JSONObject) forecast.get(i);
                HashMap<String, String> tempHash = new HashMap<>();
                tempHash.put(MainActivity.WEEKLY_WEEK, tempJson.getString("week"));
                tempHash.put(MainActivity.WEEKLY_TYPE, tempJson.getString("type"));
                tempHash.put(MainActivity.WEEKLY_TEMPERATURE, tempJson.getString("lowtemp") + " ~ " + today.getString("hightemp"));
                list.add(tempHash);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
