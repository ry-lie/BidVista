package com.auction.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import com.auction.util.DatabaseConnection;

public class ReportDAO {
    
    public BigDecimal getTotalEarnings() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT COALESCE(SUM(b.amount), 0) as total " +
                          "FROM Auction a " +
                          "JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE a.status = 'closed' " +
                          "AND b.amount = (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) " +
                          "AND (a.reserve_price IS NULL OR b.amount >= a.reserve_price)";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
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
        
        return BigDecimal.ZERO;
    }
    
    public Map<String, BigDecimal> getEarningsPerItem() {
        Map<String, BigDecimal> earnings = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT i.title, MAX(b.amount) as earning " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE a.status = 'closed' " +
                          "AND (a.reserve_price IS NULL OR b.amount >= a.reserve_price) " +
                          "GROUP BY i.item_id " +
                          "ORDER BY earning DESC";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String itemTitle = rs.getString("title");
                BigDecimal earning = rs.getBigDecimal("earning");
                earnings.put(itemTitle, earning != null ? earning : BigDecimal.ZERO);
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
        
        return earnings;
    }
    
    public Map<String, BigDecimal> getEarningsPerItemType() {
        Map<String, BigDecimal> earnings = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT c.name, COALESCE(SUM(b.amount), 0) as total_earning " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "JOIN SubCategory sc ON i.subcategory_id = sc.id " +
                          "JOIN Category c ON sc.category_id = c.category_id " +
                          "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE a.status = 'closed' " +
                          "AND b.amount = (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) " +
                          "AND (a.reserve_price IS NULL OR b.amount >= a.reserve_price) " +
                          "GROUP BY c.category_id " +
                          "ORDER BY total_earning DESC";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String categoryName = rs.getString("name");
                BigDecimal earning = rs.getBigDecimal("total_earning");
                earnings.put(categoryName, earning);
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
        
        return earnings;
    }
    
    public Map<String, BigDecimal> getEarningsPerEndUser() {
        Map<String, BigDecimal> earnings = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT u.name, COALESCE(SUM(b.amount), 0) as total_earning " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "JOIN sells s ON i.item_id = s.item_id " +
                          "JOIN User u ON s.user_id = u.user_id " +
                          "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE a.status = 'closed' " +
                          "AND b.amount = (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) " +
                          "AND (a.reserve_price IS NULL OR b.amount >= a.reserve_price) " +
                          "GROUP BY u.user_id " +
                          "ORDER BY total_earning DESC";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String userName = rs.getString("name");
                BigDecimal earning = rs.getBigDecimal("total_earning");
                earnings.put(userName, earning);
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
        
        return earnings;
    }
    
    public Map<String, Integer> getBestSellingItems() {
        Map<String, Integer> items = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT i.title, COUNT(*) as bid_count " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE a.status = 'closed' " +
                          "GROUP BY i.item_id " +
                          "ORDER BY bid_count DESC " +
                          "LIMIT 10";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String itemTitle = rs.getString("title");
                int bidCount = rs.getInt("bid_count");
                items.put(itemTitle, bidCount);
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
        
        return items;
    }
    
    public Map<String, BigDecimal> getBestBuyers() {
        Map<String, BigDecimal> buyers = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT u.name, COALESCE(SUM(b.amount), 0) as total_spent " +
                          "FROM Bid b " +
                          "JOIN User u ON b.user_id = u.user_id " +
                          "JOIN Auction a ON b.auction_id = a.auction_id " +
                          "WHERE a.status = 'closed' " +
                          "AND b.amount = (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) " +
                          "GROUP BY u.user_id " +
                          "ORDER BY total_spent DESC " +
                          "LIMIT 10";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String userName = rs.getString("name");
                BigDecimal totalSpent = rs.getBigDecimal("total_spent");
                buyers.put(userName, totalSpent);
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
        
        return buyers;
    }
}
