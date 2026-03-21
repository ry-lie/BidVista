<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.model.Category" %>
<%@ page import="com.auction.model.SubCategory" %>
<%@ page import="com.auction.dao.ItemDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ItemDAO itemDAO = new ItemDAO();
    List<Category> categories = itemDAO.getAllCategories();
    List<SubCategory> subcategories = itemDAO.getAllSubCategories();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Auction - Auction System</title>
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
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .form-card {
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-card h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .form-card p {
            color: #666;
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section h3 {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group small {
            display: block;
            color: #999;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .submit-btn {
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
        
        .submit-btn:hover {
            opacity: 0.9;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Create New Auction</h1>
        <div>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="form-card">
            <h2>List Your Item</h2>
            <p>Fill out the details below to create your auction</p>
            
            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <div class="error-message">
                    <% if (error.equals("empty")) { %>
                        Please fill in all required fields.
                    <% } else if (error.equals("invalid")) { %>
                        Invalid data provided. Please check your inputs.
                    <% } else if (error.equals("dates")) { %>
                        End time must be after start time.
                    <% } else if (error.equals("failed")) { %>
                        Failed to create auction. Please try again.
                    <% } %>
                </div>
            <% } %>
            
            <form action="createAuctionProcess.jsp" method="post">
                <div class="form-section">
                    <h3>Item Information</h3>
                    
                    <div class="form-group">
                        <label for="title">Item Title *</label>
                        <input type="text" id="title" name="title" required 
                               placeholder="e.g., Vintage Baseball Card Collection">
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description *</label>
                        <textarea id="description" name="description" required 
                                  placeholder="Provide detailed information about your item..."></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="category">Category *</label>
                            <select id="category" name="category" required onchange="updateSubcategories()">
                                <option value="">Select category...</option>
                                <% for (Category cat : categories) { %>
                                    <option value="<%= cat.getCategoryId() %>"><%= cat.getName() %></option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="subcategory">Subcategory *</label>
                            <select id="subcategory" name="subcategory" required>
                                <option value="">Select category first...</option>
                                <% for (SubCategory sub : subcategories) { %>
                                    <option value="<%= sub.getId() %>" data-category="<%= sub.getCategoryId() %>" style="display:none;">
                                        <%= sub.getName() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="condition">Condition *</label>
                        <select id="condition" name="condition" required>
                            <option value="">Select condition...</option>
                            <option value="New">New</option>
                            <option value="Like New">Like New</option>
                            <option value="Very Good">Very Good</option>
                            <option value="Good">Good</option>
                            <option value="Acceptable">Acceptable</option>
                            <option value="For Parts">For Parts</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3>Auction Settings</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startPrice">Starting Price ($) *</label>
                            <input type="number" id="startPrice" name="startPrice" step="0.01" min="0.01" required 
                                   placeholder="0.00">
                            <small>The initial bidding price</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="reservePrice">Reserve Price ($)</label>
                            <input type="number" id="reservePrice" name="reservePrice" step="0.01" min="0" 
                                   placeholder="Optional">
                            <small>Hidden minimum price (optional)</small>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="bidIncrement">Bid Increment ($) *</label>
                        <input type="number" id="bidIncrement" name="bidIncrement" step="0.01" min="0.01" 
                               value="1.00" required>
                        <small>Minimum amount each bid must increase</small>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startTime">Start Time *</label>
                            <input type="datetime-local" id="startTime" name="startTime" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="endTime">End Time *</label>
                            <input type="datetime-local" id="endTime" name="endTime" required>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="submit-btn">Create Auction</button>
            </form>
        </div>
    </div>
    
    <script>
        function updateSubcategories() {
            var categorySelect = document.getElementById('category');
            var subcategorySelect = document.getElementById('subcategory');
            var selectedCategory = categorySelect.value;
            
            subcategorySelect.value = '';
            
            var options = subcategorySelect.getElementsByTagName('option');
            for (var i = 0; i < options.length; i++) {
                if (options[i].value === '') {
                    options[i].style.display = 'block';
                    options[i].textContent = selectedCategory ? 'Select subcategory...' : 'Select category first...';
                } else {
                    var optionCategory = options[i].getAttribute('data-category');
                    if (optionCategory === selectedCategory) {
                        options[i].style.display = 'block';
                    } else {
                        options[i].style.display = 'none';
                    }
                }
            }
        }
        
        window.onload = function() {
            var now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            document.getElementById('startTime').value = now.toISOString().slice(0,16);
            
            var endTime = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
            document.getElementById('endTime').value = endTime.toISOString().slice(0,16);
        };
    </script>
</body>
</html>
