<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.model.Auction" %>
<%@ page import="com.auction.dao.ItemDAO" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String subcategoryStr = request.getParameter("subcategory");
    String condition = request.getParameter("condition");
    String startPriceStr = request.getParameter("startPrice");
    String reservePriceStr = request.getParameter("reservePrice");
    String bidIncrementStr = request.getParameter("bidIncrement");
    String startTimeStr = request.getParameter("startTime");
    String endTimeStr = request.getParameter("endTime");
    
    if (title == null || description == null || subcategoryStr == null || condition == null ||
        startPriceStr == null || bidIncrementStr == null || startTimeStr == null || endTimeStr == null ||
        title.trim().isEmpty() || description.trim().isEmpty() || condition.trim().isEmpty()) {
        response.sendRedirect("createAuction.jsp?error=empty");
        return;
    }
    
    try {
        int subcategoryId = Integer.parseInt(subcategoryStr);
        BigDecimal startPrice = new BigDecimal(startPriceStr);
        BigDecimal reservePrice = null;
        if (reservePriceStr != null && !reservePriceStr.trim().isEmpty()) {
            reservePrice = new BigDecimal(reservePriceStr);
        }
        BigDecimal bidIncrement = new BigDecimal(bidIncrementStr);
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Timestamp startTime = new Timestamp(sdf.parse(startTimeStr).getTime());
        Timestamp endTime = new Timestamp(sdf.parse(endTimeStr).getTime());
        
        if (endTime.before(startTime)) {
            response.sendRedirect("createAuction.jsp?error=dates");
            return;
        }
        
        ItemDAO itemDAO = new ItemDAO();
        int itemId = itemDAO.createItem(title, description, condition, subcategoryId);
        
        if (itemId == -1) {
            response.sendRedirect("createAuction.jsp?error=failed");
            return;
        }
        
        Auction auction = new Auction();
        auction.setItemId(itemId);
        auction.setStartPrice(startPrice);
        auction.setReservePrice(reservePrice);
        auction.setStartTime(startTime);
        auction.setEndTime(endTime);
        auction.setBidIncrement(bidIncrement);
        
        AuctionDAO auctionDAO = new AuctionDAO();
        int auctionId = auctionDAO.createAuction(auction, user.getUserId());
        
        if (auctionId > 0) {
            response.sendRedirect("myAuctions.jsp?success=created");
        } else {
            response.sendRedirect("createAuction.jsp?error=failed");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("createAuction.jsp?error=invalid");
    }
%>
