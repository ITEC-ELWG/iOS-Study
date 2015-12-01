package com.yx.yxnote.adapter;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.widget.ArrayAdapter;

import com.yx.yxnote.database.NoteDB;

/**
 * Created by YX on 2015/11/30.
 */
public class AdapterInit {
    private Context context;
    private YXAdapter yxAdapter;
    private ArrayAdapter arrayAdapter;

    public AdapterInit(Context context, YXAdapter yxAdapter, ArrayAdapter arrayAdapter) {
        this.context = context;
        this.yxAdapter = yxAdapter;
        this.arrayAdapter = arrayAdapter;

        init();
    }

    private void init() {
        new Thread(){
            public void run(){
                SQLiteDatabase db = new NoteDB(context).getWritableDatabase();
                Cursor cursor = db.query(NoteDB.DB_TABLE_NAME, new String[]{NoteDB.DB_NOTE_TITLE},
                        null, null, null, null, NoteDB.DB_NOTE_TIME + " DESC", null);
                if (cursor.moveToFirst()) {
                    do {
                        String str = cursor.getString(cursor.getColumnIndex(NoteDB.DB_NOTE_TITLE));
                        if (str.equals("")) {
                            yxAdapter.add("无标题");
                        } else {
                            yxAdapter.add(str);
                            arrayAdapter.add(str);
                        }
                    } while (cursor.moveToNext());
                }
                cursor.close();
            }
        }.start();
    }

    public YXAdapter getYxAdapter() {
        return yxAdapter;
    }

    public ArrayAdapter getArrayAdapter() {
        return arrayAdapter;
    }
}
