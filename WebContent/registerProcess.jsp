<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dao.UserDAO" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    
    if (name == null || email == null || password == null || role == null ||
        name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || role.trim().isEmpty()) {
        response.sendRedirect("register.jsp?error=empty");
        return;
    }
    
    UserDAO userDAO = new UserDAO();
    
    if (userDAO.emailExists(email)) {
        response.sendRedirect("register.jsp?error=exists");
        return;
    }
    
    boolean success = userDAO.createUser(name, email, password, role);
    
    if (success) {
        response.sendRedirect("login.jsp?success=registered");
    } else {
        response.sendRedirect("register.jsp?error=invalid");
    }
%>
