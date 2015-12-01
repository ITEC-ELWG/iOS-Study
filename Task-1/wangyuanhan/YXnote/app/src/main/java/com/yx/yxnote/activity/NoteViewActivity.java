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
    private Button buttonBack;
    private Button buttonFinish;
    private Button buttonDelete;
    private Button buttonNew;
    private TextView textViewTime;
    private EditText editTextTitle;
    private EditText editTextContent;

    private int id = 0;
    private String title = null;
    private String content = null;
    private String time = null;

    private SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_view);

        buttonBack = (Button) findViewById(R.id.button_note_view_back);
        buttonFinish = (Button) findViewById(R.id.button_note_view_finish);
        buttonDelete = (Button) findViewById(R.id.button_note_view_delete);
        buttonNew = (Button) findViewById(R.id.button_note_view_new);
        editTextTitle = (EditText) findViewById(R.id.edittext_note_view_title);
        editTextContent = (EditText) findViewById(R.id.edittext_note_view_content);
        textViewTime = (TextView) findViewById(R.id.textview_note_view_time);

        buttonBack.setOnClickListener(this);
        buttonFinish.setOnClickListener(this);
        buttonDelete.setOnClickListener(this);
        buttonNew.setOnClickListener(this);

        Intent intent = getIntent();
        Bundle bundle = getIntent().getExtras();
        id = bundle.getInt(NoteDB.DB_COLUMN_ID);
        title = intent.getStringExtra(NoteDB.DB_NOTE_TITLE);
        content = intent.getStringExtra(NoteDB.DB_NOTE_CONTENT);
        time = intent.getStringExtra(NoteDB.DB_NOTE_TIME);

        if (title.equals("无标题")) {
            editTextTitle.setHint("请在这里输入标题");
        } else {
            editTextTitle.setText(title);
        }

        if (content.equals("无内容")) {
            editTextContent.setHint("请在这里输入内容");
        } else {
            editTextContent.setText(content);
        }

        textViewTime.setText(time);
    }

    @Override
    public void onClick(View v) {
        Intent intentMain = new Intent(NoteViewActivity.this, MainActivity.class);
        Intent intentNew = new Intent(NoteViewActivity.this, NoteNewActivity.class);

        NoteDB noteDB = new NoteDB(this);
        SQLiteDatabase db = noteDB.getWritableDatabase();

        switch (v.getId()) {
            case R.id.button_note_view_back:
                finish();
                break;

            case R.id.button_note_view_finish:
                if (((editTextTitle.getText().toString()).equals("") == false) ||
                        (editTextContent.getText().toString()).equals("") == false) {
                    ContentValues values = new ContentValues();

                    if (editTextTitle.getText().toString().equals("") == true) {
                        values.put(NoteDB.DB_NOTE_TITLE, "无标题");
                    } else {
                        values.put(NoteDB.DB_NOTE_TITLE, editTextTitle.getText().toString());
                    }

                    if (editTextContent.getText().toString().equals("") == true) {
                        values.put(NoteDB.DB_NOTE_CONTENT, "无内容");
                    } else {
                        values.put(NoteDB.DB_NOTE_CONTENT, editTextContent.getText().toString());
                    }

                    values.put(NoteDB.DB_NOTE_TIME, getTime());
                    db.update(NoteDB.DB_TABLE_NAME, values, "_id =" + id, null);
                } else {
                    db.delete(NoteDB.DB_TABLE_NAME, "_id =" + id, null);
                    Toast.makeText(NoteViewActivity.this, "删除笔记", Toast.LENGTH_SHORT).show();
                }

                startActivity(intentMain);
                finish();
                break;

            case R.id.button_note_view_delete:
                db.delete(NoteDB.DB_TABLE_NAME, "_id =" + id, null);
                Toast.makeText(NoteViewActivity.this, "删除笔记", Toast.LENGTH_SHORT).show();
                startActivity(intentMain);
                finish();
                break;

            case R.id.button_note_view_new:
                startActivity(intentNew);
                finish();
                break;

            default:break;
        }
    }

    private String getTime() {
        Date curDate = new Date();
        String str = format.format(curDate);
        return str;
    }
}
