<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null || (!currentUser.isAdmin() && !currentUser.getRole().equals("customer_representative"))) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int userId = Integer.parseInt(request.getParameter("userId"));
String name = request.getParameter("name");
String email = request.getParameter("email");
String role = request.getParameter("role");
new UserDAO().updateUser(userId, name, email, role);
response.sendRedirect("manageUsers.jsp");
%>
