package com.yx.yxnote.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by YX on 2015/11/19.
 */
public class YXAdapter extends BaseAdapter {
    private int resID = 0;
    private Context context;
    private List<String> list = new ArrayList();

    public YXAdapter(Context context, int resID) {
        this.context = context;
        this.resID = resID;
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

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view;

        if (convertView == null) {
            view = LayoutInflater.from(context).inflate(resID, null);
        } else {
            view = convertView;
        }

        ((TextView)(view)).setText(getItem(position).toString());
        return view;
    }

    public void add(String item) {
        list.add(item);
    }
}