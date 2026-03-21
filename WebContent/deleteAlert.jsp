<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.AlertDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
String idStr = request.getParameter("id");
if (idStr != null) {
    new AlertDAO().deleteAlert(Integer.parseInt(idStr));
}
response.sendRedirect("myAlerts.jsp");
%>
