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

import com.yx.yxnote.R;
import com.yx.yxnote.database.NoteDB;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by YX on 2015/11/12.
 */
public class NoteNewActivity extends Activity implements View.OnClickListener{
    private Button button_new_back;
    private Button button_new_finsh;
    private TextView textview_new_time;
    private EditText edittext_new_title;
    private EditText edittext_new_content;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_new);

        button_new_back = (Button) findViewById(R.id.button_note_new_back);
        button_new_finsh = (Button) findViewById(R.id.button_note_new_finish);
        textview_new_time = (TextView) findViewById(R.id.textview_note_new_time);
        edittext_new_title = (EditText) findViewById(R.id.edittext_note_new_title);
        edittext_new_content = (EditText) findViewById(R.id.edittext_note_new_content);

        button_new_back.setOnClickListener(this);
        button_new_finsh.setOnClickListener(this);
        textview_new_time.setText(getTime());
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button_note_new_back:
                finish();
                break;

            case R.id.button_note_new_finish:
                if (((edittext_new_title.getText().toString()).equals("") == false) ||
                        ((edittext_new_content.getText().toString()).equals("") == false)) {
                    SQLiteDatabase db = new NoteDB(this, "note.db", null, 1).getWritableDatabase();
                    ContentValues values = new ContentValues();

                    if (edittext_new_title.getText().toString().equals("") == true) {
                        values.put("title", "无标题");
                    } else {
                        values.put("title", edittext_new_title.getText().toString());
                    }

                    if (edittext_new_content.getText().toString().equals("") == true) {
                        values.put("content", "无内容");
                    } else {
                        values.put("content", edittext_new_content.getText().toString());
                    }

                    values.put("time", getTime());
                    db.insert("note", null, values);
                }

                Intent intent = new Intent(NoteNewActivity.this, MainActivity.class);
                startActivity(intent);
                finish();
                break;
        }
    }

    private String getTime() {
        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
        Date curDate = new Date();
        String str = format.format(curDate);
        return str;
    }
}