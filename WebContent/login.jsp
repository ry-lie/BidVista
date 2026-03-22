<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Auction System - Login</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="auth-page">
    <div class="login-container">
        <div class="login-header">
            <a href="index.jsp" class="login-brand">
		    	<img src="images/logo.png" alt="BidVista logo" class="login-logo">
		    </a>
		    
		    <p>Please log in to continue</p>
		</div>

        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");

            if (error != null) {
                if (error.equals("invalid")) {
        %>
                    <div class="error-message">
                        Invalid email or password. Please try again.
                    </div>
        <%
                } else if (error.equals("empty")) {
        %>
                    <div class="error-message">
                        Please enter both email and password.
                    </div>
        <%
                }
            }

            if (success != null) {
                if (success.equals("logout")) {
        %>
                    <div class="success-message">
                        You have been successfully logged out.
                    </div>
        <%
                } else if (success.equals("registered")) {
        %>
                    <div class="success-message">
                        Registration successful! Please log in.
                    </div>
        <%
                }
            }
        %>

        <form action="loginProcess.jsp" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Enter your password"
                    required>
            </div>

            <button type="submit" class="login-btn">Login</button>
        </form>

        <div class="footer-text">
            Don't have an account?
            <a href="register.jsp" class="footer-link">Register here</a>
        </div>
    </div>
</body>
</html>