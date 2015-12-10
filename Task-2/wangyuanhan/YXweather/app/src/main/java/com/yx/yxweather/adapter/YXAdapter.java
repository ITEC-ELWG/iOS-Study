package com.yx.yxweather.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.yx.yxweather.R;
import com.yx.yxweather.activity.MainActivity;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by YX on 2015/11/19.
 */
public class YXAdapter extends BaseAdapter {
    private Activity activity;
    private ArrayList<HashMap<String, String>> list;

    public YXAdapter(Activity activity, ArrayList<HashMap<String, String>> list) {
        super();
        this.activity = activity;
        this.list = list;
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    private class ViewHolder {
        TextView textWeek;
        ImageView imageWeather;
        TextView textTemperature;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        LayoutInflater inflater = activity.getLayoutInflater();

        if (convertView == null) {
            convertView = inflater.inflate(R.layout.weekly_weather, null);
            holder = new ViewHolder();
            holder.textWeek = (TextView) convertView.findViewById(R.id.text_week);
            holder.imageWeather = (ImageView) convertView.findViewById(R.id.image_weather);
            holder.textTemperature = (TextView) convertView.findViewById(R.id.text_temperature);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        HashMap<String, String> map = list.get(position);
        holder.textWeek.setText(map.get(MainActivity.WEEKLY_WEEK));
        holder.imageWeather.setImageResource(getImageID(map.get(MainActivity.WEEKLY_TYPE)));
        holder.textTemperature.setText(map.get(MainActivity.WEEKLY_TEMPERATURE));

        return convertView;
    }

    private int getImageID(String type) {
        int id = 0;

        switch (type) {
            case "晴":
                id = R.drawable.sunny_small;
                break;
            case "阴":
                id = R.drawable.overcast_small;
                break;
            case "霾":
                id = R.drawable.haze_small;
                break;
            default:break;
        }

        return id;
    }
}