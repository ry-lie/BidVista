<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.QuestionDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("customer_representative")) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int questionId = Integer.parseInt(request.getParameter("questionId"));
String answerText = request.getParameter("answerText");
new QuestionDAO().answerQuestion(questionId, user.getUserId(), answerText);
response.sendRedirect("repDashboard.jsp");
%>
