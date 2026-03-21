<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null || (!currentUser.isAdmin() && !currentUser.getRole().equals("customer_representative"))) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int userId = Integer.parseInt(request.getParameter("id"));
User editUser = new UserDAO().getUserById(userId);
%>
<!DOCTYPE html>
<html>
<head><title>Edit User</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:600px;margin:0 auto}
.form{background:white;padding:30px;border-radius:5px}
input,select{width:100%;padding:12px;margin:10px 0;border:2px solid #e0e0e0;border-radius:5px}
button{width:100%;padding:15px;background:#28a745;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer}
</style>
</head>
<body>
<div class="container">
<div class="form">
<h2>Edit User</h2>
<form action="editUserProcess.jsp" method="post">
<input type="hidden" name="userId" value="<%=editUser.getUserId()%>">
<input type="text" name="name" value="<%=editUser.getName()%>" required>
<input type="email" name="email" value="<%=editUser.getEmail()%>" required>
<select name="role" required>
<option value="buyer" <%="buyer".equals(editUser.getRole())?"selected":""%>>Buyer</option>
<option value="seller" <%="seller".equals(editUser.getRole())?"selected":""%>>Seller</option>
<option value="buyer_seller" <%="buyer_seller".equals(editUser.getRole())?"selected":""%>>Buyer & Seller</option>
</select>
<button type="submit">Update User</button>
</form>
<p style="text-align:center;margin-top:20px"><a href="manageUsers.jsp" style="color:#28a745">Cancel</a></p>
</div>
</div>
</body>
</html>
