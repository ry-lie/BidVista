<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.model.Auction" %>
<%@ page import="com.auction.model.Bid" %>
<%@ page import="com.auction.model.AutoBid" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%@ page import="com.auction.dao.BidDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String auctionIdStr = request.getParameter("id");
    if (auctionIdStr == null) {
        response.sendRedirect("browseAuctions.jsp");
        return;
    }
    
    int auctionId = Integer.parseInt(auctionIdStr);
    
    AuctionDAO auctionDAO = new AuctionDAO();
    BidDAO bidDAO = new BidDAO();
    
    Auction auction = auctionDAO.getAuctionById(auctionId);
    if (auction == null) {
        response.sendRedirect("browseAuctions.jsp");
        return;
    }
    
    List<Bid> bidHistory = bidDAO.getBidHistory(auctionId);
    AutoBid userAutoBid = bidDAO.getAutoBid(auctionId, user.getUserId());
    List<Auction> similarAuctions = auctionDAO.getSimilarAuctions(auction.getItem().getSubcategoryId(), auctionId);
    
    BigDecimal minBid = auction.getCurrentBid().add(auction.getBidIncrement());
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= auction.getItem().getTitle() %> - Auction System</title>
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
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        .main-content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .item-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .category-badge {
            display: inline-block;
            background: #f0f0f0;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }
        
        .current-price {
            font-size: 48px;
            color: #667eea;
            font-weight: bold;
            margin: 20px 0;
        }
        
        .price-label {
            font-size: 14px;
            color: #999;
            margin-bottom: 10px;
        }
        
        .auction-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin: 30px 0;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 10px;
        }
        
        .stat {
            text-align: center;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        
        .stat-label {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        .description {
            margin: 30px 0;
        }
        
        .description h3 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .description p {
            color: #666;
            line-height: 1.6;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .info-label {
            color: #999;
            font-size: 14px;
        }
        
        .info-value {
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        
        .card h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 16px;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .bid-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
        }
        
        .bid-btn:hover {
            opacity: 0.9;
        }
        
        .bid-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
        }
        
        .bid-history {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .bid-item {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .bid-item:last-child {
            border-bottom: none;
        }
        
        .bid-amount {
            font-size: 18px;
            font-weight: bold;
            color: #667eea;
        }
        
        .bid-user {
            font-size: 14px;
            color: #666;
        }
        
        .bid-time {
            font-size: 12px;
            color: #999;
        }
        
        .similar-item {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .similar-item:last-child {
            border-bottom: none;
        }
        
        .similar-item h4 {
            color: #333;
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .similar-item p {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .similar-item a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }
        
        .similar-item a:hover {
            text-decoration: underline;
        }
        
        .autobid-status {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
        }
        
        .autobid-status strong {
            color: #1976d2;
        }
        
        .min-bid-info {
            font-size: 13px;
            color: #999;
            margin-top: 5px;
        }
        
        @media (max-width: 968px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Auction Details</h1>
        <div>
            <a href="browseAuctions.jsp">Browse</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="main-content">
            <h1 class="item-title"><%= auction.getItem().getTitle() %></h1>
            
            <div class="category-badge">
                <%= auction.getItem().getCategoryName() %> > <%= auction.getItem().getSubcategoryName() %>
            </div>
            
            <div class="price-label">Current Bid</div>
            <div class="current-price">$<%= String.format("%.2f", auction.getCurrentBid()) %></div>
            
            <div class="auction-stats">
                <div class="stat">
                    <div class="stat-value"><%= auction.getBidCount() %></div>
                    <div class="stat-label">Total Bids</div>
                </div>
                <div class="stat">
                    <div class="stat-value">$<%= String.format("%.2f", auction.getBidIncrement()) %></div>
                    <div class="stat-label">Bid Increment</div>
                </div>
                <div class="stat">
                    <div class="stat-value">
                        <%= new java.text.SimpleDateFormat("MMM dd").format(auction.getEndTime()) %>
                    </div>
                    <div class="stat-label">End Date</div>
                </div>
            </div>
            
            <div class="description">
                <h3>Description</h3>
                <p><%= auction.getItem().getDescription() %></p>
            </div>
            
            <div class="info-row">
                <span class="info-label">Condition</span>
                <span class="info-value"><%= auction.getItem().getCondition() %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Seller</span>
                <span class="info-value"><%= auction.getSellerName() %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Start Time</span>
                <span class="info-value">
                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getStartTime()) %>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">End Time</span>
                <span class="info-value">
                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getEndTime()) %>
                </span>
            </div>
        </div>
        
        <div class="sidebar">
            <div class="card">
                <h3>Place Bid</h3>
                
                <% if (success != null) { %>
                    <% if (success.equals("bid")) { %>
                        <div class="success-message">
                            Bid placed successfully!
                        </div>
                    <% } else if (success.equals("auto")) { %>
                        <div class="success-message">
                            Automatic bidding enabled!
                        </div>
                    <% } %>
                <% } %>
                
                <% if (error != null) { %>
                    <% if (error.equals("low")) { %>
                        <div class="error-message">
                            Bid must be at least $<%= String.format("%.2f", minBid) %>
                        </div>
                    <% } else if (error.equals("failed")) { %>
                        <div class="error-message">
                            Bid placement failed. Please try again.
                        </div>
                    <% } else if (error.equals("owner")) { %>
                        <div class="error-message">
                            You cannot bid on your own auction.
                        </div>
                    <% } %>
                <% } %>
                
                <% if (user.getUserId() != auction.getSellerId()) { %>
                    <form action="placeBidProcess.jsp" method="post">
                        <input type="hidden" name="auctionId" value="<%= auctionId %>">
                        
                        <div class="form-group">
                            <label>Your Bid Amount</label>
                            <input type="number" name="amount" step="0.01" min="<%= minBid %>" 
                                   value="<%= minBid %>" required>
                            <div class="min-bid-info">Minimum bid: $<%= String.format("%.2f", minBid) %></div>
                        </div>
                        
                        <button type="submit" name="bidType" value="manual" class="bid-btn">Place Bid</button>
                    </form>
                    
                    <hr style="margin: 25px 0; border: none; border-top: 1px solid #e0e0e0;">
                    
                    <% if (userAutoBid != null) { %>
                        <div class="autobid-status">
                            <strong>Auto-Bid Active</strong><br>
                            Max Amount: $<%= String.format("%.2f", userAutoBid.getMaxAmount()) %>
                        </div>
                    <% } %>
                    
                    <form action="placeBidProcess.jsp" method="post">
                        <input type="hidden" name="auctionId" value="<%= auctionId %>">
                        
                        <div class="form-group">
                            <label>Maximum Auto-Bid Amount</label>
                            <input type="number" name="maxAmount" step="0.01" min="<%= minBid %>" 
                                   value="<%= userAutoBid != null ? userAutoBid.getMaxAmount() : minBid %>" required>
                            <div class="min-bid-info">System will bid up to this amount automatically</div>
                        </div>
                        
                        <button type="submit" name="bidType" value="auto" class="bid-btn">
                            <%= userAutoBid != null ? "Update" : "Enable" %> Auto-Bid
                        </button>
                    </form>
                <% } else { %>
                    <div class="error-message">
                        This is your auction. You cannot place bids.
                    </div>
                <% } %>
            </div>
            
            <div class="card">
                <h3>Bid History (<%= bidHistory.size() %>)</h3>
                <div class="bid-history">
                    <% if (bidHistory.isEmpty()) { %>
                        <p style="color: #999; text-align: center; padding: 20px;">No bids yet. Be the first!</p>
                    <% } else { %>
                        <% for (Bid bid : bidHistory) { %>
                            <div class="bid-item">
                                <div>
                                    <div class="bid-amount">$<%= String.format("%.2f", bid.getAmount()) %></div>
                                    <div class="bid-user"><%= bid.getUserName() %></div>
                                </div>
                                <div class="bid-time">
                                    <%= new java.text.SimpleDateFormat("MMM dd, HH:mm").format(bid.getBidTime()) %>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
            
            <% if (!similarAuctions.isEmpty()) { %>
                <div class="card">
                    <h3>Similar Items</h3>
                    <% for (Auction similar : similarAuctions) { %>
                        <div class="similar-item">
                            <h4><%= similar.getItem().getTitle() %></h4>
                            <p>Current Bid: $<%= String.format("%.2f", similar.getCurrentBid()) %></p>
                            <a href="auctionDetails.jsp?id=<%= similar.getAuctionId() %>">View Auction →</a>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
