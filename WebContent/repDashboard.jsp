<%@ page import="com.auction.model.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("customer_representative")) { 
    response.sendRedirect("dashboard.jsp"); return; 
}
List<Question> pending = new QuestionDAO().getPendingQuestions();
List<User> users = new UserDAO().getAllUsers();
%>
<!DOCTYPE html>
<html>
<head><title>Customer Rep Dashboard</title>
<style>
body{font-family:Arial;background:#f5f5f5;margin:0;padding:20px}
.container{max-width:1200px;margin:0 auto}
.nav{background:#28a745;color:white;padding:15px;margin-bottom:20px;border-radius:5px}
.nav a{color:white;text-decoration:none;margin-right:15px}
.card{background:white;padding:25px;margin-bottom:20px;border-radius:5px}
.question{padding:15px;border-bottom:1px solid #f0f0f0}
button{padding:8px 15px;background:#28a745;color:white;border:none;border-radius:5px;cursor:pointer}
</style>
</head>
<body>
<div class="container">
<div class="nav">
<h2 style="display:inline">Customer Rep Dashboard</h2>
<a href="dashboard.jsp">Main Dashboard</a>
<a href="manageUsers.jsp">Manage Users</a>
<a href="manageBids.jsp">Manage Bids</a>
<a href="manageAuctions.jsp">Manage Auctions</a>
</div>
<div class="card">
<h3>Pending Questions (<%=pending.size()%>)</h3>
<%if(pending.isEmpty()){%>
<p>No pending questions</p>
<%}else{ for(Question q:pending){%>
<div class="question">
<p><strong>From:</strong> <%=q.getUserName()%></p>
<p><%=q.getQuestionText()%></p>
<a href="answerQuestion.jsp?id=<%=q.getQuestionId()%>"><button>Answer</button></a>
</div>
<%}}%>
</div>
<div class="card">
<h3>User Management</h3>
<p>Total Users: <strong><%=users.size()%></strong></p>
<a href="manageUsers.jsp"><button>Manage All Users</button></a>
</div>
</div>
</body>
</html>
