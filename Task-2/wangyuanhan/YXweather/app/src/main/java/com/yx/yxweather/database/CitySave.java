package com.yx.yxweather.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

/**
 * Created by YX on 2015/12/15.
 */
public class CitySave {
    private Context context;
    private String city;
    private String code;

    public CitySave(Context context, String city, String code) {
        this.context = context;
        this.city = city;
        this.code = code;
    }

    public void saveCity() {
        SQLiteDatabase db = new CityDB(context).getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(CityDB.DB_SAVE_CITY, city);
        values.put(CityDB.DB_SAVE_CODE, code);
        db.insert(CityDB.DB_TABLE_NAME_SAVE, null, values);
    }
}
