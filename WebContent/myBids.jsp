<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
List<Auction> auctions = new AuctionDAO().getUserAuctionsAsBidder(user.getUserId());
%>
<!DOCTYPE html>
<html>
<head><title>My Bids</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1200px;margin:0 auto}
.nav{background:#667eea;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.auction{background:white;padding:20px;margin-bottom:15px;border-radius:5px}
.price{font-size:20px;color:#667eea;font-weight:bold}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">My Bids</h2>
<a href="dashboard.jsp">Dashboard</a>
<a href="browseAuctions.jsp">Browse Auctions</a>
</div>
<% if(auctions.isEmpty()){%>
<p>You haven't placed any bids yet.</p>
<%}else{ for(Auction a:auctions){%>
<div class="auction">
<h3><%=a.getItem().getTitle()%></h3>
<p>Current Bid: <span class="price">$<%=String.format("%.2f",a.getCurrentBid())%></span></p>
<p>Total Bids: <%=a.getBidCount()%></p>
<p>Status: <%=a.getStatus()%></p>
<p>Ends: <%=new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(a.getEndTime())%></p>
<a href="auctionDetails.jsp?id=<%=a.getAuctionId()%>" style="color:#667eea;font-weight:bold">View Auction</a>
</div>
<%}}%>
</div>
</body>
</html>
