<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dao.UserDAO" %>
<%@ page import="com.auction.model.User" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("login.jsp?error=empty");
        return;
    }
    
    UserDAO userDAO = new UserDAO();
    User user = userDAO.authenticateUser(email, password);
    
    if (user != null) {
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("isAdmin", user.isAdmin());
        
        response.sendRedirect("dashboard.jsp");
    } else {
        response.sendRedirect("login.jsp?error=invalid");
    }
%>
