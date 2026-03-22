<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Register</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="auth-page">
    <div class="register-container">
        <div class="register-header">
            <a href="index.jsp" class="login-brand">
                <img src="images/logo.png" alt="BidVista logo" class="login-logo">
            </a>
            <p>Create an account </p>
        </div>

        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");

            if (error != null) {
                if (error.equals("exists")) {
        %>
                    <div class="error-message">
                        Email already exists. Please use a different email.
                    </div>
        <%
                } else if (error.equals("invalid")) {
        %>
                    <div class="error-message">
                        Registration failed. Please try again.
                    </div>
        <%
                } else if (error.equals("empty")) {
        %>
                    <div class="error-message">
                        Please fill in all fields.
                    </div>
        <%
                }
            }

            if (success != null && success.equals("true")) {
        %>
                <div class="success-message">
                    Registration successful! You can now log in.
                </div>
        <%
            }
        %>

        <form action="registerProcess.jsp" method="post">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required placeholder="Enter your full name">
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="Enter your email">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Create a password">
            </div>

            <div class="form-group">
                <label for="role">I want to</label>
                <select id="role" name="role" required>
                    <option value="">Select role...</option>
                    <option value="buyer">Buy items</option>
                    <option value="seller">Sell items</option>
                    <option value="buyer_seller">Both buy and sell</option>
                </select>
            </div>

            <button type="submit" class="register-btn">Create Account</button>
        </form>

        <div class="footer-text">
            Already have an account?
            <a href="login.jsp" class="footer-link">Log in here</a>
        </div>
    </div>
</body>
</html>