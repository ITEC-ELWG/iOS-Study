package com.yx.yxweather.database;

import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.yx.yxweather.R;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

/**
 * Created by YX on 2015/12/11.
 */
public class CityDB extends SQLiteOpenHelper {
    public static final String DB_TABLE_NAME_SAVE = "save";
    public static final String DB_SAVE_ID = "_id";
    public static final String DB_SAVE_CITY = "city";
    public static final String DB_SAVE_CODE = "code";
    public static final String DB_TABLE_NAME_SEARCH = "search";
    public static final String DB_SEARCH_ID = "_id";
    public static final String DB_SEARCH_CITY = "city";
    public static final String DB_SEARCH_CODE = "code";
    public static final String DB_SEARCH_PROVINCE = "province";

    private Context context;
    private String temp;
    private SQLiteDatabase db;

    public CityDB(Context context) {
        super(context, "city.db", null, 1);
        this.context = context;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE "
                + DB_TABLE_NAME_SAVE + " ("
                + DB_SAVE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + DB_SAVE_CITY + " TEXT NOT NULL, "
                + DB_SAVE_CODE + " TEXT NOT NULL);");

        db.execSQL("CREATE TABLE "
                + DB_TABLE_NAME_SEARCH + " ("
                + DB_SEARCH_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + DB_SEARCH_CITY + " TEXT NOT NULL, "
                + DB_SEARCH_CODE + " TEXT NOT NULL, "
                + DB_SEARCH_PROVINCE + " TEXT NOT NULL);");

        init();
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    private void init() {
        SharedPreferences.Editor editor = context.getSharedPreferences("data", Context.MODE_PRIVATE).edit();
        editor.putInt("background", R.drawable.sunny);
        editor.putString("code", "101010100");
        editor.commit();

        new Thread(new Runnable() {
            @Override
            public void run() {
                String data = readData();
                parseJSON(data);
            }
        }).start();
    }

    private String readData() {
        InputStream inputStream = context.getResources().openRawResource(R.raw.data);
        InputStreamReader inputStreamReader = null;

        try {
            inputStreamReader = new InputStreamReader(inputStream, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        BufferedReader bufferedReader= new BufferedReader(inputStreamReader);
        StringBuffer buffer = new StringBuffer("");
        String line;

        try {
            while ((line = bufferedReader.readLine()) != null) {
                buffer.append(line);
                buffer.append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return buffer.toString();
    }

    private void parseJSON(String data) {
        try {
            db = new CityDB(context).getWritableDatabase();
            JSONObject jsonObject = new JSONObject(data);
            JSONArray cityCode = jsonObject.getJSONArray("城市代码");
            for (int i = 0; i < cityCode.length(); i++) {
                JSONObject provinceJson = (JSONObject) cityCode.get(i);
                temp = provinceJson.getString("省");
                JSONArray city = provinceJson.getJSONArray("市");
                for (int j = 0; j < city.length(); j++) {
                    JSONObject cityJson = (JSONObject) city.get(j);
                    ContentValues values = new ContentValues();
                    values.put(DB_SEARCH_CITY, cityJson.getString("市名"));
                    values.put(DB_SEARCH_CODE, cityJson.getString("编码"));
                    values.put(DB_SEARCH_PROVINCE, temp);
                    db.insert(DB_TABLE_NAME_SEARCH, null, values);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
