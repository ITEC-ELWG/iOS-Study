package com.yx.yxweather.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.yx.yxweather.R;
import com.yx.yxweather.adapter.CityAdapter;
import com.yx.yxweather.data.City;
import com.yx.yxweather.database.CityDelete;
import com.yx.yxweather.database.CityOpen;
import com.yx.yxweather.database.CitySave;
import com.yx.yxweather.database.CityDB;

public class SaveActivity extends Activity {
    private int background;
    private LinearLayout linearLayout;
    private ListView listView;
    private Button addCity;
    private City city;
    private String cityDelete;

    public static final int END = 1;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case END:
                    CityAdapter adapter = new CityAdapter(SaveActivity.this, city.getList());
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
        setContentView(R.layout.activity_save);

        linearLayout = (LinearLayout) findViewById(R.id.background_save);
        listView = (ListView) findViewById(R.id.list_city);
        addCity = (Button) findViewById(R.id.add_city);

        city = new City(this, handler);
        background = getIntent().getExtras().getInt("background");
        linearLayout.setBackgroundResource(background);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(SaveActivity.this, MainActivity.class);
                startActivity(new CityOpen(SaveActivity.this, position, intent).openCity());
                finish();
            }
        });
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, final int position, long id) {
                cityDelete = parent.getItemAtPosition(position).toString();
                AlertDialog.Builder dialog = new AlertDialog.Builder(SaveActivity.this);
                dialog.setTitle("删除城市");
                dialog.setMessage("是否删除城市：" + cityDelete);
                dialog.setCancelable(false);
                dialog.setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        new CityDelete(SaveActivity.this).deleteCity(cityDelete);
                        city = new City(SaveActivity.this, handler);
                    }
                });
                dialog.setNegativeButton("取消", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                });
                dialog.show();
                return true;
            }
        });
        addCity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(SaveActivity.this, SearchActivity.class);
                intent.putExtra("background", background);
                startActivityForResult(intent, 1);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case 1:
                if (resultCode == RESULT_OK) {
                    new CitySave(SaveActivity.this, data.getStringExtra(CityDB.DB_SAVE_CITY), data.getStringExtra(CityDB.DB_SEARCH_CODE)).saveCity();
                    Intent intent = new Intent(SaveActivity.this, MainActivity.class);
                    intent.putExtra(CityDB.DB_SEARCH_CODE, data.getStringExtra(CityDB.DB_SEARCH_CODE));
                    startActivity(intent);
                    finish();
                }
                break;
            default:
        }
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(SaveActivity.this, MainActivity.class);
        startActivity(intent);
        finish();
    }
}
