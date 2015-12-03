package com.yx.yxnote.activity;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.yx.yxnote.R;
import com.yx.yxnote.database.DBOperator;
import com.yx.yxnote.database.NoteDB;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by YX on 2015/11/12.
 */
public class NoteNewActivity extends Activity implements View.OnClickListener{
    private Button buttonBack;
    private Button buttonFinsh;
    private TextView textviewTime;
    private EditText edittextTitle;
    private EditText edittextContent;
    private SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_new);

        buttonBack = (Button) findViewById(R.id.button_note_new_back);
        buttonFinsh = (Button) findViewById(R.id.button_note_new_finish);
        textviewTime = (TextView) findViewById(R.id.textview_note_new_time);
        edittextTitle = (EditText) findViewById(R.id.edittext_note_new_title);
        edittextContent = (EditText) findViewById(R.id.edittext_note_new_content);

        buttonBack.setOnClickListener(this);
        buttonFinsh.setOnClickListener(this);
        textviewTime.setText(getTime());
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button_note_new_back:
                finish();
                break;

            case R.id.button_note_new_finish:
                if (((edittextTitle.getText().toString()).equals("") == false) ||
                        ((edittextContent.getText().toString()).equals("") == false)) {
                    DBOperator dbOperator = new DBOperator(this);
                    ContentValues values = new ContentValues();
                    values.put(NoteDB.DB_NOTE_TIME, getTime());
                    values.put(NoteDB.DB_NOTE_TITLE, edittextTitle.getText().toString());
                    values.put(NoteDB.DB_NOTE_CONTENT, edittextContent.getText().toString());
                    dbOperator.DBInsert(values);
                }

                Intent intent = new Intent(this, MainActivity.class);
                startActivity(intent);
                finish();
                break;
        }
    }

    private String getTime() {
        Date curDate = new Date();
        String str = format.format(curDate);
        return str;
    }
}