package com.yx.yxweather.adapter;

import android.app.Activity;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.yx.yxweather.R;
import com.yx.yxweather.activity.MainActivity;
import com.yx.yxweather.picture.ImageID;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by YX on 2015/11/19.
 */
public class WeatherAdapter extends BaseAdapter {
    private Activity activity;
    private ArrayList<HashMap<String, String>> list;

    public WeatherAdapter(Activity activity, ArrayList<HashMap<String, String>> list) {
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
        TextView textWeatherWeek;
        ImageView imageWeatherType;
        TextView textWeatherTemperature;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        LayoutInflater inflater = activity.getLayoutInflater();

        if (convertView == null) {
            convertView = inflater.inflate(R.layout.weather_list, null);
            holder = new ViewHolder();
            holder.textWeatherWeek = (TextView) convertView.findViewById(R.id.text_weather_week);
            holder.imageWeatherType = (ImageView) convertView.findViewById(R.id.image_weather_type);
            holder.textWeatherTemperature = (TextView) convertView.findViewById(R.id.text_weather_temperature);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        HashMap<String, String> map = list.get(position);
        holder.textWeatherWeek.setText(map.get(MainActivity.WEATHER_WEEK));
        holder.imageWeatherType.setImageResource(new ImageID(map.get(MainActivity.WEATHER_TYPE)).getImageID());
        holder.textWeatherTemperature.setText(map.get(MainActivity.WEATHER_TEMPERATURE));

        if (position == 2) {
            holder.textWeatherWeek.setTextColor(Color.rgb(51, 102, 204));
        }

        return convertView;
    }
}