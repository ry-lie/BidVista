package com.auction.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Auction {
    private int auctionId;
    private int itemId;
    private BigDecimal startPrice;
    private BigDecimal reservePrice;
    private Timestamp startTime;
    private Timestamp endTime;
    private BigDecimal bidIncrement;
    private String status;
    private int sellerId;
    private String sellerName;
    private Item item;
    private BigDecimal currentBid;
    private int bidCount;
    private int winnerId;
    private String winnerName;
    
    public Auction() {}
    
    public Auction(int auctionId, int itemId, BigDecimal startPrice, BigDecimal reservePrice,
                   Timestamp startTime, Timestamp endTime, BigDecimal bidIncrement, String status) {
        this.auctionId = auctionId;
        this.itemId = itemId;
        this.startPrice = startPrice;
        this.reservePrice = reservePrice;
        this.startTime = startTime;
        this.endTime = endTime;
        this.bidIncrement = bidIncrement;
        this.status = status;
    }
    
    public int getAuctionId() {
        return auctionId;
    }
    
    public void setAuctionId(int auctionId) {
        this.auctionId = auctionId;
    }
    
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public BigDecimal getStartPrice() {
        return startPrice;
    }
    
    public void setStartPrice(BigDecimal startPrice) {
        this.startPrice = startPrice;
    }
    
    public BigDecimal getReservePrice() {
        return reservePrice;
    }
    
    public void setReservePrice(BigDecimal reservePrice) {
        this.reservePrice = reservePrice;
    }
    
    public Timestamp getStartTime() {
        return startTime;
    }
    
    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }
    
    public Timestamp getEndTime() {
        return endTime;
    }
    
    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }
    
    public BigDecimal getBidIncrement() {
        return bidIncrement;
    }
    
    public void setBidIncrement(BigDecimal bidIncrement) {
        this.bidIncrement = bidIncrement;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getSellerId() {
        return sellerId;
    }
    
    public void setSellerId(int sellerId) {
        this.sellerId = sellerId;
    }
    
    public String getSellerName() {
        return sellerName;
    }
    
    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }
    
    public Item getItem() {
        return item;
    }
    
    public void setItem(Item item) {
        this.item = item;
    }
    
    public BigDecimal getCurrentBid() {
        return currentBid;
    }
    
    public void setCurrentBid(BigDecimal currentBid) {
        this.currentBid = currentBid;
    }
    
    public int getBidCount() {
        return bidCount;
    }
    
    public void setBidCount(int bidCount) {
        this.bidCount = bidCount;
    }
    
    public int getWinnerId() {
        return winnerId;
    }
    
    public void setWinnerId(int winnerId) {
        this.winnerId = winnerId;
    }
    
    public String getWinnerName() {
        return winnerName;
    }
    
    public void setWinnerName(String winnerName) {
        this.winnerName = winnerName;
    }
    
    public boolean isActive() {
        return "active".equals(status);
    }
    
    public boolean isClosed() {
        return "closed".equals(status);
    }
    
    public boolean hasReserveMet() {
        if (reservePrice == null || currentBid == null) {
            return false;
        }
        return currentBid.compareTo(reservePrice) >= 0;
    }
}
