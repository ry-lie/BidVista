package com.auction.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.auction.model.Bid;
import com.auction.model.AutoBid;
import com.auction.util.DatabaseConnection;

public class BidDAO {
    
    public boolean placeBid(int auctionId, int userId, BigDecimal amount) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);
            
            String checkQuery = "SELECT COALESCE(MAX(b.amount), a.start_price) as current_bid, " +
                              "a.bid_increment FROM Auction a " +
                              "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                              "WHERE a.auction_id = ? AND a.status = 'active' AND a.end_time > NOW() " +
                              "GROUP BY a.auction_id";
            pstmt = conn.prepareStatement(checkQuery);
            pstmt.setInt(1, auctionId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal currentBid = rs.getBigDecimal("current_bid");
                BigDecimal bidIncrement = rs.getBigDecimal("bid_increment");
                BigDecimal minBid = currentBid.add(bidIncrement);
                
                if (amount.compareTo(minBid) < 0) {
                    conn.rollback();
                    return false;
                }
            } else {
                conn.rollback();
                return false;
            }
            rs.close();
            pstmt.close();
            
            String insertQuery = "INSERT INTO Bid (auction_id, user_id, amount, bid_time) VALUES (?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, auctionId);
            pstmt.setInt(2, userId);
            pstmt.setBigDecimal(3, amount);
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int bidId = rs.getInt(1);
                    
                    String placesQuery = "INSERT INTO places (user_id, bid_id) VALUES (?, ?)";
                    PreparedStatement placesPstmt = conn.prepareStatement(placesQuery);
                    placesPstmt.setInt(1, userId);
                    placesPstmt.setInt(2, bidId);
                    placesPstmt.executeUpdate();
                    placesPstmt.close();
                    
                    String includesQuery = "INSERT INTO includes (auction_id, bid_id) VALUES (?, ?)";
                    PreparedStatement includesPstmt = conn.prepareStatement(includesQuery);
                    includesPstmt.setInt(1, auctionId);
                    includesPstmt.setInt(2, bidId);
                    includesPstmt.executeUpdate();
                    includesPstmt.close();
                }
            }
            
            conn.commit();
            return rows > 0;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean setAutoBid(int auctionId, int userId, BigDecimal maxAmount) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            String deleteQuery = "DELETE FROM AutoBid WHERE auction_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setInt(1, auctionId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
            pstmt.close();
            
            String insertQuery = "INSERT INTO AutoBid (auction_id, user_id, max_amount) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setInt(1, auctionId);
            pstmt.setInt(2, userId);
            pstmt.setBigDecimal(3, maxAmount);
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                String setsQuery = "INSERT INTO sets (user_id, auction_id) VALUES (?, ?) " +
                                  "ON DUPLICATE KEY UPDATE user_id = user_id";
                PreparedStatement setsPstmt = conn.prepareStatement(setsQuery);
                setsPstmt.setInt(1, userId);
                setsPstmt.setInt(2, auctionId);
                setsPstmt.executeUpdate();
                setsPstmt.close();
            }
            
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean processAutoBids(int auctionId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            String query = "SELECT ab.user_id, ab.max_amount, a.bid_increment, " +
                          "COALESCE(MAX(b.amount), a.start_price) as current_bid " +
                          "FROM AutoBid ab " +
                          "JOIN Auction a ON ab.auction_id = a.auction_id " +
                          "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE ab.auction_id = ? " +
                          "GROUP BY ab.user_id " +
                          "ORDER BY ab.max_amount DESC";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                BigDecimal maxAmount = rs.getBigDecimal("max_amount");
                BigDecimal bidIncrement = rs.getBigDecimal("bid_increment");
                BigDecimal currentBid = rs.getBigDecimal("current_bid");
                BigDecimal newBid = currentBid.add(bidIncrement);
                
                if (newBid.compareTo(maxAmount) <= 0) {
                    return placeBid(auctionId, userId, newBid);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    public List<Bid> getBidHistory(int auctionId) {
        List<Bid> bids = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT b.bid_id, b.auction_id, b.user_id, b.amount, b.bid_time, u.name " +
                          "FROM Bid b " +
                          "JOIN User u ON b.user_id = u.user_id " +
                          "WHERE b.auction_id = ? " +
                          "ORDER BY b.bid_time DESC";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Bid bid = new Bid();
                bid.setBidId(rs.getInt("bid_id"));
                bid.setAuctionId(rs.getInt("auction_id"));
                bid.setUserId(rs.getInt("user_id"));
                bid.setAmount(rs.getBigDecimal("amount"));
                bid.setBidTime(rs.getTimestamp("bid_time"));
                bid.setUserName(rs.getString("name"));
                bids.add(bid);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return bids;
    }
    
    public Bid getHighestBid(int auctionId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Bid bid = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT b.bid_id, b.auction_id, b.user_id, b.amount, b.bid_time, u.name " +
                          "FROM Bid b " +
                          "JOIN User u ON b.user_id = u.user_id " +
                          "WHERE b.auction_id = ? " +
                          "ORDER BY b.amount DESC, b.bid_time ASC " +
                          "LIMIT 1";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                bid = new Bid();
                bid.setBidId(rs.getInt("bid_id"));
                bid.setAuctionId(rs.getInt("auction_id"));
                bid.setUserId(rs.getInt("user_id"));
                bid.setAmount(rs.getBigDecimal("amount"));
                bid.setBidTime(rs.getTimestamp("bid_time"));
                bid.setUserName(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return bid;
    }
    
    public AutoBid getAutoBid(int auctionId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        AutoBid autoBid = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT auction_id, user_id, max_amount FROM AutoBid " +
                          "WHERE auction_id = ? AND user_id = ?";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                autoBid = new AutoBid();
                autoBid.setAuctionId(rs.getInt("auction_id"));
                autoBid.setUserId(rs.getInt("user_id"));
                autoBid.setMaxAmount(rs.getBigDecimal("max_amount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return autoBid;
    }
    
    public boolean deleteBid(int bidId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "DELETE FROM Bid WHERE bid_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, bidId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<AutoBid> getAutoBidsExceeded(int auctionId, BigDecimal currentBid) {
        List<AutoBid> autoBids = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT ab.auction_id, ab.user_id, ab.max_amount, u.name " +
                          "FROM AutoBid ab " +
                          "JOIN User u ON ab.user_id = u.user_id " +
                          "WHERE ab.auction_id = ? AND ab.max_amount < ?";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            pstmt.setBigDecimal(2, currentBid);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AutoBid autoBid = new AutoBid();
                autoBid.setAuctionId(rs.getInt("auction_id"));
                autoBid.setUserId(rs.getInt("user_id"));
                autoBid.setMaxAmount(rs.getBigDecimal("max_amount"));
                autoBid.setUserName(rs.getString("name"));
                autoBids.add(autoBid);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return autoBids;
    }
}
