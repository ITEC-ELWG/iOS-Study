package com.yx.yxweather.database;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/**
 * Created by YX on 2015/12/15.
 */
public class CityOpen {
    private Context context;
    private int position;
    private Intent intent;

    public CityOpen(Context context, int position, Intent intent) {
        this.context = context;
        this.position = position;
        this.intent = intent;
    }

    public Intent openCity() {
        SQLiteDatabase db = new CityDB(context).getReadableDatabase();
        Cursor cursor = db.query(CityDB.DB_TABLE_NAME_SAVE, null, null, null, null, null, null, null);
        cursor.moveToPosition(position);
        intent.putExtra(CityDB.DB_SAVE_CODE, cursor.getString(cursor.getColumnIndex(CityDB.DB_SAVE_CODE)));
        cursor.close();
        db.close();
        return intent;
    }
}
