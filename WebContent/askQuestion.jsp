<%@ page import="com.auction.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head><title>Ask Question</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:700px;margin:0 auto}
.form{background:white;padding:30px;border-radius:5px}
textarea{width:100%;padding:12px;border:2px solid #e0e0e0;border-radius:5px;min-height:150px;font-family:inherit}
button{width:100%;padding:15px;background:#667eea;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:15px}
</style>
</head>
<body>
<div class="container">
<div class="form">
<h2>Ask a Question</h2>
<p style="color:#666">Our customer service team will respond soon</p>
<form action="askQuestionProcess.jsp" method="post">
<textarea name="questionText" placeholder="Type your question here..." required></textarea>
<button type="submit">Submit Question</button>
</form>
<p style="text-align:center;margin-top:20px"><a href="questions.jsp" style="color:#667eea">Back to Q&A</a></p>
</div>
</div>
</body>
</html>
