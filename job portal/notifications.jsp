3<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
String user = (String)session.getAttribute("user");
if(user == null) {
  response.sendRedirect("login.jsp");
  return;
}
%>
<%@ include file="db.jsp" %>
<%
PreparedStatement ps = con.prepareStatement("SELECT * FROM notifications WHERE to_user = ? ORDER BY sent_date DESC");
String email = (String)session.getAttribute("email");
ps.setString(1, email);
ResultSet rs = ps.executeQuery();
%>
<div class="container mt-4">
  <h2 class="mb-4">Notifications</h2>
  <div class="row">
    <% while(rs.next()) { %>
    <div class="col-md-8 mb-4">
      <div class="card shadow">
        <div class="card-body">
          <h5 class="card-title"><%= rs.getString("type").equals("policy") ? "Policy Update" : "Rule Change" %></h5>
          <p class="card-text"><%= rs.getString("message") %></p>
          <small class="text-muted">Sent: <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(rs.getTimestamp("sent_date")) %></small>
          <% if(!rs.getBoolean("is_read")) { %>
          <span class="badge bg-primary ms-2">New</span>
          <% } %>
        </div>
      </div>
    </div>
    <% } rs.close(); ps.close(); %>
  </div>
  <% if(!rs.wasNull()) { %>
  <p class="text-muted">No notifications.</p>
  <% } %>
  <a href="<%= session.getAttribute("role").equals("company") ? "company.jsp" : "seeker.jsp" %>" class="btn btn-primary">Back to Dashboard</a>
</div>
<%@ include file="footer.jsp" %>

