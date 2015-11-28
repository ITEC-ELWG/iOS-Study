package com.yx.yxweather.model;

/**
 * Created by YX on 2015/11/28.
 */
public class Province {
    private int id;
    private String province_name;
    private String province_code;

    public void setId(int id) {
        this.id = id;
    }

    public void setProvince_name(String province_name) {
        this.province_name = province_name;
    }

    public void setProvince_code(String province_code) {
        this.province_code = province_code;
    }

    public int getId() {
        return id;
    }

    public String getProvince_name() {
        return province_name;
    }

    public String getProvince_code() {
        return province_code;
    }
}
