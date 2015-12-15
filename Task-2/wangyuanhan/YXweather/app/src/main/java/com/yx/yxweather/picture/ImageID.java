package com.yx.yxweather.picture;

import com.yx.yxweather.R;

/**
 * Created by YX on 2015/12/14.
 */
public class ImageID {
    private String type;

    public ImageID(String type) {
        this.type = type;
    }

    public int getImageID() {
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
            case "雾":
                id = R.drawable.foggy_small;
                break;
            case "多云":
                id = R.drawable.cloudy_small;
                break;
            case "阵雪":
                id = R.drawable.lightsnow_small;
                break;
            default:
        }

        return id;
    }
}
