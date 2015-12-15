package com.yx.yxweather.data;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Handler;
import android.os.Message;

import com.yx.yxweather.activity.SaveActivity;
import com.yx.yxweather.database.CityDB;

import java.util.ArrayList;

/**
 * Created by YX on 2015/12/14.
 */
public class City {
    private Handler handler;
    private Context context;
    private String city;
    private Intent intent;
    private ArrayList<String> list = new ArrayList<>();

    public City(Context context, Handler handler) {
        this.context = context;
        this.handler = handler;
        init();
    }

    public City(Context context, String city, Intent intent) {
        this.context = context;
        this.city = city;
        this.intent = intent;
    }

    public ArrayList<String> getList() {
        return list;
    }

    private void init() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                SQLiteDatabase db = new CityDB(context).getReadableDatabase();
                Cursor cursor = db.query(CityDB.DB_TABLE_NAME_SAVE, null, null, null, null, null, null, null);
                if (cursor.moveToFirst()) {
                    do {
                        String str = cursor.getString(cursor.getColumnIndex(CityDB.DB_SAVE_CITY));
                        list.add(str);
                    } while (cursor.moveToNext());
                }
                cursor.close();
                db.close();

                Message message = new Message();
                message.what = SaveActivity.COMPLETE;
                handler.sendMessage(message);
            }
        }).start();
    }

    public Intent addCity() {
        SQLiteDatabase db = new CityDB(context).getReadableDatabase();
        Cursor cursor = db.query(CityDB.DB_TABLE_NAME_SEARCH, null, null, null, null, null, null, null);
        if (cursor.moveToFirst()) {
            do {
                String str1 = cursor.getString(cursor.getColumnIndex(CityDB.DB_SEARCH_CITY));
                String str2 = cursor.getString(cursor.getColumnIndex(CityDB.DB_SEARCH_PROVINCE));
                if (city.equals(str1 + "（" + str2 + "）")) {
                    intent.putExtra(CityDB.DB_SEARCH_CODE, cursor.getString(cursor.getColumnIndex(CityDB.DB_SEARCH_CODE)));
                    intent.putExtra(CityDB.DB_SAVE_CITY, city);
                    break;
                }
            } while (cursor.moveToNext());
        }
        cursor.close();
        db.close();
        return intent;
    }
}
