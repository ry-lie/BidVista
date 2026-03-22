package com.auction.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.auction.model.Auction;
import com.auction.model.Item;
import com.auction.util.DatabaseConnection;

public class AuctionDAO {
    
    public int createAuction(Auction auction, int sellerId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "INSERT INTO Auction (item_id, start_price, reserve_price, start_time, end_time, bid_increment, status) VALUES (?, ?, ?, ?, ?, ?, 'active')";
            pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, auction.getItemId());
            pstmt.setBigDecimal(2, auction.getStartPrice());
            if (auction.getReservePrice() != null) {
                pstmt.setBigDecimal(3, auction.getReservePrice());
            } else {
                pstmt.setNull(3, Types.DECIMAL);
            }
            pstmt.setTimestamp(4, auction.getStartTime());
            pstmt.setTimestamp(5, auction.getEndTime());
            pstmt.setBigDecimal(6, auction.getBidIncrement());
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int auctionId = rs.getInt(1);
                    
                    String sellsQuery = "INSERT INTO sells (user_id, item_id) VALUES (?, ?)";
                    PreparedStatement sellsPstmt = conn.prepareStatement(sellsQuery);
                    sellsPstmt.setInt(1, sellerId);
                    sellsPstmt.setInt(2, auction.getItemId());
                    sellsPstmt.executeUpdate();
                    sellsPstmt.close();
                    
                    String listedQuery = "INSERT INTO listedin (item_id, auction_id) VALUES (?, ?)";
                    PreparedStatement listedPstmt = conn.prepareStatement(listedQuery);
                    listedPstmt.setInt(1, auction.getItemId());
                    listedPstmt.setInt(2, auctionId);
                    listedPstmt.executeUpdate();
                    listedPstmt.close();
                    
                    return auctionId;
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
    
    public List<Auction> getAllActiveAuctions() {
        List<Auction> auctions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            String query =
                "SELECT a.auction_id, a.item_id, a.start_price, a.reserve_price, " +
                "a.start_time, a.end_time, a.bid_increment, a.status, " +
                "i.title, i.description, i.condition, " +
                "sc.name AS subcategory_name, c.name AS category_name, " +
                "u.user_id AS seller_id, u.name AS seller_name, " +
                "COALESCE((SELECT MAX(b.amount) FROM Bid b WHERE b.auction_id = a.auction_id), a.start_price) AS current_bid, " +
                "(SELECT COUNT(*) FROM Bid b2 WHERE b2.auction_id = a.auction_id) AS bid_count " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "LEFT JOIN SubCategory sc ON i.subcategory_id = sc.id " +
                "LEFT JOIN Category c ON sc.category_id = c.category_id " +
                "LEFT JOIN sells s ON i.item_id = s.item_id " +
                "LEFT JOIN User u ON s.user_id = u.user_id " +
                "WHERE a.status = 'active' " +
                "AND a.start_time <= NOW() " +
                "AND a.end_time > NOW() " +
                "ORDER BY a.end_time ASC";

            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Auction auction = new Auction();
                auction.setAuctionId(rs.getInt("auction_id"));
                auction.setItemId(rs.getInt("item_id"));
                auction.setStartPrice(rs.getBigDecimal("start_price"));
                auction.setReservePrice(rs.getBigDecimal("reserve_price"));
                auction.setStartTime(rs.getTimestamp("start_time"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setBidIncrement(rs.getBigDecimal("bid_increment"));
                auction.setStatus(rs.getString("status"));
                auction.setSellerId(rs.getInt("seller_id"));
                auction.setSellerName(rs.getString("seller_name"));
                auction.setCurrentBid(rs.getBigDecimal("current_bid"));
                auction.setBidCount(rs.getInt("bid_count"));

                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setCondition(rs.getString("condition"));
                item.setSubcategoryName(rs.getString("subcategory_name"));
                item.setCategoryName(rs.getString("category_name"));
                auction.setItem(item);

                auctions.add(auction);
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

        return auctions;
    }
    
    public Auction getAuctionById(int auctionId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Auction auction = null;

        try {
            conn = DatabaseConnection.getConnection();
            String query =
                "SELECT a.auction_id, a.item_id, a.start_price, a.reserve_price, " +
                "a.start_time, a.end_time, a.bid_increment, a.status, " +
                "i.title, i.description, i.condition, i.subcategory_id, " +
                "sc.name AS subcategory_name, c.name AS category_name, " +
                "u.user_id AS seller_id, u.name AS seller_name, " +
                "COALESCE((SELECT MAX(b.amount) FROM Bid b WHERE b.auction_id = a.auction_id), a.start_price) AS current_bid, " +
                "(SELECT COUNT(*) FROM Bid b2 WHERE b2.auction_id = a.auction_id) AS bid_count " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "LEFT JOIN SubCategory sc ON i.subcategory_id = sc.id " +
                "LEFT JOIN Category c ON sc.category_id = c.category_id " +
                "LEFT JOIN sells s ON i.item_id = s.item_id " +
                "LEFT JOIN User u ON s.user_id = u.user_id " +
                "WHERE a.auction_id = ?";

            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                auction = new Auction();
                auction.setAuctionId(rs.getInt("auction_id"));
                auction.setItemId(rs.getInt("item_id"));
                auction.setStartPrice(rs.getBigDecimal("start_price"));
                auction.setReservePrice(rs.getBigDecimal("reserve_price"));
                auction.setStartTime(rs.getTimestamp("start_time"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setBidIncrement(rs.getBigDecimal("bid_increment"));
                auction.setStatus(rs.getString("status"));
                auction.setSellerId(rs.getInt("seller_id"));
                auction.setSellerName(rs.getString("seller_name"));
                auction.setCurrentBid(rs.getBigDecimal("current_bid"));
                auction.setBidCount(rs.getInt("bid_count"));

                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setCondition(rs.getString("condition"));
                item.setSubcategoryId(rs.getInt("subcategory_id"));
                item.setSubcategoryName(rs.getString("subcategory_name"));
                item.setCategoryName(rs.getString("category_name"));
                auction.setItem(item);
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

        return auction;
    }
    
    public List<Auction> searchAuctions(String keyword, Integer categoryId, Integer subcategoryId,
            BigDecimal minPrice, BigDecimal maxPrice, String sortBy) {
List<Auction> auctions = new ArrayList<>();
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
conn = DatabaseConnection.getConnection();

StringBuilder query = new StringBuilder(
"SELECT a.auction_id, a.item_id, a.start_price, a.reserve_price, " +
"a.start_time, a.end_time, a.bid_increment, a.status, " +
"i.title, i.description, i.condition, " +
"sc.name AS subcategory_name, c.name AS category_name, " +
"u.user_id AS seller_id, u.name AS seller_name, " +
"COALESCE((SELECT MAX(b.amount) FROM Bid b WHERE b.auction_id = a.auction_id), a.start_price) AS current_bid, " +
"(SELECT COUNT(*) FROM Bid b2 WHERE b2.auction_id = a.auction_id) AS bid_count " +
"FROM Auction a " +
"JOIN Item i ON a.item_id = i.item_id " +
"LEFT JOIN SubCategory sc ON i.subcategory_id = sc.id " +
"LEFT JOIN Category c ON sc.category_id = c.category_id " +
"LEFT JOIN sells s ON i.item_id = s.item_id " +
"LEFT JOIN User u ON s.user_id = u.user_id " +
"WHERE a.status = 'active' " +
"AND a.start_time <= NOW() " +
"AND a.end_time > NOW() "
);

List<Object> params = new ArrayList<>();

if (keyword != null && !keyword.trim().isEmpty()) {
query.append("AND (i.title LIKE ? OR i.description LIKE ?) ");
String keywordParam = "%" + keyword + "%";
params.add(keywordParam);
params.add(keywordParam);
}

if (categoryId != null) {
query.append("AND sc.category_id = ? ");
params.add(categoryId);
}

if (subcategoryId != null) {
query.append("AND i.subcategory_id = ? ");
params.add(subcategoryId);
}

if (minPrice != null) {
query.append("AND COALESCE((SELECT MAX(b.amount) FROM Bid b WHERE b.auction_id = a.auction_id), a.start_price) >= ? ");
params.add(minPrice);
}

if (maxPrice != null) {
query.append("AND COALESCE((SELECT MAX(b.amount) FROM Bid b WHERE b.auction_id = a.auction_id), a.start_price) <= ? ");
params.add(maxPrice);
}

if (sortBy != null) {
switch (sortBy) {
case "price_asc":
query.append("ORDER BY current_bid ASC");
break;
case "price_desc":
query.append("ORDER BY current_bid DESC");
break;
case "ending_soon":
query.append("ORDER BY a.end_time ASC");
break;
case "newly_listed":
query.append("ORDER BY a.start_time DESC");
break;
default:
query.append("ORDER BY a.end_time ASC");
}
} else {
query.append("ORDER BY a.end_time ASC");
}

pstmt = conn.prepareStatement(query.toString());

for (int i = 0; i < params.size(); i++) {
Object param = params.get(i);
if (param instanceof String) {
pstmt.setString(i + 1, (String) param);
} else if (param instanceof Integer) {
pstmt.setInt(i + 1, (Integer) param);
} else if (param instanceof BigDecimal) {
pstmt.setBigDecimal(i + 1, (BigDecimal) param);
}
}

rs = pstmt.executeQuery();

while (rs.next()) {
Auction auction = new Auction();
auction.setAuctionId(rs.getInt("auction_id"));
auction.setItemId(rs.getInt("item_id"));
auction.setStartPrice(rs.getBigDecimal("start_price"));
auction.setReservePrice(rs.getBigDecimal("reserve_price"));
auction.setStartTime(rs.getTimestamp("start_time"));
auction.setEndTime(rs.getTimestamp("end_time"));
auction.setBidIncrement(rs.getBigDecimal("bid_increment"));
auction.setStatus(rs.getString("status"));
auction.setSellerId(rs.getInt("seller_id"));
auction.setSellerName(rs.getString("seller_name"));
auction.setCurrentBid(rs.getBigDecimal("current_bid"));
auction.setBidCount(rs.getInt("bid_count"));

Item item = new Item();
item.setItemId(rs.getInt("item_id"));
item.setTitle(rs.getString("title"));
item.setDescription(rs.getString("description"));
item.setCondition(rs.getString("condition"));
item.setSubcategoryName(rs.getString("subcategory_name"));
item.setCategoryName(rs.getString("category_name"));
auction.setItem(item);

auctions.add(auction);
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

return auctions;
}
    
    public List<Auction> getSimilarAuctions(int subcategoryId, int auctionId) {
        List<Auction> auctions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT a.auction_id, a.item_id, a.start_price, a.end_time, " +
                          "i.title, i.condition, sc.name as subcategory_name, " +
                          "COALESCE(MAX(b.amount), a.start_price) as current_bid " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "LEFT JOIN SubCategory sc ON i.subcategory_id = sc.id " +
                          "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE i.subcategory_id = ? AND a.auction_id != ? " +
                          "AND a.start_time >= DATE_SUB(NOW(), INTERVAL 1 MONTH) " +
                          "GROUP BY a.auction_id " +
                          "ORDER BY a.start_time DESC " +
                          "LIMIT 10";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, subcategoryId);
            pstmt.setInt(2, auctionId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Auction auction = new Auction();
                auction.setAuctionId(rs.getInt("auction_id"));
                auction.setItemId(rs.getInt("item_id"));
                auction.setStartPrice(rs.getBigDecimal("start_price"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setCurrentBid(rs.getBigDecimal("current_bid"));
                
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setCondition(rs.getString("condition"));
                item.setSubcategoryName(rs.getString("subcategory_name"));
                auction.setItem(item);
                
                auctions.add(auction);
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
        
        return auctions;
    }
    
    public List<Auction> getUserAuctionsAsSeller(int userId) {
        List<Auction> auctions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT a.auction_id, a.item_id, a.start_price, a.reserve_price, " +
                          "a.start_time, a.end_time, a.status, " +
                          "i.title, COALESCE(MAX(b.amount), a.start_price) as current_bid, " +
                          "COUNT(DISTINCT b.bid_id) as bid_count " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "JOIN sells s ON i.item_id = s.item_id " +
                          "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                          "WHERE s.user_id = ? " +
                          "GROUP BY a.auction_id " +
                          "ORDER BY a.start_time DESC";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Auction auction = new Auction();
                auction.setAuctionId(rs.getInt("auction_id"));
                auction.setItemId(rs.getInt("item_id"));
                auction.setStartPrice(rs.getBigDecimal("start_price"));
                auction.setReservePrice(rs.getBigDecimal("reserve_price"));
                auction.setStartTime(rs.getTimestamp("start_time"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setStatus(rs.getString("status"));
                auction.setCurrentBid(rs.getBigDecimal("current_bid"));
                auction.setBidCount(rs.getInt("bid_count"));
                
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                auction.setItem(item);
                
                auctions.add(auction);
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
        
        return auctions;
    }
    
    public List<Auction> getUserAuctionsAsBidder(int userId) {
        List<Auction> auctions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT DISTINCT a.auction_id, a.item_id, a.start_price, " +
                          "a.end_time, a.status, i.title, " +
                          "COALESCE(MAX(b.amount), a.start_price) as current_bid, " +
                          "COUNT(DISTINCT b.bid_id) as bid_count " +
                          "FROM Auction a " +
                          "JOIN Item i ON a.item_id = i.item_id " +
                          "JOIN Bid b ON a.auction_id = b.auction_id " +
                          "LEFT JOIN Bid b2 ON a.auction_id = b2.auction_id " +
                          "WHERE b.user_id = ? " +
                          "GROUP BY a.auction_id " +
                          "ORDER BY a.end_time DESC";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Auction auction = new Auction();
                auction.setAuctionId(rs.getInt("auction_id"));
                auction.setItemId(rs.getInt("item_id"));
                auction.setStartPrice(rs.getBigDecimal("start_price"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setStatus(rs.getString("status"));
                auction.setCurrentBid(rs.getBigDecimal("current_bid"));
                auction.setBidCount(rs.getInt("bid_count"));
                
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                auction.setItem(item);
                
                auctions.add(auction);
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
        
        return auctions;
    }
    
    public boolean deleteAuction(int auctionId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "DELETE FROM Auction WHERE auction_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, auctionId);
            
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
    
    public void closeExpiredAuctions() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String selectQuery = "SELECT auction_id, reserve_price FROM Auction " +
                                "WHERE status = 'active' AND end_time <= NOW()";
            pstmt = conn.prepareStatement(selectQuery);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int auctionId = rs.getInt("auction_id");
                BigDecimal reservePrice = rs.getBigDecimal("reserve_price");
                
                String updateQuery = "UPDATE Auction SET status = 'closed' WHERE auction_id = ?";
                PreparedStatement updatePstmt = conn.prepareStatement(updateQuery);
                updatePstmt.setInt(1, auctionId);
                updatePstmt.executeUpdate();
                updatePstmt.close();
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
    }
}
