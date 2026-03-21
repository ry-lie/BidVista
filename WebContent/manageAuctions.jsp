<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("customer_representative")) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
List<Auction> auctions = new AuctionDAO().getAllActiveAuctions();
%>
<!DOCTYPE html>
<html>
<head><title>Manage Auctions</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1200px;margin:0 auto}
.nav{background:#28a745;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.auction{background:white;padding:20px;margin-bottom:15px;border-radius:5px}
button{padding:8px 15px;background:#dc3545;color:white;border:none;border-radius:5px;cursor:pointer}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">Manage Auctions</h2>
<a href="repDashboard.jsp">Back to Dashboard</a>
</div>
<%for(Auction a:auctions){%>
<div class="auction">
<h3><%=a.getItem().getTitle()%></h3>
<p>Seller: <%=a.getSellerName()%></p>
<p>Current Bid: $<%=String.format("%.2f",a.getCurrentBid())%></p>
<p>Bids: <%=a.getBidCount()%></p>
<a href="deleteAuction.jsp?id=<%=a.getAuctionId()%>" onclick="return confirm('Delete auction?')"><button>Remove Auction</button></a>
</div>
<%}%>
</div>
</body>
</html>
