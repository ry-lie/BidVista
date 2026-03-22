<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista</title>
    <%@ include file="components/head.jspf" %>
</head>
<body>
    <header class="site-header">
        <div class="container navbar">
            <a href="index.jsp" class="nav-logo">
			    <img src="images/simpleLogo.png" alt="BidVista logo" class="nav-logo-icon">
			    <span>BidVista</span>
			</a>
            <nav class="nav-links">
                <a href="register.jsp">Register</a>
                <a href="login.jsp" class="btn btn-primary">Login</a>
            </nav>
        </div>
    </header>

    <section class="hero" style="background-image: url('https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&w=1600&q=80');">
        <div class="hero-overlay"></div>
        <div class="container hero-content">
            <div>
                <h1 class="hero-title">Auction smarter. Bid with confidence.</h1>
            </div>
            <div>
                <p class="hero-text">
                    Explore curated auctions, set alerts, and manage your bids in one intuitive platform for buyers and sellers.
                </p>
                <div class="hero-actions">
                    <a href="browseAuctions.jsp" class="btn btn-primary">Browse auctions</a>
                    <a href="createAuction.jsp" class="btn btn-secondary">List an item</a>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h2 class="section-title">Discover auctions across categories</h2>
            <p class="section-subtitle">
                Browse listings, place bids, save auctions to your watchlist, and stay updated with alerts for items that match your interests.
            </p>
        </div>
    </section>
</body>
</html>