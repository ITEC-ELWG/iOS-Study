package com.yx.yxweather.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

/**
 * Created by YX on 2015/12/15.
 */
public class CityDelete {
    private Context context;

    public CityDelete(Context context) {
        this.context = context;
    }

    public void deleteCity(String cityDelete) {
        SQLiteDatabase db = new CityDB(context).getWritableDatabase();
        db.delete(CityDB.DB_TABLE_NAME_SAVE, "city = ?", new String[]{cityDelete});
        db.close();

        Toast.makeText(context, "删除成功", Toast.LENGTH_SHORT).show();
    }
}
