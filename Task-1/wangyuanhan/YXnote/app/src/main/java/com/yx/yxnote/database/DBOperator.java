package com.yx.yxnote.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

/**
 * Created by YX on 2015/12/1.
 */
public class DBOperator {
    private Context context;
    SQLiteDatabase db;

    public DBOperator(Context context) {
        this.context = context;
        init();
    }

    private void init() {
        db = new NoteDB(context).getWritableDatabase();
    }

    public void DBInsert(ContentValues values) {
        db.insert("note", null, values);
    }

    public void DBUpdate(ContentValues values, int id) {
        db.update(NoteDB.DB_TABLE_NAME, values, "_id =" + id, null);
    }

    public void DBDelete(int id) {
        db.delete(NoteDB.DB_TABLE_NAME, "_id =" + id, null);
        Toast.makeText(context, "删除笔记", Toast.LENGTH_SHORT).show();
    }
}
