package com.yx.yxweather.activity;

import android.app.Activity;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.yx.yxweather.R;
import com.yx.yxweather.adapter.WeatherAdapter;
import com.yx.yxweather.data.Weather;
import com.yx.yxweather.database.CityDB;

public class MainActivity extends Activity {
    public static final String WEATHER_WEEK = "week";
    public static final String WEATHER_TYPE = "type";
    public static final String WEATHER_TEMPERATURE = "temperature";

    private LinearLayout linearLayout;
    private TextView textCity;
    private TextView textType;
    private TextView textTurTemp;
    private ListView listView;
    private Weather weather;

    public static final int END = 1;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case END:
                    linearLayout.setBackgroundResource(weather.getBackground());
                    textCity.setText(weather.getCity());
                    textType.setText(weather.getType());
                    System.out.println(weather.getType());
                    textTurTemp.setText(weather.getCurTemp());

                    WeatherAdapter adapter = new WeatherAdapter(MainActivity.this, weather.getList());
                    listView.setAdapter(adapter);
                    break;
                default:
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);

        linearLayout = (LinearLayout) findViewById(R.id.bg);
        textCity = (TextView) findViewById(R.id.text_city);
        textType = (TextView) findViewById(R.id.text_type);
        textTurTemp = (TextView) findViewById(R.id.text_curTemp);
        listView = (ListView) findViewById(R.id.list_weather);

        weather = new Weather(handler, getCityID());
        SQLiteDatabase db = new CityDB(this).getWritableDatabase();

        textCity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, SaveActivity.class);
                startActivityForResult(intent, 1);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case 1:
                if (resultCode == RESULT_OK) {
                    weather = new Weather(handler, data.getStringExtra(CityDB.DB_SEARCH_CODE));
                }
                break;
            default:
        }
    }

    private String getCityID() {
        String str = "101010100";
        Intent intent = getIntent();
        if (intent.getStringExtra(CityDB.DB_SAVE_CODE) != null) {
            str = intent.getStringExtra(CityDB.DB_SAVE_CODE);
        }
        return str;
    }
}