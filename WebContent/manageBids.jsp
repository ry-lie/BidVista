<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
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
<head><title>Manage Bids</title>
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
<h2 style="display:inline">Manage Bids</h2>
<a href="repDashboard.jsp">Back to Dashboard</a>
</div>
<%for(Auction a:auctions){
List<Bid> bids = new BidDAO().getBidHistory(a.getAuctionId());
if(!bids.isEmpty()){%>
<div class="auction">
<h3><%=a.getItem().getTitle()%></h3>
<p>Total Bids: <%=bids.size()%></p>
<%for(Bid b:bids){%>
<div style="padding:10px;border-bottom:1px solid #f0f0f0">
<strong>$<%=String.format("%.2f",b.getAmount())%></strong> by <%=b.getUserName()%>
<a href="deleteBid.jsp?id=<%=b.getBidId()%>&auction=<%=a.getAuctionId()%>" onclick="return confirm('Delete bid?')"><button>Remove</button></a>
</div>
<%}%>
</div>
<%}}%>
</div>
</body>
</html>
