<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.isAdmin()) {
    response.sendRedirect("dashboard.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Create Customer Rep</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="create-rep-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content create-rep-content">
            <section class="create-rep-card">
                <h2>Create Customer Representative</h2>

                <% if (request.getParameter("success") != null) { %>
                    <div class="create-rep-success-message">
                        Representative created successfully!
                    </div>
                <% } %>

                <form action="createRepProcess.jsp" method="post" class="create-rep-form">
                    <div class="form-group">
                        <label for="repName">Full Name</label>
                        <input type="text" id="repName" name="name" placeholder="Full Name" required>
                    </div>

                    <div class="form-group">
                        <label for="repEmail">Email</label>
                        <input type="email" id="repEmail" name="email" placeholder="Email" required>
                    </div>

                    <div class="form-group">
                        <label for="repPassword">Password</label>
                        <input type="password" id="repPassword" name="password" placeholder="Password" required>
                    </div>

                    <button type="submit" class="create-rep-btn">Create Representative</button>
                </form>

                <p class="create-rep-back-link-wrap">
                    <a href="adminDashboard.jsp" class="create-rep-back-link">Back to Admin Dashboard</a>
                </p>
            </section>
        </div>
    </main>
</body>
</html>