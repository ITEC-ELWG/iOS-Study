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
import com.yx.yxnote.database.DBSender;
import com.yx.yxnote.adapter.AdapterInit;

public class MainActivity extends ListActivity {
    private Button buttonNew;
    private ListView listView;
    private AutoCompleteTextView autoCompleteTextView;
    private YXAdapter yxAdapter;
    private ArrayAdapter arrayAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.content_main);

        buttonNew = (Button) findViewById(R.id.button_note_new);
        listView = (ListView) findViewById(android.R.id.list);
        autoCompleteTextView = (AutoCompleteTextView) findViewById(R.id.auto_note_search);

        yxAdapter = new YXAdapter(this, android.R.layout.simple_list_item_1) {
            protected void initList(int position, View view, ViewGroup parent) {
                ((TextView)(view)).setText(getItem(position).toString());
            }
        };
        arrayAdapter = new ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line);

        final AdapterInit adapterInit = new AdapterInit(this, yxAdapter, arrayAdapter);

        setListAdapter(yxAdapter);
        yxAdapter = adapterInit.getYxAdapter();
        arrayAdapter = adapterInit.getArrayAdapter();
        autoCompleteTextView.setAdapter(arrayAdapter);

        final Intent intentNew = new Intent(this, NoteNewActivity.class);
        final Intent intentView = new Intent(this, NoteViewActivity.class);
        buttonNew.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Toast.makeText(MainActivity.this, "新建笔记", Toast.LENGTH_SHORT).show();
                startActivity(intentNew);
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                startActivity(new DBSender(MainActivity.this, position, intentView).sendNote());
            }
        });
        autoCompleteTextView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String str = arrayAdapter.getItem(position).toString();
                position = Integer.parseInt(str.substring(str.length() - 2, str.length() - 1)) - 1;
                startActivity(new DBSender(MainActivity.this, position, intentView).sendNote());
            }
        });
    }
}