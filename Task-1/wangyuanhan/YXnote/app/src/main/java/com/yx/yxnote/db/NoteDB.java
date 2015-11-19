package com.yx.yxnote.db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.widget.ArrayAdapter;

import com.yx.yxnote.ad.YXadapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by YX on 2015/11/13.
 */
public class NoteDB extends SQLiteOpenHelper{

    private static final String DB_TABLE_NAME = "note";
    private static final String DB_COLUMN_ID = "_id";
    private static final String DB_TITLE = "title";
    private static final String DB_CONTENT = "content";
    private static final String DB_TIME = "time";

    private SQLiteDatabase db = this.getWritableDatabase();
    private YXadapter<String> adapter;
    private ArrayAdapter<String> array_adapter;

    private String title = null;

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

        db.execSQL("CREATE TABLE " + DB_TABLE_NAME + " ("
                + DB_COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + DB_TITLE + " TEXT NOT NULL, "
                + DB_CONTENT + " TEXT NOT NULL, "
                + DB_TIME + " TEXT NOT NULL);");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public YXadapter<String> initNote() {

        Cursor cursor = db.query("note", null, null, null, null, null, "time DESC", null);

        if (cursor.moveToFirst()) {

            do {

                adapter.add(cursor.getString(cursor.getColumnIndex("title")));
            } while (cursor.moveToNext());
        }
        cursor.close();

        return adapter;
    }

    public ArrayAdapter<String> searchAdd() {

        Cursor cursor = db.query("note", null, null, null, null, null, "time DESC", null);

        if (cursor.moveToFirst()) {

            do {

                array_adapter.add(cursor.getString(cursor.getColumnIndex("title")));
            } while (cursor.moveToNext());
        }
        cursor.close();

        return array_adapter;
    }

    public int getId(String str) {

        int id = 0;

        return id;
    }

    public String getContent() {

        String str = null;

        Cursor cursor = db.query("note", null, null, null, null, null, null, null);

        if (cursor.moveToFirst()) {

            do {

                if (title.equals(cursor.getString(cursor.getColumnIndex("title")))) {

                    str = cursor.getString(cursor.getColumnIndex("content"));
                }

            } while (cursor.moveToNext());
        }
        cursor.close();

        return str;
    }

    public String getTime() {

        String str = null;

        Cursor cursor = db.query("note", null, null, null, null, null, null, null);

        if (cursor.moveToFirst()) {

            do {

                if (title.equals(cursor.getString(cursor.getColumnIndex("title")))) {

                    str = cursor.getString(cursor.getColumnIndex("time"));
                }

            } while (cursor.moveToNext());
        }
        cursor.close();

        return str;
    }
}