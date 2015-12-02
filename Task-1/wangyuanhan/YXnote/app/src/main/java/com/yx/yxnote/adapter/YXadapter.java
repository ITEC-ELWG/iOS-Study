package com.yx.yxnote.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by YX on 2015/11/19.
 */
public abstract class YXAdapter extends BaseAdapter {
    private int resID = 0;
    private Context context;
    private List<String> list = new ArrayList();

    protected abstract void initList(int position, View convertView, ViewGroup parent);

    public YXAdapter(Context context, int resID) {
        this.context = context;
        this.resID = resID;
    }

    public Context getContext() {
        return context;
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
            view = LayoutInflater.from(getContext()).inflate(resID, null);
        } else {
            view = convertView;
        }

        initList(position, view, parent);
        return view;
    }

    public void add(String item) {
        list.add(item);
    }
}