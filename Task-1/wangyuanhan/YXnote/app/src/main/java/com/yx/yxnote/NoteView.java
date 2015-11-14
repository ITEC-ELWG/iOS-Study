package com.yx.yxnote;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Mr.Lonely on 2015/11/13.
 */
public class NoteView extends Activity implements View.OnClickListener {

    private Button button_view_back;
    private Button button_view_finish;
    private Button button_view_delete;
    private Button button_view_new;

    private TextView textview_view_time;
    private EditText edittext_view_content;

    private String content = null;

    private NoteDB noteDB = new NoteDB(this, "note.db", null, 1);

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_note_view);

        button_view_back = (Button) findViewById(R.id.button_note_view_back);
        button_view_back.setOnClickListener(this);

        button_view_finish = (Button) findViewById(R.id.button_note_view_finish);
        button_view_finish.setOnClickListener(this);

        button_view_delete = (Button) findViewById(R.id.button_note_view_delete);
        button_view_delete.setOnClickListener(this);

        button_view_new = (Button) findViewById(R.id.button_note_view_new);
        button_view_new.setOnClickListener(this);

        Intent intent = getIntent();
        edittext_view_content = (EditText) findViewById(R.id.edittext_note_view_content);
        content = intent.getStringExtra("content");
        edittext_view_content.setText(content);

        textview_view_time = (TextView) findViewById(R.id.textview_note_view_time);
        textview_view_time.setText(getOldTime());
    }

    @Override
    public void onClick(View v) {

        Intent intent_main = new Intent(NoteView.this, MainActivity.class);
        Intent intent_new = new Intent(NoteView.this, NoteNew.class);

        SQLiteDatabase db = noteDB.getWritableDatabase();

        switch (v.getId()) {

            case R.id.button_note_view_back:
                finish();
                break;

            case R.id.button_note_view_finish:

                if ((edittext_view_content.getText().toString()).equals("") == false) {

                    ContentValues values = new ContentValues();

                    values.put("content", edittext_view_content.getText().toString());
                    values.put("time", getNewTime());
                    db.update("note", values, "content = ?", new String[]{content});
                } else {

                    db.delete("note", "content = ?", new String[]{content});
                    Toast.makeText(NoteView.this, "删除笔记", Toast.LENGTH_SHORT).show();
                }

                startActivity(intent_main);
                finish();
                break;

            case R.id.button_note_view_delete:
                db.delete("note", "content = ?", new String[]{content});
                Toast.makeText(NoteView.this, "删除笔记", Toast.LENGTH_SHORT).show();
                startActivity(intent_main);
                finish();
                break;

            case R.id.button_note_view_new:
                startActivity(intent_new);
                finish();
                break;

            default:break;
        }
    }

    private String getNewTime() {

        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
        Date curDate = new Date();
        String str = format.format(curDate);
        return str;
    }

    private String getOldTime() {

        String str = null;

        SQLiteDatabase db = noteDB.getWritableDatabase();
        Cursor cursor = db.query("note", null, null, null, null, null, null, null);

        if (cursor.moveToFirst()) {

            do {

                if (content.equals(cursor.getString(cursor.getColumnIndex("content")))) {

                    str = cursor.getString(cursor.getColumnIndex("time"));
                }

            } while (cursor.moveToNext());
        }
        cursor.close();

        return str;
    }
}
