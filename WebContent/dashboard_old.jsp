<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .header h1 {
            color: #333;
            font-size: 28px;
        }
        
        .logout-btn {
            padding: 10px 25px;
            background: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .logout-btn:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }
        
        .content-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }
        
        .welcome-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .welcome-section h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .user-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .info-item label {
            display: block;
            color: #666;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        
        .info-item .value {
            color: #333;
            font-size: 18px;
            font-weight: 600;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 5px;
        }
        
        .badge.admin {
            background: #ffc107;
            color: #856404;
        }
        
        .badge.user {
            background: #28a745;
            color: white;
        }
        
        .status-section {
            margin-top: 30px;
            padding: 20px;
            background: #e7f3ff;
            border-radius: 10px;
            border-left: 4px solid #2196F3;
        }
        
        .status-section h3 {
            color: #1976D2;
            margin-bottom: 10px;
        }
        
        .status-section p {
            color: #555;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>Auction System Dashboard</h1>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
        
        <div class="content-card">
            <div class="welcome-section">
                <h2>Welcome back, <%= user.getName() %>!</h2>
                <p style="color: #666; font-size: 16px;">
                    You have successfully logged into the auction system.
                </p>
            </div>
            
            <div class="user-info">
                <div class="info-item">
                    <label>User ID</label>
                    <div class="value">#<%= user.getUserId() %></div>
                </div>
                
                <div class="info-item">
                    <label>Full Name</label>
                    <div class="value"><%= user.getName() %></div>
                </div>
                
                <div class="info-item">
                    <label>Email Address</label>
                    <div class="value"><%= user.getEmail() %></div>
                </div>
                
                <div class="info-item">
                    <label>Role</label>
                    <div class="value">
                        <%= user.getRole() %>
                        <% if (user.isAdmin()) { %>
                            <span class="badge admin">ADMIN</span>
                        <% } else { %>
                            <span class="badge user">USER</span>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <div class="status-section">
                <h3>Login Status: Active</h3>
                <p>
                    <strong>Session Information:</strong><br>
                    Session ID: <%= session.getId() %><br>
                    Login Time: <%= new java.util.Date() %><br>
                    Session Status: Active and Valid
                </p>
            </div>
        </div>
    </div>
</body>
</html>
