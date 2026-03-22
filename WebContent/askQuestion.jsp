<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>BidVista - Ask Question</title>
    <%@ include file="components/head.jspf" %>
</head>
<body class="ask-question-page">
    <main class="internal-page-main">
        <div class="container-wide internal-page-content ask-question-content">
            <section class="ask-question-card">
                <h2>Ask a Question</h2>
                <p class="ask-question-subtitle">Our customer service team will respond soon</p>

                <form action="askQuestionProcess.jsp" method="post" class="ask-question-form">
                    <div class="form-group">
                        <textarea
                            name="questionText"
                            placeholder="Type your question here..."
                            required></textarea>
                    </div>

                    <button type="submit" class="ask-question-btn">Submit Question</button>
                </form>

                <p class="ask-question-back-link-wrap">
                    <a href="questions.jsp" class="ask-question-back-link">Back to Q&amp;A</a>
                </p>
            </section>
        </div>
    </main>
</body>
</html>