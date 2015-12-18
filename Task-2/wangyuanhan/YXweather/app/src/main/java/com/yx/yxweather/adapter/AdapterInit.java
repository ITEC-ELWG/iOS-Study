package com.yx.yxweather.adapter;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Handler;
import android.os.Message;
import android.widget.ArrayAdapter;

import com.yx.yxweather.activity.SearchActivity;
import com.yx.yxweather.database.CityDB;

/**
 * Created by YX on 2015/12/12.
 */
public class AdapterInit {
    private Context context;
    private ArrayAdapter adapter;
    private Handler handler;

    public AdapterInit(Context context, ArrayAdapter adapter) {
        this.context = context;
        this.adapter = adapter;
    }

    public AdapterInit(Context context, ArrayAdapter adapter, Handler handler) {
        this.context = context;
        this.adapter = adapter;
        this.handler = handler;
        init();
    }

    private void init() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                SQLiteDatabase db = new CityDB(context).getReadableDatabase();
                Cursor cursor = db.query(CityDB.DB_TABLE_NAME_SEARCH, null, null, null, null, null, null, null);
                if (cursor.moveToFirst()) {
                    do {
                        String str1 = cursor.getString(cursor.getColumnIndex(CityDB.DB_SEARCH_CITY));
                        String str2 = cursor.getString(cursor.getColumnIndex(CityDB.DB_SEARCH_PROVINCE));
                        adapter.add(str1 + "（" + str2 + "）");
                    } while (cursor.moveToNext());
                }
                cursor.close();
                db.close();

                Message message = new Message();
                message.what = SearchActivity.END;
                handler.sendMessage(message);
            }
        }).start();
    }

    public ArrayAdapter getAdapter() {
        return adapter;
    }
}
