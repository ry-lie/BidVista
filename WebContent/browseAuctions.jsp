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
    <title>BidVista - Browse Auctions</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="browse-page">
    <header class="browse-navbar">
        <div class="container-wide browse-navbar-inner">
            <div class="browse-navbar-title">Browse Auctions</div>

            <nav class="browse-navbar-links">
                <a href="dashboard.jsp">Dashboard</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>

    <main class="browse-main">
        <div class="container-wide">
            <section class="browse-search-section">
                <form class="browse-search-form" method="get" action="browseAuctions.jsp">
                    <div class="form-group">
                        <label for="keyword">Keyword</label>
                        <input
                            type="text"
                            id="keyword"
                            name="keyword"
                            placeholder="Search items..."
                            value="<%= keyword != null ? keyword : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="categorySelect">Category</label>
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
                        <label for="minPrice">Min Price</label>
                        <input
                            type="number"
                            id="minPrice"
                            name="minPrice"
                            step="0.01"
                            placeholder="0.00"
                            value="<%= minPriceStr != null ? minPriceStr : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="maxPrice">Max Price</label>
                        <input
                            type="number"
                            id="maxPrice"
                            name="maxPrice"
                            step="0.01"
                            placeholder="1000.00"
                            value="<%= maxPriceStr != null ? maxPriceStr : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="sortBy">Sort By</label>
                        <select name="sortBy" id="sortBy">
                            <option value="ending_soon" <%= "ending_soon".equals(sortBy) ? "selected" : "" %>>Ending Soon</option>
                            <option value="newly_listed" <%= "newly_listed".equals(sortBy) ? "selected" : "" %>>Newly Listed</option>
                            <option value="price_asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Price: Low to High</option>
                            <option value="price_desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Price: High to Low</option>
                        </select>
                    </div>

                    <div class="browse-search-button-wrap">
                        <button type="submit" class="browse-search-btn">Search</button>
                    </div>
                </form>
            </section>

            <% if (auctions.isEmpty()) { %>
                <div class="browse-no-results">
                    No auctions found. Try adjusting your search criteria.
                </div>
            <% } else { %>
                <section class="browse-auctions-grid">
                    <% for (Auction auction : auctions) { %>
                        <div class="browse-auction-card">
                            <% if (auction.getItem().getCategoryName() != null) { %>
                                <div class="browse-category-badge">
                                    <%= auction.getItem().getCategoryName() %> - <%= auction.getItem().getSubcategoryName() %>
                                </div>
                            <% } %>

                            <h3><%= auction.getItem().getTitle() %></h3>

                            <p>
                                <%= auction.getItem().getDescription().length() > 100 ?
                                      auction.getItem().getDescription().substring(0, 100) + "..." :
                                      auction.getItem().getDescription() %>
                            </p>

                            <div class="browse-price">$<%= String.format("%.2f", auction.getCurrentBid()) %></div>

                            <div class="browse-bid-info">
                                <span><%= auction.getBidCount() %> bids</span>
                                <span class="<%= auction.getEndTime().getTime() - System.currentTimeMillis() < 3600000 ? "browse-ending-soon" : "" %>">
                                    Ends: <%= new java.text.SimpleDateFormat("MMM dd, HH:mm").format(auction.getEndTime()) %>
                                </span>
                            </div>

                            <span class="browse-status-badge browse-status-active">Active</span>

                            <a href="auctionDetails.jsp?id=<%= auction.getAuctionId() %>" class="browse-view-btn">View &amp; Bid</a>
                        </div>
                    <% } %>
                </section>
            <% } %>
        </div>
    </main>
</body>
</html>