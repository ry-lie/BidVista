<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.isAdmin()) { response.sendRedirect("dashboard.jsp"); return; }
ReportDAO reportDAO = new ReportDAO();
BigDecimal totalEarnings = reportDAO.getTotalEarnings();
Map<String, BigDecimal> earningsPerType = reportDAO.getEarningsPerItemType();
Map<String, Integer> bestSelling = reportDAO.getBestSellingItems();
Map<String, BigDecimal> bestBuyers = reportDAO.getBestBuyers();
%>
<!DOCTYPE html>
<html>
<head><title>Admin Dashboard</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1200px;margin:0 auto}
.nav{background:#dc3545;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:20px;margin-bottom:30px}
.card{background:white;padding:25px;border-radius:5px}
.card h3{margin-bottom:10px;color:#333}
.stat{font-size:36px;color:#dc3545;font-weight:bold}
.report{background:white;padding:25px;margin-bottom:20px;border-radius:5px}
.report h3{color:#333;margin-bottom:15px}
.report-item{padding:10px;border-bottom:1px solid #f0f0f0;display:flex;justify-content:space-between}
button{padding:10px 20px;background:#dc3545;color:white;border:none;border-radius:5px;cursor:pointer}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">Admin Dashboard</h2>
<a href="dashboard.jsp">Main Dashboard</a>
<a href="createRep.jsp">Create Rep</a>
<a href="manageUsers.jsp">Manage Users</a>
</div>
<div class="cards">
<div class="card">
<h3>Total Earnings</h3>
<div class="stat">$<%=String.format("%.2f",totalEarnings)%></div>
</div>
</div>
<div class="report">
<h3>Earnings by Category</h3>
<%for(Map.Entry<String,BigDecimal> e:earningsPerType.entrySet()){%>
<div class="report-item">
<span><%=e.getKey()%></span>
<strong>$<%=String.format("%.2f",e.getValue())%></strong>
</div>
<%}%>
</div>
<div class="report">
<h3>Best Selling Items</h3>
<%for(Map.Entry<String,Integer> e:bestSelling.entrySet()){%>
<div class="report-item">
<span><%=e.getKey()%></span>
<strong><%=e.getValue()%> bids</strong>
</div>
<%}%>
</div>
<div class="report">
<h3>Top Buyers</h3>
<%for(Map.Entry<String,BigDecimal> e:bestBuyers.entrySet()){%>
<div class="report-item">
<span><%=e.getKey()%></span>
<strong>$<%=String.format("%.2f",e.getValue())%></strong>
</div>
<%}%>
</div>
</div>
</body>
</html>
