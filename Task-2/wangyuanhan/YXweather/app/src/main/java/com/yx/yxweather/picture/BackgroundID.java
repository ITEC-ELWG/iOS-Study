package com.yx.yxweather.picture;

import com.yx.yxweather.R;

/**
 * Created by YX on 2015/12/15.
 */
public class BackgroundID {
    private String type;

    public BackgroundID(String type) {
        this.type = type;
    }

    public int getBackgroundID () {
        int id = 0;

        switch (type) {
            case "晴":
                id = R.drawable.sunny;
                break;
            case "阴":
                id = R.drawable.overcast;
                break;
            case "雾":
                id = R.drawable.foggy;
                break;
            case "多云":
                id = R.drawable.cloudy;
                break;
            case "阵雨":
                id = R.drawable.shower;
                break;
            case "小雨":
                id = R.drawable.lightrain;
                break;
            case "暴雨":
                id = R.drawable.rainstorm;
                break;
            case "小雪":
                id = R.drawable.lightsnow;
                break;
            case "雷阵雨":
                id = R.drawable.thundershower;
                break;
            default:
        }

        return id;
    }
}
