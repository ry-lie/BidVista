package com.auction.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Alert {
    private int alertId;
    private int userId;
    private Integer subcategoryId;
    private String keywords;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private Timestamp createdAt;
    private String subcategoryName;
    
    public Alert() {}
    
    public Alert(int alertId, int userId, Integer subcategoryId, String keywords, 
                 BigDecimal minPrice, BigDecimal maxPrice, Timestamp createdAt) {
        this.alertId = alertId;
        this.userId = userId;
        this.subcategoryId = subcategoryId;
        this.keywords = keywords;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.createdAt = createdAt;
    }
    
    public int getAlertId() {
        return alertId;
    }
    
    public void setAlertId(int alertId) {
        this.alertId = alertId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Integer getSubcategoryId() {
        return subcategoryId;
    }
    
    public void setSubcategoryId(Integer subcategoryId) {
        this.subcategoryId = subcategoryId;
    }
    
    public String getKeywords() {
        return keywords;
    }
    
    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }
    
    public BigDecimal getMinPrice() {
        return minPrice;
    }
    
    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }
    
    public BigDecimal getMaxPrice() {
        return maxPrice;
    }
    
    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getSubcategoryName() {
        return subcategoryName;
    }
    
    public void setSubcategoryName(String subcategoryName) {
        this.subcategoryName = subcategoryName;
    }
}
