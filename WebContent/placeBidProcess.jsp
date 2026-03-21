<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.model.Auction" %>
<%@ page import="com.auction.dao.AuctionDAO" %>
<%@ page import="com.auction.dao.BidDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String auctionIdStr = request.getParameter("auctionId");
    String bidType = request.getParameter("bidType");
    
    if (auctionIdStr == null || bidType == null) {
        response.sendRedirect("browseAuctions.jsp");
        return;
    }
    
    int auctionId = Integer.parseInt(auctionIdStr);
    
    AuctionDAO auctionDAO = new AuctionDAO();
    BidDAO bidDAO = new BidDAO();
    
    Auction auction = auctionDAO.getAuctionById(auctionId);
    if (auction == null) {
        response.sendRedirect("browseAuctions.jsp");
        return;
    }
    
    if (user.getUserId() == auction.getSellerId()) {
        response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&error=owner");
        return;
    }
    
    if (bidType.equals("manual")) {
        String amountStr = request.getParameter("amount");
        if (amountStr == null || amountStr.isEmpty()) {
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&error=invalid");
            return;
        }
        
        BigDecimal amount = new BigDecimal(amountStr);
        BigDecimal minBid = auction.getCurrentBid().add(auction.getBidIncrement());
        
        if (amount.compareTo(minBid) < 0) {
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&error=low");
            return;
        }
        
        boolean success = bidDAO.placeBid(auctionId, user.getUserId(), amount);
        
        if (success) {
            bidDAO.processAutoBids(auctionId);
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&success=bid");
        } else {
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&error=failed");
        }
    } else if (bidType.equals("auto")) {
        String maxAmountStr = request.getParameter("maxAmount");
        if (maxAmountStr == null || maxAmountStr.isEmpty()) {
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&error=invalid");
            return;
        }
        
        BigDecimal maxAmount = new BigDecimal(maxAmountStr);
        boolean success = bidDAO.setAutoBid(auctionId, user.getUserId(), maxAmount);
        
        if (success) {
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&success=auto");
        } else {
            response.sendRedirect("auctionDetails.jsp?id=" + auctionId + "&error=failed");
        }
    } else {
        response.sendRedirect("auctionDetails.jsp?id=" + auctionId);
    }
%>
