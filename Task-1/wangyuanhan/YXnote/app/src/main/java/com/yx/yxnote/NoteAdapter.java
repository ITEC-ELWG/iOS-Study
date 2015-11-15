package com.yx.yxnote;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

/**
 * Created by Mr.Lonely on 2015/11/13.
 */
public class NoteAdapter extends ArrayAdapter<Note> {

    private int resourceID;

    public NoteAdapter(Context context, int textViewResourceId, List<Note> objects) {

        super(context, textViewResourceId, objects);
        resourceID = textViewResourceId;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        Note note = getItem(position);
        View view;
        ViewHolder view_holder;

        if (convertView == null) {

            view = LayoutInflater.from(getContext()).inflate(resourceID, null);
            view_holder = new ViewHolder();
            view_holder.note_title = (TextView) view.findViewById(R.id.textview_note_title);
            view.setTag(view_holder);
        } else {

            view = convertView;
            view_holder = (ViewHolder) view.getTag();
        }

        view_holder.note_title.setText(note.getTitle());
        return view;
    }

    class ViewHolder {

        TextView note_title;
    }
}
