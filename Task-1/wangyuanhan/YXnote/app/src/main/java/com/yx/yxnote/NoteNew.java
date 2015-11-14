package com.yx.yxnote;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Mr.Lonely on 2015/11/12.
 */
public class NoteNew extends Activity implements View.OnClickListener{

    private Button button_new_back;
    private Button button_new_finsh;

    private TextView textview_new_time;
    private EditText edittext_new_content;

    private NoteDB noteDB;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_note_new);

        button_new_back = (Button) findViewById(R.id.button_note_new_back);
        button_new_back.setOnClickListener(this);

        button_new_finsh = (Button) findViewById(R.id.button_note_new_finish);
        button_new_finsh.setOnClickListener(this);

        textview_new_time = (TextView) findViewById(R.id.textview_note_new_time);
        textview_new_time.setText(getTime());

        edittext_new_content = (EditText) findViewById(R.id.edittext_note_new_content);

        noteDB = new NoteDB(this, "note.db", null, 1);
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {

            case R.id.button_note_new_back:
                finish();
                break;

            case R.id.button_note_new_finish:
                if ((edittext_new_content.getText().toString()).equals("") == false) {

                    SQLiteDatabase db = noteDB.getWritableDatabase();
                    ContentValues values = new ContentValues();

                    values.put("content", edittext_new_content.getText().toString());
                    values.put("time", getTime());
                    db.insert("note", null, values);
                }

                Intent intent = new Intent(NoteNew.this, MainActivity.class);
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
