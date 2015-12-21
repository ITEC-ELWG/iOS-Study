package com.yx.yxweather.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.yx.yxweather.R;
import com.yx.yxweather.adapter.WeatherAdapter;
import com.yx.yxweather.data.Weather;
import com.yx.yxweather.database.CityDB;
import com.yx.yxweather.data.Home;
import com.yx.yxweather.service.YXService;

public class MainActivity extends Activity {
    public static final String WEATHER_WEEK = "week";
    public static final String WEATHER_TYPE = "type";
    public static final String WEATHER_TEMPERATURE = "temperature";

    private int background;
    private String code = null;

    private LinearLayout linearLayout;
    private TextView textCity;
    private TextView textType;
    private TextView textTurTemp;
    private ListView listView;
    private SwipeRefreshLayout swipe;
    private Home home;
    private Weather weather;

    public static final int END = 1;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case END:
                    if (weather.getBackground() != 0) {
                        background = weather.getBackground();
                        linearLayout.setBackgroundResource(background);

                        textCity.setText(weather.getCity());
                        textType.setText(weather.getType());
                        textTurTemp.setText(weather.getCurTemp());

                        WeatherAdapter adapter = new WeatherAdapter(MainActivity.this, weather.getList());
                        listView.setAdapter(adapter);
                        listView.setSelection(2);
                    } else {
                        Toast.makeText(MainActivity.this, "网络错误", Toast.LENGTH_SHORT).show();
                    }

                    swipe.setRefreshing(false);
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

        new CityDB(this).getReadableDatabase();

        linearLayout = (LinearLayout) findViewById(R.id.background_main);
        textCity = (TextView) findViewById(R.id.text_city);
        textType = (TextView) findViewById(R.id.text_type);
        textTurTemp = (TextView) findViewById(R.id.text_curTemp);
        listView = (ListView) findViewById(R.id.list_weather);
        swipe = (SwipeRefreshLayout) findViewById(R.id.swipe);

        home = new Home(this);
        weather = new Weather(handler, getCode());
        background = home.loadHomeBackground();
        linearLayout.setBackgroundResource(background);

        textCity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, SaveActivity.class);
                intent.putExtra("background", background);
                startActivity(intent);
                finish();
            }
        });
        swipe.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                weather = new Weather(handler, getCode());
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        weather = new Weather(handler, getCode());
        Intent intent = new Intent(this, YXService.class);
        stopService(intent);
    }

    @Override
    protected void onStop() {
        super.onStop();
        Intent intent = new Intent(this, YXService.class);
        intent.putExtra("city", weather.getCity());
        intent.putExtra("type", weather.getType());
        intent.putExtra("curTemp", weather.getCurTemp());
        startService(intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        new Home(this).saveHome(background, getCode());

        Intent intent = new Intent(this, YXService.class);
        stopService(intent);
    }

    private String getCode() {
        Intent intent = getIntent();
        String saveCode = intent.getStringExtra(CityDB.DB_SAVE_CODE);
        String searchCode = intent.getStringExtra(CityDB.DB_SEARCH_CODE);

        if (code != null) {
            return code;
        } else if (saveCode != null) {
            return saveCode;
        } else if (searchCode != null) {
            return searchCode;
        } else {
            return home.loadHomeCode();
        }
    }
}
