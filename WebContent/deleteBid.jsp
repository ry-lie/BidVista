<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.BidDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("customer_representative")) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int bidId = Integer.parseInt(request.getParameter("id"));
new BidDAO().deleteBid(bidId);
response.sendRedirect("manageBids.jsp");
%>
