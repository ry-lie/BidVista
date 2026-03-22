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

    String roleLabel = user.isAdmin() ? "ADMIN" : user.getRole().toUpperCase();
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Dashboard</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="dashboard-page">
    <header class="site-header">
        <div class="container-wide navbar">
            <a href="index.jsp" class="nav-logo">
                <img src="images/simpleLogo.png" alt="BidVista logo" class="nav-logo-icon">
                <span>BidVista</span>
            </a>

            <div class="dashboard-nav-right">
			    <div class="dashboard-user-group">
			        <span class="dashboard-user-text">Welcome, <%= user.getName() %></span>
			        <span class="dashboard-role-badge"><%= roleLabel %></span>
			    </div>
			    <a href="logout.jsp" class="btn btn-primary dashboard-logout-btn">Logout</a>
			</div>
        </div>
    </header>

    <section class="dashboard-hero" style="background-image: url('https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&w=1600&q=80');">
        <div class="hero-overlay"></div>

        <div class="container-wide dashboard-hero-inner">
            <div class="dashboard-hero-content">
                <div class="dashboard-hero-left">
                    <h1 class="dashboard-title">Auction smarter. Manage everything in one place.</h1>
                </div>

                <div class="dashboard-hero-right">
                    <p class="dashboard-subtitle">
                        Browse active listings, track your bids, manage alerts, and access your account tools through your personalized dashboard.
                    </p>
                </div>
            </div>

            <div class="dashboard-cards-section">
                <div class="dashboard-cards-header">
                    <h2 class="dashboard-cards-title">Your dashboard tools</h2>

                    <div class="dashboard-carousel-controls">
                        <button type="button" class="dashboard-arrow" id="dashScrollLeft" aria-label="Scroll left">&#8249;</button>
                        <button type="button" class="dashboard-arrow" id="dashScrollRight" aria-label="Scroll right">&#8250;</button>
                    </div>
                </div>

                <div class="dashboard-cards-track" id="dashboardCardsTrack">
                    <div class="dashboard-card">
                        <h3>Browse Auctions</h3>
                        <p>Search and bid on active auctions</p>
                        <a href="browseAuctions.jsp" class="dashboard-card-btn">Browse Now</a>
                    </div>

                    <% if (user.getRole().contains("seller") || user.getRole().equals("buyer_seller")) { %>
                    <div class="dashboard-card">
                        <h3>Create Auction</h3>
                        <p>List a new item for auction</p>
                        <a href="createAuction.jsp" class="dashboard-card-btn">Create Auction</a>
                    </div>

                    <div class="dashboard-card">
                        <h3>My Auctions</h3>
                        <div class="dashboard-stat"><%= myAuctionsCount %></div>
                        <p>Manage your active listings</p>
                        <a href="myAuctions.jsp" class="dashboard-card-btn">View My Auctions</a>
                    </div>
                    <% } %>

                    <div class="dashboard-card">
                        <h3>My Bids</h3>
                        <div class="dashboard-stat"><%= myBidsCount %></div>
                        <p>Track your bidding activity</p>
                        <a href="myBids.jsp" class="dashboard-card-btn">View My Bids</a>
                    </div>

                    <div class="dashboard-card">
                        <h3>My Alerts</h3>
                        <p>Manage item notifications</p>
                        <a href="myAlerts.jsp" class="dashboard-card-btn">Manage Alerts</a>
                    </div>

                    <div class="dashboard-card">
                        <h3>Questions & Answers</h3>
                        <p>Browse customer service Q&amp;A</p>
                        <a href="questions.jsp" class="dashboard-card-btn">View Q&amp;A</a>
                    </div>

                    <% if (user.isAdmin()) { %>
                    <div class="dashboard-card">
                        <h3>Admin Dashboard</h3>
                        <p>Manage users and view reports</p>
                        <a href="adminDashboard.jsp" class="dashboard-card-btn">Admin Panel</a>
                    </div>
                    <% } %>

                    <% if (user.getRole().equals("customer_representative")) { %>
                    <div class="dashboard-card">
                        <h3>Customer Rep Dashboard</h3>
                        <p>Manage users and answer questions</p>
                        <a href="repDashboard.jsp" class="dashboard-card-btn">Rep Panel</a>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </section>

    <script>
        const track = document.getElementById("dashboardCardsTrack");
        const scrollLeftBtn = document.getElementById("dashScrollLeft");
        const scrollRightBtn = document.getElementById("dashScrollRight");

        if (track && scrollLeftBtn && scrollRightBtn) {
            const scrollAmount = 340;

            scrollLeftBtn.addEventListener("click", function () {
                track.scrollBy({ left: -scrollAmount, behavior: "smooth" });
            });

            scrollRightBtn.addEventListener("click", function () {
                track.scrollBy({ left: scrollAmount, behavior: "smooth" });
            });
        }
    </script>
</body>
</html>