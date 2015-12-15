package com.yx.yxweather.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.yx.yxweather.R;
import com.yx.yxweather.activity.SaveActivity;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by YX on 2015/12/10.
 */
public class CityAdapter extends BaseAdapter {
    private Activity activity;
    private ArrayList<String> list;

    public CityAdapter(Activity activity, ArrayList<String> list) {
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
        TextView textCity;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        LayoutInflater inflater = activity.getLayoutInflater();

        if (convertView == null) {
            convertView = inflater.inflate(R.layout.city_list, null);
            holder = new ViewHolder();
            holder.textCity = (TextView) convertView.findViewById(R.id.text_save_city);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.textCity.setText(list.get(position));

        return convertView;
    }
}
