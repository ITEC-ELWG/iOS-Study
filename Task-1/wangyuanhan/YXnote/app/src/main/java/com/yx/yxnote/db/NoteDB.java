package com.yx.yxnote.db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.widget.ArrayAdapter;

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

    private List<Note> note_list = new ArrayList<Note>();
    private ArrayAdapter<String> array_adapter;

    private String title = null;

    public NoteDB(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {

        super(context, name, factory, version);
    }

    public NoteDB(Context context, String name, SQLiteDatabase.CursorFactory factory, int version, List<Note> note_list) {

        super(context, name, factory, version);
        this.note_list = note_list;
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

    public List<Note> initNote() {

        Cursor cursor = db.query("note", null, null, null, null, null, "time DESC", null);

        if (cursor.moveToFirst()) {

            do {

                Note note = new Note(cursor.getString(cursor.getColumnIndex("title")));
                note_list.add(note);
            } while (cursor.moveToNext());
        }
        cursor.close();

        return note_list;
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
