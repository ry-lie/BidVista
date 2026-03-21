<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("customer_representative")) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int auctionId = Integer.parseInt(request.getParameter("id"));
new AuctionDAO().deleteAuction(auctionId);
response.sendRedirect("manageAuctions.jsp");
%>
