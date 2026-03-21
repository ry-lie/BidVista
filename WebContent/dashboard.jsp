<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    AuctionDAO auctionDAO = new AuctionDAO();
    int myAuctionsCount = auctionDAO.getUserAuctionsAsSeller(user.getUserId()).size();
    int myBidsCount = auctionDAO.getUserAuctionsAsBidder(user.getUserId()).size();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Auction System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .header h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 5px;
        }
        .header p {
            color: #666;
            font-size: 16px;
        }
        .logout-btn {
            float: right;
            padding: 10px 20px;
            background: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
        }
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card h3 {
            color: #333;
            font-size: 18px;
            margin-bottom: 15px;
        }
        .card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .card-btn {
            display: inline-block;
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
        }
        .card-btn:hover {
            opacity: 0.9;
        }
        .stat {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            margin: 10px 0;
        }
        .role-badge {
            display: inline-block;
            padding: 5px 15px;
            background: #e3f2fd;
            color: #1976d2;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <a href="logout.jsp" class="logout-btn">Logout</a>
            <h1>Welcome, <%= user.getName() %>!</h1>
            <p>
                <%= user.getRole() %>
                <span class="role-badge"><%= user.isAdmin() ? "ADMIN" : user.getRole().toUpperCase() %></span>
            </p>
        </div>
        
        <div class="cards-grid">
            <div class="card">
                <h3>Browse Auctions</h3>
                <p>Search and bid on active auctions</p>
                <a href="browseAuctions.jsp" class="card-btn">Browse Now</a>
            </div>
            
            <% if (user.getRole().contains("seller") || user.getRole().equals("buyer_seller")) { %>
            <div class="card">
                <h3>Create Auction</h3>
                <p>List a new item for auction</p>
                <a href="createAuction.jsp" class="card-btn">Create Auction</a>
            </div>
            
            <div class="card">
                <h3>My Auctions</h3>
                <div class="stat"><%= myAuctionsCount %></div>
                <p>Manage your active listings</p>
                <a href="myAuctions.jsp" class="card-btn">View My Auctions</a>
            </div>
            <% } %>
            
            <div class="card">
                <h3>My Bids</h3>
                <div class="stat"><%= myBidsCount %></div>
                <p>Track your bidding activity</p>
                <a href="myBids.jsp" class="card-btn">View My Bids</a>
            </div>
            
            <div class="card">
                <h3>My Alerts</h3>
                <p>Manage item notifications</p>
                <a href="myAlerts.jsp" class="card-btn">Manage Alerts</a>
            </div>
            
            <div class="card">
                <h3>Questions & Answers</h3>
                <p>Browse customer service Q&A</p>
                <a href="questions.jsp" class="card-btn">View Q&A</a>
            </div>
            
            <% if (user.isAdmin()) { %>
            <div class="card">
                <h3>Admin Dashboard</h3>
                <p>Manage users and view reports</p>
                <a href="adminDashboard.jsp" class="card-btn">Admin Panel</a>
            </div>
            <% } %>
            
            <% if (user.getRole().equals("customer_representative")) { %>
            <div class="card">
                <h3>Customer Rep Dashboard</h3>
                <p>Manage users and answer questions</p>
                <a href="repDashboard.jsp" class="card-btn">Rep Panel</a>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
