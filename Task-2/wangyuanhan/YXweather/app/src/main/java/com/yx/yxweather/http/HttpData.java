package com.yx.yxweather.http;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by YX on 2015/12/12.
 */
public class HttpData {
    private String httpUrl = "";
    private String httpArg = "";

    public HttpData(String httpUrl, String httpArg) {
        this.httpUrl = httpUrl;
        this.httpArg = httpArg;
    }

    public String getData() {
        BufferedReader reader = null;
        String result = null;
        StringBuffer buffer = new StringBuffer();
        httpUrl = httpUrl + httpArg;

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
}
