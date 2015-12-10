package com.yx.yxweather.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.yx.yxweather.model.City;
import com.yx.yxweather.model.County;
import com.yx.yxweather.model.Province;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by YX on 2015/11/28.
 */
public class YXweatherDB {
    public static final String DB_NAME = "YXweather";
    public static final int VERSION = 1;

    private static YXweatherDB yxweatherDB;
    private SQLiteDatabase db;

    private YXweatherDB(Context context) {
        YXweatherOpenHelper dbHelper = new YXweatherOpenHelper(context, DB_NAME, null, VERSION);
        db = dbHelper.getWritableDatabase();
    }

    public synchronized static YXweatherDB getInstance(Context context) {
        if (yxweatherDB == null) {
            yxweatherDB = new YXweatherDB(context);
        }

        return yxweatherDB;
    }

    public void saveProvince(Province province) {
        if (province != null) {
            ContentValues values = new ContentValues();
            values.put("province_name", province.getProvinceName());
            values.put("province_code", province.getProvinceCode());
            db.insert("Province", null, values);
        }
    }

    public void saveCity(City city) {
        if (city != null) {
            ContentValues values = new ContentValues();
            values.put("province_id", city.getProvinceId());
            values.put("city_name", city.getCityName());
            values.put("city_code", city.getCityCode());
            db.insert("City", null, values);
        }
    }

    public void saveCounty(County county) {
        if (county != null) {
            ContentValues values = new ContentValues();
            values.put("city_id", county.getCityId());
            values.put("county_name", county.getCountyName());
            values.put("county_code", county.getCountyCode());
            db.insert("County", null, values);
        }
    }

    public List<Province> loadProvince() {
        List<Province> list = new ArrayList<Province>();
        Cursor cursor = db.query("Province", null, null, null, null, null, null);

        if (cursor.moveToFirst()) {
            do {
                Province province = new Province();

                province.setId(cursor.getInt(cursor.getColumnIndex("id")));
                province.setProvinceName(cursor.getString(cursor.getColumnIndex("province_name")));
                province.setProvinceCode(cursor.getString(cursor.getColumnIndex("province_code")));

                list.add(province);
            } while (cursor.moveToNext());
        }

        if (cursor != null) {
            cursor.close();
        }

        return list;
    }

    public List<City> loadCity(int province_id) {
        List<City> list = new ArrayList<City>();
        Cursor cursor = db.query("City", null, "province_id = ?",
                new String[] {String.valueOf(province_id)}, null, null, null);

        if (cursor.moveToFirst()) {
            do {
                City city = new City();

                city.setId(cursor.getInt(cursor.getColumnIndex("id")));
                city.setProvinceId(province_id);
                city.setCityName(cursor.getString(cursor.getColumnIndex("city_name")));
                city.setCityCode(cursor.getString(cursor.getColumnIndex("city_code")));

                list.add(city);
            } while (cursor.moveToNext());
        }

        if (cursor != null) {
            cursor.close();
        }

        return list;
    }

    public List<County> loadCounty(int city_id) {
        List<County> list = new ArrayList<County>();
        Cursor cursor = db.query("County", null, "city_id = ?",
                new String[] {String.valueOf(city_id)}, null, null, null);

        if (cursor.moveToFirst()) {
            do {
                County county = new County();

                county.setId(cursor.getInt(cursor.getColumnIndex("id")));
                county.setCityId(city_id);
                county.setCountyName(cursor.getString(cursor.getColumnIndex("county_name")));
                county.setCountyCode(cursor.getString(cursor.getColumnIndex("county_code")));

                list.add(county);
            } while (cursor.moveToNext());
        }

        if (cursor != null) {
            cursor.close();
        }

        return list;
    }
}
