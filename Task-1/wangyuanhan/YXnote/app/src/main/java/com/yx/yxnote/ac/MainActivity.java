package com.yx.yxnote.ac;

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
import com.yx.yxnote.ad.YXadapter;
import com.yx.yxnote.db.NoteDB;

public class MainActivity extends ListActivity implements View.OnClickListener {

    private Button button_main;
    private AutoCompleteTextView actv;
    private YXadapter<String> adapter;
    private ArrayAdapter<String> array_adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.content_main);

        button_main = (Button) findViewById(R.id.button_note_new);
        button_main.setOnClickListener(this);

        array_adapter = new ArrayAdapter<String>(this, android.R.layout.simple_dropdown_item_1line);
        array_adapter = new NoteDB(this, "note.db", null, 1, array_adapter).searchAdd();

        actv = (AutoCompleteTextView) findViewById(R.id.auto_note_search);
        actv.setAdapter(array_adapter);
        actv.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            TextView search_content = (TextView) view;
            Intent intent_search = new Intent(MainActivity.this, NoteViewActivity.class);
            String str = (String) search_content.getText();
            intent_search.putExtra("title", str);
            startActivity(intent_search);
            }
        });

        adapter = new YXadapter<String>(this, android.R.layout.simple_list_item_1) {
            @Override
            protected void initList(int position, View view, ViewGroup parent) {

                ((TextView)(view)).setText(getItem(position).toString());
            }
        };

        setListAdapter(adapter);
        adapter = new NoteDB(this, "note.db", null, 1, adapter).initNote();


        ListView list_view = (ListView) findViewById(android.R.id.list);
        list_view.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Intent intent = new Intent(MainActivity.this, NoteViewActivity.class);
                intent.putExtra("title", adapter.getItem(position));
                startActivity(intent);
            }
        });
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {

            case R.id.button_note_new:
                Intent intent_new = new Intent(MainActivity.this, NoteNewActivity.class);
                Toast.makeText(MainActivity.this, "新建笔记", Toast.LENGTH_SHORT).show();
                startActivity(intent_new);
                break;

            default:break;
        }
    }
}