<%@ page import="com.auction.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.isAdmin()) { response.sendRedirect("dashboard.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head><title>Create Customer Rep</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:600px;margin:0 auto}
.form{background:white;padding:30px;border-radius:5px}
input{width:100%;padding:12px;margin:10px 0;border:2px solid #e0e0e0;border-radius:5px}
button{width:100%;padding:15px;background:#dc3545;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:10px}
</style>
</head>
<body>
<div class="container">
<div class="form">
<h2>Create Customer Representative</h2>
<%if(request.getParameter("success")!=null){%>
<div style="background:#d4edda;padding:15px;margin-bottom:15px;border-radius:5px;color:#155724">Representative created successfully!</div>
<%}%>
<form action="createRepProcess.jsp" method="post">
<input type="text" name="name" placeholder="Full Name" required>
<input type="email" name="email" placeholder="Email" required>
<input type="password" name="password" placeholder="Password" required>
<button type="submit">Create Representative</button>
</form>
<p style="text-align:center;margin-top:20px"><a href="adminDashboard.jsp" style="color:#dc3545">Back to Admin Dashboard</a></p>
</div>
</div>
</body>
</html>
