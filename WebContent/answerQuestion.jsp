<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.QuestionDAO" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("customer_representative")) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
int qid = Integer.parseInt(request.getParameter("id"));
%>
<!DOCTYPE html>
<html>
<head><title>Answer Question</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:700px;margin:0 auto}
.form{background:white;padding:30px;border-radius:5px}
textarea{width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:5px;min-height:150px;font-family:inherit}
button{width:100%;padding:15px;background:#28a745;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:15px}
</style>
</head>
<body>
<div class="container">
<div class="form">
<h2>Answer Question</h2>
<form action="answerQuestionProcess.jsp" method="post">
<input type="hidden" name="questionId" value="<%=qid%>">
<textarea name="answerText" placeholder="Type your answer here..." required></textarea>
<button type="submit">Submit Answer</button>
</form>
<p style="text-align:center;margin-top:20px"><a href="repDashboard.jsp" style="color:#28a745">Back to Dashboard</a></p>
</div>
</div>
</body>
</html>
