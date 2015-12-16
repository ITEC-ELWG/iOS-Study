package com.yx.yxweather.activity;

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

import com.yx.yxweather.R;
import com.yx.yxweather.adapter.AdapterInit;
import com.yx.yxweather.data.City;

public class SearchActivity extends Activity {
    private AutoCompleteTextView autoCompleteTextView;
    private Button buttonCancel;
    private ArrayAdapter adapter;

    public static final int END = 1;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case END:
                    AdapterInit adapterInit = new AdapterInit(SearchActivity.this, adapter);
                    autoCompleteTextView.setAdapter(adapterInit.getAdapter());
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_search);

        autoCompleteTextView = (AutoCompleteTextView) findViewById(R.id.auto_search);
        buttonCancel = (Button) findViewById(R.id.button_cancel);

        adapter = new ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line);
        AdapterInit adapterInit = new AdapterInit(this, adapter, handler);
        autoCompleteTextView.setAdapter(adapterInit.getAdapter());

        buttonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                autoCompleteTextView.setText("");
            }
        });
        autoCompleteTextView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent();
                setResult(RESULT_OK, new City(SearchActivity.this, adapter.getItem(position).toString(), intent).addCity());
                finish();
            }
        });
    }

}
