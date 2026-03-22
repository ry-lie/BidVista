<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || (!user.isAdmin() && !user.getRole().equals("customer_representative"))) {
    response.sendRedirect("dashboard.jsp");
    return;
}
List<User> users = new UserDAO().getAllUsers();
String backUrl = user.isAdmin() ? "adminDashboard.jsp" : "repDashboard.jsp";
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Manage Users</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="manage-users-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content">
            <section class="manage-users-header">
                <div class="manage-users-title">Manage Users</div>

                <nav class="manage-users-links">
                    <a href="<%= backUrl %>">Back to Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </section>

            <section class="manage-users-table-card">
                <div class="manage-users-table-wrap">
                    <table class="manage-users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : users) { %>
                                <tr>
                                    <td><%= u.getUserId() %></td>
                                    <td><%= u.getName() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><span class="manage-users-role"><%= u.getRole() %></span></td>
                                    <td>
                                        <div class="manage-users-actions">
                                            <a href="editUser.jsp?id=<%= u.getUserId() %>" class="manage-users-btn edit-btn">Edit</a>
                                            <a href="deleteUser.jsp?id=<%= u.getUserId() %>" class="manage-users-btn delete-btn" onclick="return confirm('Delete this user?')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</body>
</html>