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
import com.yx.yxnote.adapter.YXadapter;
import com.yx.yxnote.database.NoteDB;

public class MainActivity extends ListActivity {
    private Button btn;
    private AutoCompleteTextView actv;
    private ListView lv;
    private YXadapter<String> adapter;
    private ArrayAdapter<String> array_adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.content_main);

        btn = (Button) findViewById(R.id.button_note_new);
        actv = (AutoCompleteTextView) findViewById(R.id.auto_note_search);
        lv = (ListView) findViewById(android.R.id.list);


        array_adapter = new ArrayAdapter<String>(this, android.R.layout.simple_dropdown_item_1line);
        array_adapter = new NoteDB(this, "note.db", null, 1, array_adapter).searchNote();
        actv.setAdapter(array_adapter);

        adapter = new YXadapter<String>(this, android.R.layout.simple_list_item_1) {
            @Override
            protected void initList(int position, View view, ViewGroup parent) {
                ((TextView)(view)).setText(getItem(position).toString());
            }
        };
        setListAdapter(adapter);
        adapter = new NoteDB(this, "note.db", null, 1, adapter).initNote();


        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent_new = new Intent(MainActivity.this, NoteNewActivity.class);
                Toast.makeText(MainActivity.this, "新建笔记", Toast.LENGTH_SHORT).show();
                startActivity(intent_new);
            }
        });
        actv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                TextView search_content = (TextView) view;
                Intent intent_search = new Intent(MainActivity.this, NoteViewActivity.class);
                String str = (String) search_content.getText();
                intent_search.putExtra("title", str);
                startActivity(intent_search);
            }
        });
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(MainActivity.this, NoteViewActivity.class);
                intent.putExtra("title", adapter.getItem(position));
                startActivity(intent);
            }
        });
    }
}