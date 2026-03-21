package com.auction.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Bid {
    private int bidId;
    private int auctionId;
    private int userId;
    private BigDecimal amount;
    private Timestamp bidTime;
    private String userName;
    
    public Bid() {}
    
    public Bid(int bidId, int auctionId, int userId, BigDecimal amount, Timestamp bidTime) {
        this.bidId = bidId;
        this.auctionId = auctionId;
        this.userId = userId;
        this.amount = amount;
        this.bidTime = bidTime;
    }
    
    public int getBidId() {
        return bidId;
    }
    
    public void setBidId(int bidId) {
        this.bidId = bidId;
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
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public Timestamp getBidTime() {
        return bidTime;
    }
    
    public void setBidTime(Timestamp bidTime) {
        this.bidTime = bidTime;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
