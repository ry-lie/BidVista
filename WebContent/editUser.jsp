<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null || (!currentUser.isAdmin() && !currentUser.getRole().equals("customer_representative"))) {
    response.sendRedirect("dashboard.jsp");
    return;
}
int userId = Integer.parseInt(request.getParameter("id"));
User editUser = new UserDAO().getUserById(userId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Edit User</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="edit-user-page">
    <main class="internal-page-main">
        <div class="container-wide edit-user-content">
            <section class="edit-user-card">
                <h2>Edit User</h2>

                <form action="editUserProcess.jsp" method="post" class="edit-user-form">
                    <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">

                    <div class="form-group">
                        <label for="editName">Full Name</label>
                        <input type="text" id="editName" name="name" value="<%= editUser.getName() %>" required>
                    </div>

                    <div class="form-group">
                        <label for="editEmail">Email</label>
                        <input type="email" id="editEmail" name="email" value="<%= editUser.getEmail() %>" required>
                    </div>

                    <div class="form-group">
                        <label for="editRole">Role</label>
                        <select id="editRole" name="role" required>
                            <option value="buyer" <%="buyer".equals(editUser.getRole())?"selected":""%>>Buyer</option>
                            <option value="seller" <%="seller".equals(editUser.getRole())?"selected":""%>>Seller</option>
                            <option value="buyer_seller" <%="buyer_seller".equals(editUser.getRole())?"selected":""%>>Buyer &amp; Seller</option>
                        </select>
                    </div>

                    <button type="submit" class="edit-user-btn">Update User</button>
                </form>

                <p class="edit-user-cancel-wrap">
                    <a href="manageUsers.jsp" class="edit-user-cancel-link">Cancel</a>
                </p>
            </section>
        </div>
    </main>
</body>
</html>