<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.AlertDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
String keywords = request.getParameter("keywords");
String subcategoryIdStr = request.getParameter("subcategoryId");
String minPriceStr = request.getParameter("minPrice");
String maxPriceStr = request.getParameter("maxPrice");
Integer subcategoryId = (subcategoryIdStr != null && !subcategoryIdStr.isEmpty()) ? Integer.parseInt(subcategoryIdStr) : null;
BigDecimal minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? new BigDecimal(minPriceStr) : null;
BigDecimal maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? new BigDecimal(maxPriceStr) : null;
new AlertDAO().createAlert(user.getUserId(), subcategoryId, keywords, minPrice, maxPrice);
response.sendRedirect("myAlerts.jsp");
%>
