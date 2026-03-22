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
List<Auction> auctions = new AuctionDAO().getUserAuctionsAsSeller(user.getUserId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - My Auctions</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="my-auctions-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content">
            <section class="internal-page-header">
                <div class="internal-page-title">My Auctions</div>

                <nav class="internal-page-links">
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="createAuction.jsp">Create New</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </section>

            <% if (request.getParameter("success") != null) { %>
                <div class="my-auctions-success-message">
                    Auction created successfully!
                </div>
            <% } %>

            <% if (auctions.isEmpty()) { %>
                <div class="my-auctions-empty-state">
                    You haven't created any auctions yet.
                </div>
            <% } else { %>
                <div class="my-auctions-list">
                    <% for (Auction a : auctions) { %>
                        <article class="my-auction-card">
                            <div class="my-auction-card-content">
                                <h3><%= a.getItem().getTitle() %></h3>

                                <span class="my-auction-status-badge <%= a.getStatus() %>">
                                    <%= a.getStatus().toUpperCase() %>
                                </span>

                                <p>
                                    Current Bid:
                                    <span class="my-auction-price">$<%= String.format("%.2f", a.getCurrentBid()) %></span>
                                </p>

                                <p>Total Bids: <%= a.getBidCount() %></p>
                                <p>Ends: <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(a.getEndTime()) %></p>

                                <a href="auctionDetails.jsp?id=<%= a.getAuctionId() %>" class="my-auction-view-btn">
                                    View Details
                                </a>
                            </div>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>
</body>
</html>