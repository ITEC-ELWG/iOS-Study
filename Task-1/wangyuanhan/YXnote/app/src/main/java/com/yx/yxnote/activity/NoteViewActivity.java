package com.yx.yxnote.activity;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.yx.yxnote.R;
import com.yx.yxnote.database.NoteDB;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by YX on 2015/11/13.
 */
public class NoteViewActivity extends Activity implements View.OnClickListener {
    private Button button_view_back;
    private Button button_view_finish;
    private Button button_view_delete;
    private Button button_view_new;
    private TextView textview_view_time;
    private EditText edittext_view_title;
    private EditText edittext_view_content;
    private String title = null;
    private String content = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_view);

        button_view_back = (Button) findViewById(R.id.button_note_view_back);
        button_view_finish = (Button) findViewById(R.id.button_note_view_finish);
        button_view_delete = (Button) findViewById(R.id.button_note_view_delete);
        button_view_new = (Button) findViewById(R.id.button_note_view_new);
        edittext_view_title = (EditText) findViewById(R.id.edittext_note_view_title);
        textview_view_time = (TextView) findViewById(R.id.textview_note_view_time);

        button_view_back.setOnClickListener(this);
        button_view_finish.setOnClickListener(this);
        button_view_delete.setOnClickListener(this);
        button_view_new.setOnClickListener(this);

        Intent intent = getIntent();
        title = intent.getStringExtra("title");

        if (title.equals("无标题")) {
            edittext_view_title.setHint("请在这里输入标题");
        } else {
            edittext_view_title.setText(title);
        }

        content = new NoteDB(this, "note.db", null, 1, title).getContent();
        edittext_view_content = (EditText) findViewById(R.id.edittext_note_view_content);
        if (content.equals("无内容")) {
            edittext_view_content.setHint("请在这里输入内容");
        } else {
            edittext_view_content.setText(content);
        }

        textview_view_time.setText(new NoteDB(this, "note.db", null, 1, title).getTime());
    }

    @Override
    public void onClick(View v) {
        Intent intent_main = new Intent(NoteViewActivity.this, MainActivity.class);
        Intent intent_new = new Intent(NoteViewActivity.this, NoteNewActivity.class);

        NoteDB noteDB = new NoteDB(this, "note.db", null, 1);
        SQLiteDatabase db = noteDB.getWritableDatabase();

        switch (v.getId()) {
            case R.id.button_note_view_back:
                finish();
                break;

            case R.id.button_note_view_finish:
                if (((edittext_view_title.getText().toString()).equals("") == false) ||
                        (edittext_view_content.getText().toString()).equals("") == false) {
                    ContentValues values = new ContentValues();

                    if (edittext_view_title.getText().toString().equals("") == true) {
                        values.put("title", "无标题");
                    } else {
                        values.put("title", edittext_view_title.getText().toString());
                    }

                    if (edittext_view_content.getText().toString().equals("") == true) {
                        values.put("content", "无内容");
                    } else {
                        values.put("content", edittext_view_content.getText().toString());
                    }

                    values.put("time", getTime());
                    db.update("note", values, "title = ?", new String[]{title});
                } else {
                    db.delete("note", "title = ?", new String[]{title});
                    Toast.makeText(NoteViewActivity.this, "删除笔记", Toast.LENGTH_SHORT).show();
                }

                startActivity(intent_main);
                finish();
                break;

            case R.id.button_note_view_delete:
                db.delete("note", "title = ?", new String[]{title});
                Toast.makeText(NoteViewActivity.this, "删除笔记", Toast.LENGTH_SHORT).show();
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

    private String getTime() {
        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
        Date curDate = new Date();
        String str = format.format(curDate);
        return str;
    }
}
