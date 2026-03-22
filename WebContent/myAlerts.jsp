<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
AlertDAO alertDAO = new AlertDAO();
List<Alert> alerts = alertDAO.getUserAlerts(user.getUserId());
List<SubCategory> subcategories = new ItemDAO().getAllSubCategories();
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - My Alerts</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="my-alerts-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content">
            <section class="internal-page-header">
                <div class="internal-page-title">My Alerts</div>

                <nav class="internal-page-links">
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </section>

            <section class="my-alerts-form-card">
                <h3>Create New Alert</h3>

                <form action="createAlertProcess.jsp" method="post" class="my-alerts-form">
                    <div class="form-group">
                        <label for="keywords">Keywords</label>
                        <input type="text" id="keywords" name="keywords" placeholder="e.g., vintage camera" required>
                    </div>

                    <div class="form-group">
                        <label for="subcategoryId">Category (optional)</label>
                        <select name="subcategoryId" id="subcategoryId">
                            <option value="">Any Category</option>
                            <% for (SubCategory s : subcategories) { %>
                                <option value="<%= s.getId() %>"><%= s.getCategoryName() %> - <%= s.getName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="minPrice">Min Price</label>
                        <input type="number" id="minPrice" name="minPrice" step="0.01" placeholder="0.00">
                    </div>

                    <div class="form-group">
                        <label for="maxPrice">Max Price</label>
                        <input type="number" id="maxPrice" name="maxPrice" step="0.01" placeholder="1000.00">
                    </div>

                    <button type="submit" class="my-alerts-btn">Create Alert</button>
                </form>
            </section>

            <section class="my-alerts-section">
                <h3 class="my-alerts-section-title">Active Alerts</h3>

                <% if (alerts.isEmpty()) { %>
                    <div class="my-alerts-empty-state">
                        No alerts set up yet.
                    </div>
                <% } else { %>
                    <div class="my-alerts-list">
                        <% for (Alert a : alerts) { %>
                            <article class="my-alert-card">
                                <div class="my-alert-card-content">
                                    <p><strong>Keywords:</strong> <%= a.getKeywords() %></p>

                                    <% if (a.getSubcategoryName() != null) { %>
                                        <p><strong>Category:</strong> <%= a.getSubcategoryName() %></p>
                                    <% } %>

                                    <% if (a.getMinPrice() != null) { %>
                                        <p><strong>Min:</strong> $<%= a.getMinPrice() %></p>
                                    <% } %>

                                    <% if (a.getMaxPrice() != null) { %>
                                        <p><strong>Max:</strong> $<%= a.getMaxPrice() %></p>
                                    <% } %>

                                    <a href="deleteAlert.jsp?id=<%= a.getAlertId() %>" class="my-alert-delete-link">Delete</a>
                                </div>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>
        </div>
    </main>
</body>
</html>