<%@ page import="com.auction.model.User" %>
<%@ page import="com.auction.dao.QuestionDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
String questionText = request.getParameter("questionText");
if (questionText != null && !questionText.trim().isEmpty()) {
    new QuestionDAO().createQuestion(user.getUserId(), questionText);
    response.sendRedirect("questions.jsp");
} else {
    response.sendRedirect("askQuestion.jsp");
}
%>
