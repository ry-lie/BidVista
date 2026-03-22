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
    <title><%= auction.getItem().getTitle() %> - BidVista</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="auction-details-page">
    <header class="auction-details-navbar">
        <div class="container-wide auction-details-navbar-inner">
            <div class="auction-details-navbar-title">Auction Details</div>
            <nav class="auction-details-navbar-links">
                <a href="browseAuctions.jsp">Browse</a>
                <a href="dashboard.jsp">Dashboard</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>

    <main class="auction-details-main">
        <div class="container-wide auction-details-layout">
            <section class="auction-details-main-card">
                <h1 class="auction-item-title"><%= auction.getItem().getTitle() %></h1>

                <div class="auction-category-badge">
                    <%= auction.getItem().getCategoryName() %> &gt; <%= auction.getItem().getSubcategoryName() %>
                </div>

                <div class="auction-price-label">Current Bid</div>
                <div class="auction-current-price">$<%= String.format("%.2f", auction.getCurrentBid()) %></div>

                <div class="auction-stats">
                    <div class="auction-stat">
                        <div class="auction-stat-value"><%= auction.getBidCount() %></div>
                        <div class="auction-stat-label">Total Bids</div>
                    </div>
                    <div class="auction-stat">
                        <div class="auction-stat-value">$<%= String.format("%.2f", auction.getBidIncrement()) %></div>
                        <div class="auction-stat-label">Bid Increment</div>
                    </div>
                    <div class="auction-stat">
                        <div class="auction-stat-value">
                            <%= new java.text.SimpleDateFormat("MMM dd").format(auction.getEndTime()) %>
                        </div>
                        <div class="auction-stat-label">End Date</div>
                    </div>
                </div>

                <div class="auction-description">
                    <h3>Description</h3>
                    <p><%= auction.getItem().getDescription() %></p>
                </div>

                <div class="auction-info-row">
                    <span class="auction-info-label">Condition</span>
                    <span class="auction-info-value"><%= auction.getItem().getCondition() %></span>
                </div>

                <div class="auction-info-row">
                    <span class="auction-info-label">Seller</span>
                    <span class="auction-info-value"><%= auction.getSellerName() %></span>
                </div>

                <div class="auction-info-row">
                    <span class="auction-info-label">Start Time</span>
                    <span class="auction-info-value">
                        <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getStartTime()) %>
                    </span>
                </div>

                <div class="auction-info-row">
                    <span class="auction-info-label">End Time</span>
                    <span class="auction-info-value">
                        <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getEndTime()) %>
                    </span>
                </div>
            </section>

            <aside class="auction-details-sidebar">
                <div class="auction-side-card">
                    <h3>Place Bid</h3>

                    <% if (success != null) { %>
                        <% if (success.equals("bid")) { %>
                            <div class="success-message">Bid placed successfully!</div>
                        <% } else if (success.equals("auto")) { %>
                            <div class="success-message">Automatic bidding enabled!</div>
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
                                <input type="number" name="amount" step="0.01" min="<%= minBid %>" value="<%= minBid %>" required>
                                <div class="auction-min-bid-info">Minimum bid: $<%= String.format("%.2f", minBid) %></div>
                            </div>

                            <button type="submit" name="bidType" value="manual" class="auction-bid-btn">Place Bid</button>
                        </form>

                        <hr class="auction-divider">

                        <% if (userAutoBid != null) { %>
                            <div class="auction-autobid-status">
                                <strong>Auto-Bid Active</strong><br>
                                Max Amount: $<%= String.format("%.2f", userAutoBid.getMaxAmount()) %>
                            </div>
                        <% } %>

                        <form action="placeBidProcess.jsp" method="post">
                            <input type="hidden" name="auctionId" value="<%= auctionId %>">

                            <div class="form-group">
                                <label>Maximum Auto-Bid Amount</label>
                                <input type="number" name="maxAmount" step="0.01" min="<%= minBid %>" value="<%= userAutoBid != null ? userAutoBid.getMaxAmount() : minBid %>" required>
                                <div class="auction-min-bid-info">System will bid up to this amount automatically</div>
                            </div>

                            <button type="submit" name="bidType" value="auto" class="auction-bid-btn">
                                <%= userAutoBid != null ? "Update" : "Enable" %> Auto-Bid
                            </button>
                        </form>
                    <% } else { %>
                        <div class="error-message">
                            This is your auction. You cannot place bids.
                        </div>
                    <% } %>
                </div>

                <div class="auction-side-card">
                    <h3>Bid History (<%= bidHistory.size() %>)</h3>
                    <div class="auction-bid-history">
                        <% if (bidHistory.isEmpty()) { %>
                            <p class="auction-empty-history">No bids yet. Be the first!</p>
                        <% } else { %>
                            <% for (Bid bid : bidHistory) { %>
                                <div class="auction-bid-item">
                                    <div>
                                        <div class="auction-bid-amount">$<%= String.format("%.2f", bid.getAmount()) %></div>
                                        <div class="auction-bid-user"><%= bid.getUserName() %></div>
                                    </div>
                                    <div class="auction-bid-time">
                                        <%= new java.text.SimpleDateFormat("MMM dd, HH:mm").format(bid.getBidTime()) %>
                                    </div>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>

                <% if (!similarAuctions.isEmpty()) { %>
                    <div class="auction-side-card">
                        <h3>Similar Items</h3>
                        <% for (Auction similar : similarAuctions) { %>
                            <div class="auction-similar-item">
                                <h4><%= similar.getItem().getTitle() %></h4>
                                <p>Current Bid: $<%= String.format("%.2f", similar.getCurrentBid()) %></p>
                                <a href="auctionDetails.jsp?id=<%= similar.getAuctionId() %>">View Auction →</a>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </aside>
        </div>
    </main>
</body>
</html>