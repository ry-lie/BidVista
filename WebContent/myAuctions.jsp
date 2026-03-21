<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
List<Auction> auctions = new AuctionDAO().getUserAuctionsAsSeller(user.getUserId());
%>
<!DOCTYPE html>
<html>
<head><title>My Auctions</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1200px;margin:0 auto}
.nav{background:#667eea;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.auction{background:white;padding:20px;margin-bottom:15px;border-radius:5px}
.price{font-size:24px;color:#667eea;font-weight:bold}
.status{padding:5px 10px;border-radius:3px;display:inline-block;font-size:12px}
.active{background:#e8f5e9;color:#2e7d32}
.closed{background:#ffebee;color:#c62828}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">My Auctions</h2>
<a href="dashboard.jsp">Dashboard</a>
<a href="createAuction.jsp">Create New</a>
</div>
<% if(request.getParameter("success")!=null){%>
<div style="background:#e8f5e9;padding:15px;border-radius:5px;margin-bottom:15px">Auction created successfully!</div>
<%}%>
<% if(auctions.isEmpty()){%>
<p>You haven't created any auctions yet.</p>
<%}else{ for(Auction a:auctions){%>
<div class="auction">
<h3><%=a.getItem().getTitle()%></h3>
<span class="status <%=a.getStatus()%>"><%=a.getStatus().toUpperCase()%></span>
<p>Current Bid: <span class="price">$<%=String.format("%.2f",a.getCurrentBid())%></span></p>
<p>Total Bids: <%=a.getBidCount()%></p>
<p>Ends: <%=new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(a.getEndTime())%></p>
<a href="auctionDetails.jsp?id=<%=a.getAuctionId()%>" style="color:#667eea">View Details</a>
</div>
<%}}%>
</div>
</body>
</html>
