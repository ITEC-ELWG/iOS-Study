package com.yx.yxnote.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Created by YX on 2015/11/13.
 */
public class NoteDB extends SQLiteOpenHelper{
    public static final String DB_TABLE_NAME = "note";
    public static final String DB_COLUMN_ID = "_id";
    public static final String DB_NOTE_TIME = "time";
    public static final String DB_NOTE_TITLE = "title";
    public static final String DB_NOTE_CONTENT = "content";

    public NoteDB(Context context) {
        super(context, "note.db", null, 1);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE "
            + DB_TABLE_NAME + " ("
            + DB_COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
            + DB_NOTE_TIME + " TEXT NOT NULL, "
            + DB_NOTE_TITLE + " TEXT NOT NULL, "
            + DB_NOTE_CONTENT + " TEXT NOT NULL);");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
//        Log.w("", "Upgrading from version " + oldVersion + " to " + newVersion);
//        db.execSQL("DROP TABLE IF EXISTS " + DB_TABLE_NAME);
//        onCreate(db);
    }
}