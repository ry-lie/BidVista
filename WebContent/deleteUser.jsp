<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || (!user.isAdmin() && !user.getRole().equals("customer_representative"))) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int userId = Integer.parseInt(request.getParameter("id"));
new UserDAO().deleteUser(userId);
response.sendRedirect("manageUsers.jsp");
%>
