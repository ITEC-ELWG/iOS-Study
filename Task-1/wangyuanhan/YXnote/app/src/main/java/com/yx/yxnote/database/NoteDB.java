package com.yx.yxnote.database;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.widget.ArrayAdapter;

import com.yx.yxnote.adapter.YXadapter;

/**
 * Created by YX on 2015/11/13.
 */
public class NoteDB extends SQLiteOpenHelper{
    private static final String DB_TABLE_NAME = "note";
    private static final String DB_COLUMN_ID = "_id";
    private static final String DB_TITLE = "title";
    private static final String DB_CONTENT = "content";
    private static final String DB_TIME = "time";

    private String title = null;
    private SQLiteDatabase db = this.getWritableDatabase();

    private static String content = null;
    private static String time = null;
    private static YXadapter<String> adapter;
    private static ArrayAdapter<String> array_adapter;

    public NoteDB(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
        super(context, name, factory, version);
    }

    public NoteDB(Context context, String name, SQLiteDatabase.CursorFactory factory, int version, YXadapter<String> adapter) {
        super(context, name, factory, version);
        this.adapter = adapter;
    }

    public NoteDB(Context context, String name, SQLiteDatabase.CursorFactory factory, int version, ArrayAdapter<String> array_adapter) {
        super(context, name, factory, version);
        this.array_adapter = array_adapter;
    }

    public NoteDB(Context context, String name, SQLiteDatabase.CursorFactory factory, int version, String title) {
        super(context, name, factory, version);
        this.title = title;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE "
                + DB_TABLE_NAME + " ("
                + DB_COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + DB_TITLE + " TEXT NOT NULL, "
                + DB_CONTENT + " TEXT NOT NULL, "
                + DB_TIME + " TEXT NOT NULL);");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }

    public YXadapter<String> initNote() {
        Cursor cursor = db.query(DB_TABLE_NAME, new String[]{DB_TITLE}, null, null, null, null, DB_TIME + " DESC", null);

        if (cursor.moveToFirst()) {
            do {
                adapter.add(cursor.getString(cursor.getColumnIndex(DB_TITLE)));
                array_adapter.add(cursor.getString(cursor.getColumnIndex(DB_TITLE)));
            } while (cursor.moveToNext());
        }

        cursor.close();
        return adapter;
    }

    public ArrayAdapter<String> searchNote() {
        return array_adapter;
    }

    public String getContent() {
        Cursor cursor = db.query(DB_TABLE_NAME, null, null, null, null, null, null, null);

        if (cursor.moveToFirst()) {
            do {
                if (title.equals(cursor.getString(cursor.getColumnIndex(DB_TITLE)))) {
                    content = cursor.getString(cursor.getColumnIndex(DB_CONTENT));
                    time = cursor.getString(cursor.getColumnIndex(DB_TIME));
                }
            } while (cursor.moveToNext());
        }

        cursor.close();
        return content;
    }

    public String getTime() {
        return time;
    }
}