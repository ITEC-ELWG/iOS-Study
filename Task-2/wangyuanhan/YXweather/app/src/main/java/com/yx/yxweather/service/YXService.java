package com.yx.yxweather.service;

import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.v4.app.NotificationCompat;

import com.yx.yxweather.R;
import com.yx.yxweather.activity.MainActivity;

/**
 * Created by YX on 2015/12/21.
 */
public class YXService extends Service {
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Intent mainIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, mainIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.weather)
                .setTicker("YXWeather")
                .setContentTitle(intent.getStringExtra("city") + "（" + intent.getStringExtra("type") + "）")
                .setContentText("当前气温：" + intent.getStringExtra("curTemp"))
                .setContentIntent(pendingIntent);
        startForeground(1, builder.build());

        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }
}
