package com.yx.yxnote;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends Activity implements View.OnClickListener {

    private Button button_main;

    private NoteDB noteDB = new NoteDB(this, "note.db", null, 1);

    private List<Note> note_list = new ArrayList<Note>();

    private AutoCompleteTextView actv;
    private ArrayAdapter<String> array_adpater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.content_main);

        button_main = (Button) findViewById(R.id.button_note_new);
        button_main.setOnClickListener(this);

        initNote();
        NoteAdapter adapter = new NoteAdapter(MainActivity.this, R.layout.layout_note, note_list);
        ListView list_view = (ListView) findViewById(R.id.listview_note_exist);
        list_view.setAdapter(adapter);
        list_view.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Note note = note_list.get(position);
                Intent intent = new Intent(MainActivity.this, NoteView.class);
                intent.putExtra("title", note.getTitle());
                startActivity(intent);
            }
        });

        array_adpater = new ArrayAdapter<String>(this, android.R.layout.simple_dropdown_item_1line);

        searchAdd();

        actv = (AutoCompleteTextView) findViewById(R.id.auto_note_search);
        actv.setAdapter(array_adpater);

        actv.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                TextView search_content = (TextView) view;
                Intent intent_search = new Intent(MainActivity.this, NoteView.class);
                String str = (String) search_content.getText();
                intent_search.putExtra("title", str);
                startActivity(intent_search);
            }
        });
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {

            case R.id.button_note_new:
                Intent intent_new = new Intent(MainActivity.this, NoteNew.class);
                Toast.makeText(MainActivity.this, "新建笔记", Toast.LENGTH_SHORT).show();
                startActivity(intent_new);
                break;

            default:break;
        }
    }

    private void initNote() {

        SQLiteDatabase db = noteDB.getWritableDatabase();
        Cursor cursor = db.query("note", null, null, null, null, null, "time DESC", null);

        if (cursor.moveToFirst()) {

            do {

                Note note = new Note(cursor.getString(cursor.getColumnIndex("title")));
                note_list.add(note);
            } while (cursor.moveToNext());
        }
        cursor.close();
    }

    private void searchAdd() {

        SQLiteDatabase db = noteDB.getWritableDatabase();
        Cursor cursor = db.query("note", null, null, null, null, null, "time DESC", null);

        if (cursor.moveToFirst()) {

            do {

                array_adpater.add(cursor.getString(cursor.getColumnIndex("title")));
            } while (cursor.moveToNext());
        }
        cursor.close();
    }
}
