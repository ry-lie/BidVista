<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.isAdmin()) {
    response.sendRedirect("dashboard.jsp");
    return;
}
ReportDAO reportDAO = new ReportDAO();
BigDecimal totalEarnings = reportDAO.getTotalEarnings();
Map<String, BigDecimal> earningsPerType = reportDAO.getEarningsPerItemType();
Map<String, Integer> bestSelling = reportDAO.getBestSellingItems();
Map<String, BigDecimal> bestBuyers = reportDAO.getBestBuyers();
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Admin Dashboard</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="admin-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content">
            <section class="admin-page-header">
                <div class="admin-page-title">Admin Dashboard</div>

                <nav class="admin-page-links">
                    <a href="dashboard.jsp">Main Dashboard</a>
                    <a href="createRep.jsp">Create Rep</a>
                    <a href="manageUsers.jsp">Manage Users</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </section>

            <section class="admin-cards">
                <div class="admin-stat-card">
                    <h3>Total Earnings</h3>
                    <div class="admin-stat-value">$<%= String.format("%.2f", totalEarnings) %></div>
                </div>
            </section>

            <section class="admin-report-card">
                <h3>Earnings by Category</h3>
                <% for (Map.Entry<String, BigDecimal> e : earningsPerType.entrySet()) { %>
                    <div class="admin-report-item">
                        <span><%= e.getKey() %></span>
                        <strong>$<%= String.format("%.2f", e.getValue()) %></strong>
                    </div>
                <% } %>
            </section>

            <section class="admin-report-card">
                <h3>Best Selling Items</h3>
                <% for (Map.Entry<String, Integer> e : bestSelling.entrySet()) { %>
                    <div class="admin-report-item">
                        <span><%= e.getKey() %></span>
                        <strong><%= e.getValue() %> bids</strong>
                    </div>
                <% } %>
            </section>

            <section class="admin-report-card">
                <h3>Top Buyers</h3>
                <% for (Map.Entry<String, BigDecimal> e : bestBuyers.entrySet()) { %>
                    <div class="admin-report-item">
                        <span><%= e.getKey() %></span>
                        <strong>$<%= String.format("%.2f", e.getValue()) %></strong>
                    </div>
                <% } %>
            </section>
        </div>
    </main>
</body>
</html>