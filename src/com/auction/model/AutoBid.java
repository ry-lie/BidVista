package com.auction.model;

import java.math.BigDecimal;

public class AutoBid {
    private int auctionId;
    private int userId;
    private BigDecimal maxAmount;
    private String userName;
    
    public AutoBid() {}
    
    public AutoBid(int auctionId, int userId, BigDecimal maxAmount) {
        this.auctionId = auctionId;
        this.userId = userId;
        this.maxAmount = maxAmount;
    }
    
    public int getAuctionId() {
        return auctionId;
    }
    
    public void setAuctionId(int auctionId) {
        this.auctionId = auctionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public BigDecimal getMaxAmount() {
        return maxAmount;
    }
    
    public void setMaxAmount(BigDecimal maxAmount) {
        this.maxAmount = maxAmount;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
