package com.yx.yxnote.activity;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.yx.yxnote.R;
import com.yx.yxnote.adapter.YXAdapter;
import com.yx.yxnote.database.NoteSender;
import com.yx.yxnote.database.NoteAdapter;

public class MainActivity extends ListActivity {
    private Button buttonNew;
    private AutoCompleteTextView autoCompleteTextView;
    private ListView listView;
    private YXAdapter yxAdapter;
    private ArrayAdapter arrayAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.content_main);

        buttonNew = (Button) findViewById(R.id.button_note_new);
        autoCompleteTextView = (AutoCompleteTextView) findViewById(R.id.auto_note_search);
        listView = (ListView) findViewById(android.R.id.list);

        arrayAdapter = new ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line);
        arrayAdapter = new NoteAdapter(this, arrayAdapter).getArrayAdapter();
        autoCompleteTextView.setAdapter(arrayAdapter);

        yxAdapter = new YXAdapter(this, android.R.layout.simple_list_item_1) {
            @Override
            protected void initList(int position, View view, ViewGroup parent) {
                ((TextView)(view)).setText(getItem(position).toString());
            }
        };
        setListAdapter(yxAdapter);
        yxAdapter = new NoteAdapter(this, yxAdapter).getYxAdapter();

        buttonNew.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, NoteNewActivity.class);
                Toast.makeText(MainActivity.this, "新建笔记", Toast.LENGTH_SHORT).show();
                startActivity(intent);
            }
        });
        autoCompleteTextView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new NoteSender(MainActivity.this, position).sendNote();
                startActivity(intent);
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new NoteSender(MainActivity.this, position).sendNote();
                startActivity(intent);
            }
        });
    }
}