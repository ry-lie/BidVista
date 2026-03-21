<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || (!user.isAdmin() && !user.getRole().equals("customer_representative"))) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
List<User> users = new UserDAO().getAllUsers();
%>
<!DOCTYPE html>
<html>
<head><title>Manage Users</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1200px;margin:0 auto}
.nav{background:#28a745;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
table{width:100%;background:white;border-collapse:collapse}
th,td{padding:15px;text-align:left;border-bottom:1px solid #e0e0e0}
th{background:#f9f9f9}
button{padding:6px 12px;margin:0 3px;border:none;border-radius:3px;cursor:pointer}
.edit{background:#ffc107;color:white}
.delete{background:#dc3545;color:white}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">Manage Users</h2>
<a href="<%=user.isAdmin()?"adminDashboard.jsp":"repDashboard.jsp"%>">Back to Dashboard</a>
</div>
<table>
<tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Actions</th></tr>
<%for(User u:users){%>
<tr>
<td><%=u.getUserId()%></td>
<td><%=u.getName()%></td>
<td><%=u.getEmail()%></td>
<td><%=u.getRole()%></td>
<td>
<a href="editUser.jsp?id=<%=u.getUserId()%>"><button class="edit">Edit</button></a>
<a href="deleteUser.jsp?id=<%=u.getUserId()%>" onclick="return confirm('Delete this user?')"><button class="delete">Delete</button></a>
</td>
</tr>
<%}%>
</table>
</div>
</body>
</html>
