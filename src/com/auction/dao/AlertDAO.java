package com.auction.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.auction.model.Alert;
import com.auction.util.DatabaseConnection;

public class AlertDAO {
    
    public boolean createAlert(int userId, Integer subcategoryId, String keywords, 
                              BigDecimal minPrice, BigDecimal maxPrice) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "INSERT INTO Alert (user_id, subcategory_id, keywords, min_price, max_price, created_at) " +
                          "VALUES (?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, userId);
            if (subcategoryId != null) {
                pstmt.setInt(2, subcategoryId);
            } else {
                pstmt.setNull(2, Types.INTEGER);
            }
            pstmt.setString(3, keywords);
            if (minPrice != null) {
                pstmt.setBigDecimal(4, minPrice);
            } else {
                pstmt.setNull(4, Types.DECIMAL);
            }
            if (maxPrice != null) {
                pstmt.setBigDecimal(5, maxPrice);
            } else {
                pstmt.setNull(5, Types.DECIMAL);
            }
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int alertId = rs.getInt(1);
                    
                    String watchesQuery = "INSERT INTO watches (user_id, alert_id) VALUES (?, ?)";
                    PreparedStatement watchesPstmt = conn.prepareStatement(watchesQuery);
                    watchesPstmt.setInt(1, userId);
                    watchesPstmt.setInt(2, alertId);
                    watchesPstmt.executeUpdate();
                    watchesPstmt.close();
                    
                    if (subcategoryId != null) {
                        String filtersQuery = "INSERT INTO filters (alert_id, subcategory_id) VALUES (?, ?)";
                        PreparedStatement filtersPstmt = conn.prepareStatement(filtersQuery);
                        filtersPstmt.setInt(1, alertId);
                        filtersPstmt.setInt(2, subcategoryId);
                        filtersPstmt.executeUpdate();
                        filtersPstmt.close();
                    }
                }
            }
            
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Alert> getUserAlerts(int userId) {
        List<Alert> alerts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT a.alert_id, a.user_id, a.subcategory_id, a.keywords, " +
                          "a.min_price, a.max_price, a.created_at, sc.name as subcategory_name " +
                          "FROM Alert a " +
                          "LEFT JOIN SubCategory sc ON a.subcategory_id = sc.id " +
                          "WHERE a.user_id = ? " +
                          "ORDER BY a.created_at DESC";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Alert alert = new Alert();
                alert.setAlertId(rs.getInt("alert_id"));
                alert.setUserId(rs.getInt("user_id"));
                if (rs.getObject("subcategory_id") != null) {
                    alert.setSubcategoryId(rs.getInt("subcategory_id"));
                }
                alert.setKeywords(rs.getString("keywords"));
                alert.setMinPrice(rs.getBigDecimal("min_price"));
                alert.setMaxPrice(rs.getBigDecimal("max_price"));
                alert.setCreatedAt(rs.getTimestamp("created_at"));
                alert.setSubcategoryName(rs.getString("subcategory_name"));
                alerts.add(alert);
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
        
        return alerts;
    }
    
    public boolean deleteAlert(int alertId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "DELETE FROM Alert WHERE alert_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, alertId);
            
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
}
