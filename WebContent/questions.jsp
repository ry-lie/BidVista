<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.QuestionDAO" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
QuestionDAO questionDAO = new QuestionDAO();
String keyword = request.getParameter("keyword");
List<Question> questions = (keyword != null && !keyword.trim().isEmpty()) ? 
    questionDAO.searchQuestions(keyword) : questionDAO.getAllQuestions();
%>
<!DOCTYPE html>
<html>
<head><title>Questions & Answers</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1000px;margin:0 auto}
.nav{background:#667eea;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.search{background:white;padding:20px;margin-bottom:20px;border-radius:5px}
.search input{padding:10px;width:70%;border:2px solid #e0e0e0;border-radius:5px}
.search button{padding:10px 20px;background:#667eea;color:white;border:none;border-radius:5px;cursor:pointer}
.question{background:white;padding:20px;margin-bottom:15px;border-radius:5px;border-left:4px solid #667eea}
.answer{background:#f9f9f9;padding:15px;margin-top:10px;border-radius:5px}
.status{padding:3px 10px;border-radius:3px;font-size:12px;display:inline-block}
.pending{background:#fff3cd;color:#856404}
.answered{background:#d4edda;color:#155724}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">Questions & Answers</h2>
<a href="dashboard.jsp">Dashboard</a>
<a href="askQuestion.jsp">Ask Question</a>
</div>
<div class="search">
<form method="get">
<input type="text" name="keyword" placeholder="Search questions..." value="<%=keyword!=null?keyword:""%>">
<button type="submit">Search</button>
</form>
</div>
<%if(questions.isEmpty()){%>
<p>No questions found.</p>
<%}else{ for(Question q:questions){%>
<div class="question">
<span class="status <%=q.getStatus()%>"><%=q.getStatus().toUpperCase()%></span>
<p><strong>Q:</strong> <%=q.getQuestionText()%></p>
<p style="font-size:12px;color:#999">Asked by <%=q.getUserName()%> on <%=new java.text.SimpleDateFormat("MMM dd, yyyy").format(q.getCreatedAt())%></p>
<%if(q.getAnswerText()!=null){%>
<div class="answer">
<p><strong>A:</strong> <%=q.getAnswerText()%></p>
<p style="font-size:12px;color:#999">Answered by <%=q.getAnsweredByName()%></p>
</div>
<%}%>
</div>
<%}}%>
</div>
</body>
</html>
