package com.yx.yxweather.model;

/**
 * Created by YX on 2015/11/28.
 */
public class City {
    private int id;
    private int province_id;
    private String city_name;
    private String city_code;

    public void setId(int id) {
        this.id = id;
    }

    public void setProvinceId(int province_id) {
        this.province_id = province_id;
    }

    public void setCityName(String city_name) {
        this.city_name = city_name;
    }

    public void setCityCode(String city_code) {
        this.city_code = city_code;
    }

    public int getId() {
        return id;
    }

    public int getProvinceId() {
        return province_id;
    }

    public String getCityName() {
        return city_name;
    }

    public String getCityCode() {
        return city_code;
    }
}
