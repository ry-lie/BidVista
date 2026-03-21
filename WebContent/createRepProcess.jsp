<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.UserDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.isAdmin()) { response.sendRedirect("dashboard.jsp"); return; }
String name = request.getParameter("name");
String email = request.getParameter("email");
String password = request.getParameter("password");
if (new UserDAO().createCustomerRep(name, email, password)) {
    response.sendRedirect("createRep.jsp?success=true");
} else {
    response.sendRedirect("createRep.jsp?error=true");
}
%>
