package com.auction.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.auction.model.Item;
import com.auction.model.Category;
import com.auction.model.SubCategory;
import com.auction.util.DatabaseConnection;

public class ItemDAO {
    
    public int createItem(String title, String description, String condition, int subcategoryId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "INSERT INTO Item (title, description, `condition`, subcategory_id) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, title);
            pstmt.setString(2, description);
            pstmt.setString(3, condition);
            pstmt.setInt(4, subcategoryId);
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int itemId = rs.getInt(1);
                    
                    String groupsQuery = "INSERT INTO item_groups (subcategory_id, item_id) VALUES (?, ?)";
                    PreparedStatement groupsPstmt = conn.prepareStatement(groupsQuery);
                    groupsPstmt.setInt(1, subcategoryId);
                    groupsPstmt.setInt(2, itemId);
                    groupsPstmt.executeUpdate();
                    groupsPstmt.close();
                    
                    return itemId;
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
        
        return -1;
    }
    
    public Item getItemById(int itemId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Item item = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT i.item_id, i.title, i.description, i.`condition`, i.subcategory_id, " +
                          "sc.name as subcategory_name, c.name as category_name " +
                          "FROM Item i " +
                          "LEFT JOIN SubCategory sc ON i.subcategory_id = sc.id " +
                          "LEFT JOIN Category c ON sc.category_id = c.category_id " +
                          "WHERE i.item_id = ?";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, itemId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setCondition(rs.getString("condition"));
                item.setSubcategoryId(rs.getInt("subcategory_id"));
                item.setSubcategoryName(rs.getString("subcategory_name"));
                item.setCategoryName(rs.getString("category_name"));
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
        
        return item;
    }
    
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT category_id, name FROM Category ORDER BY name";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                categories.add(category);
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
        
        return categories;
    }
    
    public List<SubCategory> getSubCategoriesByCategory(int categoryId) {
        List<SubCategory> subcategories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT id, name, category_id FROM SubCategory WHERE category_id = ? ORDER BY name";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SubCategory subcategory = new SubCategory();
                subcategory.setId(rs.getInt("id"));
                subcategory.setName(rs.getString("name"));
                subcategory.setCategoryId(rs.getInt("category_id"));
                subcategories.add(subcategory);
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
        
        return subcategories;
    }
    
    public List<SubCategory> getAllSubCategories() {
        List<SubCategory> subcategories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT sc.id, sc.name, sc.category_id, c.name as category_name " +
                          "FROM SubCategory sc " +
                          "JOIN Category c ON sc.category_id = c.category_id " +
                          "ORDER BY c.name, sc.name";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SubCategory subcategory = new SubCategory();
                subcategory.setId(rs.getInt("id"));
                subcategory.setName(rs.getString("name"));
                subcategory.setCategoryId(rs.getInt("category_id"));
                subcategory.setCategoryName(rs.getString("category_name"));
                subcategories.add(subcategory);
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
        
        return subcategories;
    }
}
