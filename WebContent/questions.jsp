<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.QuestionDAO" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
QuestionDAO questionDAO = new QuestionDAO();
String keyword = request.getParameter("keyword");
List<Question> questions = (keyword != null && !keyword.trim().isEmpty()) ?
    questionDAO.searchQuestions(keyword) : questionDAO.getAllQuestions();
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Questions & Answers</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="questions-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content">
            <section class="internal-page-header">
                <div class="internal-page-title">Questions &amp; Answers</div>

                <nav class="internal-page-links">
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="askQuestion.jsp">Ask Question</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </section>

            <section class="questions-search-card">
                <form method="get" class="questions-search-form">
                    <input
                        type="text"
                        name="keyword"
                        placeholder="Search questions..."
                        value="<%= keyword != null ? keyword : "" %>">
                    <button type="submit" class="questions-search-btn">Search</button>
                </form>
            </section>

            <% if (questions.isEmpty()) { %>
                <div class="questions-empty-state">
                    No questions found.
                </div>
            <% } else { %>
                <div class="questions-list">
                    <% for (Question q : questions) { %>
                        <article class="question-card">
                            <span class="question-status-badge <%= q.getStatus() %>">
                                <%= q.getStatus().toUpperCase() %>
                            </span>

                            <p class="question-text">
                                <strong>Q:</strong> <%= q.getQuestionText() %>
                            </p>

                            <p class="question-meta">
                                Asked by <%= q.getUserName() %> on
                                <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(q.getCreatedAt()) %>
                            </p>

                            <% if (q.getAnswerText() != null) { %>
                                <div class="question-answer-box">
                                    <p class="answer-text">
                                        <strong>A:</strong> <%= q.getAnswerText() %>
                                    </p>
                                    <p class="answer-meta">
                                        Answered by <%= q.getAnsweredByName() %>
                                    </p>
                                </div>
                            <% } %>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>
</body>
</html>