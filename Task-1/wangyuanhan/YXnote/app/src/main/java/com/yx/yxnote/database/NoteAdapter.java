package com.yx.yxnote.database;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.widget.ArrayAdapter;

import com.yx.yxnote.adapter.YXAdapter;

/**
 * Created by YX on 2015/11/30.
 */
public class NoteAdapter {
    private Context context;
    private YXAdapter yxAdapter;
    private ArrayAdapter arrayAdapter;

    public NoteAdapter(Context context, YXAdapter yxAdapter) {
        this.context = context;
        this.yxAdapter = yxAdapter;
    }

    public NoteAdapter(Context context, ArrayAdapter arrayAdapter) {
        this.context = context;
        this.arrayAdapter = arrayAdapter;
    }

    public YXAdapter getYxAdapter() {
        SQLiteDatabase db = new NoteDB(context).getWritableDatabase();
        Cursor cursor = db.query(NoteDB.DB_TABLE_NAME, new String[]{NoteDB.DB_NOTE_TITLE},
                null, null, null, null, NoteDB.DB_NOTE_TIME + " DESC", null);
        if (cursor.moveToFirst()) {
            do {
                yxAdapter.add(cursor.getString(cursor.getColumnIndex(NoteDB.DB_NOTE_TITLE)));
            } while (cursor.moveToNext());
        }
        cursor.close();

        return yxAdapter;
    }

    public ArrayAdapter getArrayAdapter() {
        SQLiteDatabase db = new NoteDB(context).getWritableDatabase();
        Cursor cursor = db.query(NoteDB.DB_TABLE_NAME, new String[]{NoteDB.DB_NOTE_TITLE},
                null, null, null, null, NoteDB.DB_NOTE_TIME + " DESC", null);
        if (cursor.moveToFirst()) {
            do {
                arrayAdapter.add(cursor.getString(cursor.getColumnIndex(NoteDB.DB_NOTE_TITLE)));
            } while (cursor.moveToNext());
        }
        cursor.close();

        return arrayAdapter;
    }
}
