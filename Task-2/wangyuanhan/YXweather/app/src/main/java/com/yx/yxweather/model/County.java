package com.yx.yxweather.model;

/**
 * Created by YX on 2015/11/28.
 */
public class County {
    private int id;
    private int city_id;
    private String county_name;
    private String county_code;

    public void setId(int id) {
        this.id = id;
    }

    public void setCityId(int city_id) {
        this.city_id = city_id;
    }

    public void setCountyName(String county_name) {
        this.county_name = county_name;
    }

    public void setCountyCode(String county_code) {
        this.county_code = county_code;
    }

    public int getId() {
        return id;
    }

    public int getCityId() {
        return city_id;
    }

    public String getCountyName() {
        return county_name;
    }

    public String getCountyCode() {
        return county_code;
    }
}
