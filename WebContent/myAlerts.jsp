<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
AlertDAO alertDAO = new AlertDAO();
List<Alert> alerts = alertDAO.getUserAlerts(user.getUserId());
List<SubCategory> subcategories = new ItemDAO().getAllSubCategories();
%>
<!DOCTYPE html>
<html>
<head><title>My Alerts</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:900px;margin:0 auto}
.nav{background:#667eea;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.alert{background:white;padding:20px;margin-bottom:15px;border-radius:5px}
.form{background:white;padding:25px;border-radius:5px;margin-bottom:20px}
input,select{padding:10px;margin:5px 0;width:100%;border:2px solid #e0e0e0;border-radius:5px}
button{padding:12px 20px;background:#667eea;color:white;border:none;border-radius:5px;cursor:pointer;font-weight:bold}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">My Alerts</h2>
<a href="dashboard.jsp">Dashboard</a>
</div>
<div class="form">
<h3>Create New Alert</h3>
<form action="createAlertProcess.jsp" method="post">
<label>Keywords</label>
<input type="text" name="keywords" placeholder="e.g., vintage camera" required>
<label>Category (optional)</label>
<select name="subcategoryId">
<option value="">Any Category</option>
<%for(SubCategory s:subcategories){%>
<option value="<%=s.getId()%>"><%=s.getCategoryName()%> - <%=s.getName()%></option>
<%}%>
</select>
<label>Min Price</label>
<input type="number" name="minPrice" step="0.01" placeholder="0.00">
<label>Max Price</label>
<input type="number" name="maxPrice" step="0.01" placeholder="1000.00">
<button type="submit">Create Alert</button>
</form>
</div>
<h3>Active Alerts</h3>
<% if(alerts.isEmpty()){%>
<p>No alerts set up yet.</p>
<%}else{ for(Alert a:alerts){%>
<div class="alert">
<p><strong>Keywords:</strong> <%=a.getKeywords()%></p>
<%if(a.getSubcategoryName()!=null){%><p><strong>Category:</strong> <%=a.getSubcategoryName()%></p><%}%>
<%if(a.getMinPrice()!=null){%><p><strong>Min:</strong> $<%=a.getMinPrice()%></p><%}%>
<%if(a.getMaxPrice()!=null){%><p><strong>Max:</strong> $<%=a.getMaxPrice()%></p><%}%>
<a href="deleteAlert.jsp?id=<%=a.getAlertId()%>" style="color:#c62828">Delete</a>
</div>
<%}}%>
</div>
</body>
</html>
