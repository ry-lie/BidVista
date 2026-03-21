<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.model.Auction" %>
<%@ page import="com.auction.model.Category" %>
<%@ page import="com.auction.model.SubCategory" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%@ page import="com.auction.dao.ItemDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    AuctionDAO auctionDAO = new AuctionDAO();
    ItemDAO itemDAO = new ItemDAO();
    
    String keyword = request.getParameter("keyword");
    String categoryIdStr = request.getParameter("categoryId");
    String subcategoryIdStr = request.getParameter("subcategoryId");
    String minPriceStr = request.getParameter("minPrice");
    String maxPriceStr = request.getParameter("maxPrice");
    String sortBy = request.getParameter("sortBy");
    
    Integer categoryId = null;
    Integer subcategoryId = null;
    BigDecimal minPrice = null;
    BigDecimal maxPrice = null;
    
    if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
        categoryId = Integer.parseInt(categoryIdStr);
    }
    if (subcategoryIdStr != null && !subcategoryIdStr.isEmpty()) {
        subcategoryId = Integer.parseInt(subcategoryIdStr);
    }
    if (minPriceStr != null && !minPriceStr.isEmpty()) {
        minPrice = new BigDecimal(minPriceStr);
    }
    if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
        maxPrice = new BigDecimal(maxPriceStr);
    }
    
    List<Auction> auctions;
    if (keyword != null || categoryId != null || subcategoryId != null || minPrice != null || maxPrice != null) {
        auctions = auctionDAO.searchAuctions(keyword, categoryId, subcategoryId, minPrice, maxPrice, sortBy);
    } else {
        auctions = auctionDAO.getAllActiveAuctions();
    }
    
    List<Category> categories = itemDAO.getAllCategories();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Auctions - Auction System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar h1 {
            font-size: 24px;
        }
        
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .navbar a:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .search-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .search-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .form-group input, .form-group select {
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .search-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
        }
        
        .search-btn:hover {
            opacity: 0.9;
        }
        
        .auctions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
        }
        
        .auction-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .auction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .auction-card h3 {
            color: #333;
            font-size: 20px;
            margin-bottom: 10px;
        }
        
        .auction-card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .price {
            font-size: 24px;
            color: #667eea;
            font-weight: bold;
            margin: 15px 0;
        }
        
        .bid-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 13px;
            color: #999;
        }
        
        .view-btn {
            display: block;
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
        }
        
        .view-btn:hover {
            opacity: 0.9;
        }
        
        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 18px;
        }
        
        .category-badge {
            display: inline-block;
            background: #f0f0f0;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-active {
            background: #e8f5e9;
            color: #2e7d32;
        }
        
        .ending-soon {
            color: #d32f2f;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Browse Auctions</h1>
        <div>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="search-section">
            <form class="search-form" method="get" action="browseAuctions.jsp">
                <div class="form-group">
                    <label>Keyword</label>
                    <input type="text" name="keyword" placeholder="Search items..." value="<%= keyword != null ? keyword : "" %>">
                </div>
                
                <div class="form-group">
                    <label>Category</label>
                    <select name="categoryId" id="categorySelect">
                        <option value="">All Categories</option>
                        <% for (Category cat : categories) { %>
                            <option value="<%= cat.getCategoryId() %>" <%= categoryId != null && categoryId == cat.getCategoryId() ? "selected" : "" %>>
                                <%= cat.getName() %>
                            </option>
                        <% } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Min Price</label>
                    <input type="number" name="minPrice" step="0.01" placeholder="0.00" value="<%= minPriceStr != null ? minPriceStr : "" %>">
                </div>
                
                <div class="form-group">
                    <label>Max Price</label>
                    <input type="number" name="maxPrice" step="0.01" placeholder="1000.00" value="<%= maxPriceStr != null ? maxPriceStr : "" %>">
                </div>
                
                <div class="form-group">
                    <label>Sort By</label>
                    <select name="sortBy">
                        <option value="ending_soon" <%= "ending_soon".equals(sortBy) ? "selected" : "" %>>Ending Soon</option>
                        <option value="newly_listed" <%= "newly_listed".equals(sortBy) ? "selected" : "" %>>Newly Listed</option>
                        <option value="price_asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Price: Low to High</option>
                        <option value="price_desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Price: High to Low</option>
                    </select>
                </div>
                
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>
        
        <% if (auctions.isEmpty()) { %>
            <div class="no-results">
                No auctions found. Try adjusting your search criteria.
            </div>
        <% } else { %>
            <div class="auctions-grid">
                <% for (Auction auction : auctions) { %>
                    <div class="auction-card">
                        <% if (auction.getItem().getCategoryName() != null) { %>
                            <div class="category-badge"><%= auction.getItem().getCategoryName() %> - <%= auction.getItem().getSubcategoryName() %></div>
                        <% } %>
                        <h3><%= auction.getItem().getTitle() %></h3>
                        <p><%= auction.getItem().getDescription().length() > 100 ? 
                              auction.getItem().getDescription().substring(0, 100) + "..." : 
                              auction.getItem().getDescription() %></p>
                        
                        <div class="price">$<%= String.format("%.2f", auction.getCurrentBid()) %></div>
                        
                        <div class="bid-info">
                            <span><%= auction.getBidCount() %> bids</span>
                            <span class="<%= auction.getEndTime().getTime() - System.currentTimeMillis() < 3600000 ? "ending-soon" : "" %>">
                                Ends: <%= new java.text.SimpleDateFormat("MMM dd, HH:mm").format(auction.getEndTime()) %>
                            </span>
                        </div>
                        
                        <span class="status-badge status-active">Active</span>
                        
                        <a href="auctionDetails.jsp?id=<%= auction.getAuctionId() %>" class="view-btn">View & Bid</a>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
