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
List<Auction> auctions = new AuctionDAO().getUserAuctionsAsBidder(user.getUserId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - My Bids</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="my-bids-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content">
            <section class="internal-page-header">
                <div class="internal-page-title">My Bids</div>

                <nav class="internal-page-links">
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="browseAuctions.jsp">Browse Auctions</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </section>

            <% if (auctions.isEmpty()) { %>
                <div class="my-bids-empty-state">
                    You haven't placed any bids yet.
                </div>
            <% } else { %>
                <div class="my-bids-list">
                    <% for (Auction a : auctions) { %>
                        <article class="my-bid-card">
                            <div class="my-bid-card-content">
                                <h3><%= a.getItem().getTitle() %></h3>

                                <p>
                                    Current Bid:
                                    <span class="my-bid-price">$<%= String.format("%.2f", a.getCurrentBid()) %></span>
                                </p>

                                <p>Total Bids: <%= a.getBidCount() %></p>
                                <p>Status: <span class="my-bid-status"><%= a.getStatus() %></span></p>
                                <p>Ends: <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(a.getEndTime()) %></p>

                                <a href="auctionDetails.jsp?id=<%= a.getAuctionId() %>" class="my-bid-view-btn">
                                    View Auction
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