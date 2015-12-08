package com.yx.yxnote.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import com.yx.yxnote.R;
import com.yx.yxnote.adapter.YXAdapter;
import com.yx.yxnote.database.DBSender;
import com.yx.yxnote.adapter.AdapterInit;

public class MainActivity extends Activity {
    private Button buttonNew;
    private ListView listView;
    private AutoCompleteTextView autoCompleteTextView;
    private YXAdapter yxAdapter;
    private ArrayAdapter arrayAdapter;

    public static final int COMPLETE = 1;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case COMPLETE:
                    AdapterInit adapterInit = new AdapterInit(MainActivity.this, yxAdapter, arrayAdapter);
                    getAdapter(adapterInit);
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.content_main);

        buttonNew = (Button) findViewById(R.id.button_note_new);
        listView = (ListView) findViewById(R.id.note_list);
        autoCompleteTextView = (AutoCompleteTextView) findViewById(R.id.auto_note_search);

        yxAdapter = new YXAdapter(this, android.R.layout.simple_list_item_1);
        arrayAdapter = new ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line);

        AdapterInit adapterInit = new AdapterInit(this, yxAdapter, arrayAdapter, handler);
        getAdapter(adapterInit);

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

    private void getAdapter(AdapterInit adapterInit) {
        yxAdapter = adapterInit.getYxAdapter();
        listView.setAdapter(yxAdapter);
        arrayAdapter = adapterInit.getArrayAdapter();
        autoCompleteTextView.setAdapter(arrayAdapter);
    }
}