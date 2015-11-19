package com.yx.yxnote.ad;

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
public abstract class YXadapter<X> extends BaseAdapter {

    private Context context;
    private int resID = 0;

    private List<X> list = new ArrayList<X>();

    protected abstract void initList(int position, View convertView, ViewGroup parent);

    public YXadapter(Context context, int resID) {

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
    public X getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {

            convertView = LayoutInflater.from(getContext()).inflate(resID, null);
        }

        initList(position, convertView, parent);

        return convertView;
    }

    public void add(X item) {

        list.add(item);
    }
}
