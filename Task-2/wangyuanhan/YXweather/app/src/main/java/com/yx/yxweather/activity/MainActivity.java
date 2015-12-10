package com.yx.yxweather.activity;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Window;
import android.widget.ListView;
import android.widget.TextView;

import com.yx.yxweather.R;
import com.yx.yxweather.adapter.YXAdapter;
import com.yx.yxweather.data.Weather;

public class MainActivity extends Activity {
    public static final String WEEKLY_WEEK = "week";
    public static final String WEEKLY_TYPE = "type";
    public static final String WEEKLY_TEMPERATURE = "temperature";

    private TextView city;
    private TextView type;
    private TextView curTemp;
    private ListView listView;
    private Weather weather;

    public static final int END = 1;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case END:
                    city.setText(weather.getCity());
                    type.setText(weather.getType());
                    curTemp.setText(weather.getCurTemp());

                    YXAdapter adapter = new YXAdapter(MainActivity.this, weather.getList());
                    listView.setAdapter(adapter);
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);

        city = (TextView) findViewById(R.id.city);
        type = (TextView) findViewById(R.id.type);
        curTemp = (TextView) findViewById(R.id.curTemp);
        listView = (ListView) findViewById(R.id.list_view);

        weather = new Weather(handler);
    }
}
