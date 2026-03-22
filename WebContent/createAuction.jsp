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
    <title>BidVista - Create Auction</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="create-auction-page">
    <header class="create-auction-navbar">
        <div class="container-wide create-auction-navbar-inner">
            <div class="create-auction-navbar-title">Create New Auction</div>

            <nav class="create-auction-navbar-links">
                <a href="dashboard.jsp">Dashboard</a>
                <a href="browseAuctions.jsp">Browse Auctions</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>

    <main class="create-auction-main">
        <div class="container-wide create-auction-content">
            <section class="create-auction-card">
                <h2>List Your Item</h2>
                <p class="create-auction-subtitle">Fill out the details below to create your auction</p>

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

                <form action="createAuctionProcess.jsp" method="post" class="create-auction-form">
                    <div class="create-auction-section">
                        <h3>Item Information</h3>

                        <div class="form-group">
                            <label for="title">Item Title *</label>
                            <input
                                type="text"
                                id="title"
                                name="title"
                                required
                                placeholder="e.g., Vintage Baseball Card Collection">
                        </div>

                        <div class="form-group">
                            <label for="description">Description *</label>
                            <textarea
                                id="description"
                                name="description"
                                required
                                placeholder="Provide detailed information about your item..."></textarea>
                        </div>

                        <div class="create-auction-form-row">
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

                    <div class="create-auction-section">
                        <h3>Auction Settings</h3>

                        <div class="create-auction-form-row">
                            <div class="form-group">
                                <label for="startPrice">Starting Price ($) *</label>
                                <input
                                    type="number"
                                    id="startPrice"
                                    name="startPrice"
                                    step="0.01"
                                    min="0.01"
                                    required
                                    placeholder="0.00">
                                <small>The initial bidding price</small>
                            </div>

                            <div class="form-group">
                                <label for="reservePrice">Reserve Price ($)</label>
                                <input
                                    type="number"
                                    id="reservePrice"
                                    name="reservePrice"
                                    step="0.01"
                                    min="0"
                                    placeholder="Optional">
                                <small>Hidden minimum price (optional)</small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bidIncrement">Bid Increment ($) *</label>
                            <input
                                type="number"
                                id="bidIncrement"
                                name="bidIncrement"
                                step="0.01"
                                min="0.01"
                                value="1.00"
                                required>
                            <small>Minimum amount each bid must increase</small>
                        </div>

                        <div class="create-auction-form-row">
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

                    <button type="submit" class="create-auction-submit-btn">Create Auction</button>
                </form>
            </section>
        </div>
    </main>

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