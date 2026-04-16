 <%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
String role = (String)session.getAttribute("role");
if(!"admin".equals(role)) {
  response.sendRedirect("index.jsp");
  return;
}
%>
<%@ include file="db.jsp" %>
<%
String action = request.getParameter("action");
if("toggle_status".equals(action)) {
  try {
    int id = Integer.parseInt(request.getParameter("id"));
    String r = request.getParameter("r");
    PreparedStatement ps = con.prepareStatement("UPDATE users SET status = CASE WHEN status='active' THEN 'inactive' ELSE 'active' END WHERE id=? AND role=?");
    ps.setInt(1, id);
    ps.setString(2, r);
    int rows = ps.executeUpdate();
    ps.close();
    if(rows > 0) {
      session.setAttribute("successMsg", "Status toggled!");
    } else {
      session.setAttribute("errorMsg", "No user found!");
    }
  } catch (Exception e) {
    session.setAttribute("errorMsg", "Error: " + e.getMessage());
  }
  response.sendRedirect("admin.jsp#users");
  return;
}
if("delete_job".equals(action)) {
  try {
    int id = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = con.prepareStatement("DELETE FROM jobs WHERE id=?");
    ps.setInt(1, id);
    int rows = ps.executeUpdate();
    ps.close();
    if(rows > 0) {
      session.setAttribute("successMsg", "Job deleted!");
    } else {
      session.setAttribute("errorMsg", "Job not found!");
    }
  } catch (Exception e) {
    session.setAttribute("errorMsg", "Error: " + e.getMessage());
  }
  response.sendRedirect("admin.jsp#jobs");
  return;
}
if("send_notification".equals(action)) {
  try {
    String message = request.getParameter("message");
    String type = request.getParameter("type");
    String target = request.getParameter("target");
    String target_email = request.getParameter("target_email");
    if(message != null && !message.trim().isEmpty()) {
      PreparedStatement ps;
      if("all-seekers".equals(target) || "all-companies".equals(target)) {
        String targetRole = "all-seekers".equals(target) ? "seeker" : "company";
        ps = con.prepareStatement("INSERT INTO notifications (to_user, message, type, sent_date) SELECT email, ?, ?, NOW() FROM users WHERE role=?");
        ps.setString(1, message);
        ps.setString(2, type);
        ps.setString(3, targetRole);
      } else {
        ps = con.prepareStatement("INSERT INTO notifications (to_user, message, type, sent_date) VALUES (?, ?, ?, NOW())");
        ps.setString(1, target_email);
        ps.setString(2, message);
        ps.setString(3, type);
      }
      int rows = ps.executeUpdate();
      ps.close();
      session.setAttribute("successMsg", rows + " notifications sent!");

    } else {
      session.setAttribute("errorMsg", "Message required!");
    }
  } catch (Exception e) {
    session.setAttribute("errorMsg", "Error: " + e.getMessage());
  }
  response.sendRedirect("admin.jsp#notifications");
  return;
}
%>
<div class="container mt-5">

  <%
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) {
      session.removeAttribute("successMsg");
  %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
  <%
    }
    if (errorMsg != null) {
      session.removeAttribute("errorMsg");
  %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= errorMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
  <%
    }
  %>
  <h1 class="mb-4 text-primary"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>

  <!-- Stats -->
  <div class="row mb-5">
    <% 
    ResultSet ru=con.createStatement().executeQuery("SELECT count(*) c FROM users"); ru.next(); int users=ru.getInt("c");
    ResultSet raa=con.createStatement().executeQuery("SELECT count(*) c FROM users WHERE status='active'"); raa.next(); int active_users=raa.getInt("c");
    ResultSet rj=con.createStatement().executeQuery("SELECT count(*) c FROM jobs"); rj.next(); int jobs=rj.getInt("c");
    ResultSet ra=con.createStatement().executeQuery("SELECT count(*) c FROM applications"); ra.next(); int apps=ra.getInt("c");
    ru.close(); raa.close(); rj.close(); ra.close();
    %>
    <div class="col-lg-3 col-md-6">
      <div class="card bg-primary text-white mb-4">
        <div class="card-body">
          <h5><i class="fas fa-users"></i> Total Users</h5>
          <h2><%=users%></h2>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6">
      <div class="card bg-success text-white mb-4">
        <div class="card-body">
          <h5><i class="fas fa-user-check"></i> Active Users</h5>
          <h2><%=active_users%></h2>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6">
      <div class="card bg-info text-white mb-4">
        <div class="card-body">
          <h5><i class="fas fa-briefcase"></i> Total Jobs</h5>
          <h2><%=jobs%></h2>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6">
      <div class="card bg-warning text-dark mb-4">
        <div class="card-body">
          <h5><i class="fas fa-paper-plane"></i> Applications</h5>
          <h2><%=apps%></h2>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Tabs -->
  <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
    <li class="nav-item" role="presentation">
      <button class="nav-link active" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button"><i class="fas fa-users"></i> Manage Users</button>
    </li>
    <li class="nav-item" role="presentation">
      <button class="nav-link" id="jobs-tab" data-bs-toggle="tab" data-bs-target="#jobs" type="button"><i class="fas fa-briefcase"></i> Manage Jobs</button>
    </li>
    <li class="nav-item" role="presentation">
      <button class="nav-link" id="notifications-tab" data-bs-toggle="tab" data-bs-target="#notifications" type="button"><i class="fas fa-bell"></i> Notifications</button>
    </li>
  </ul>
  
  <div class="tab-content">
    <!-- Users Tab -->
    <div class="tab-pane fade show active" id="users" role="tabpanel">
      <div class="row">
        <div class="col-md-6">
          <h4><i class="fas fa-user-graduate"></i> Job Seekers</h4>
          <div class="table-responsive">
            <table class="table table-hover">
              <thead class="table-dark">
                <tr><th>Name</th><th>Email</th><th>Status</th><th>Action</th></tr>
              </thead>
              <tbody>
                <% 
                ResultSet rss = con.createStatement().executeQuery("SELECT * FROM users WHERE role='seeker' ORDER BY id DESC");
                while(rss.next()) { 
                %>
                <tr>
                  <td><%=rss.getString("name")%></td>
                  <td><%=rss.getString("email")%></td>
                  <td><span class="badge <%=rss.getString("status").equals("active") ? "bg-success" : "bg-danger" %>"><%=rss.getString("status")%></span></td>
                  <td><a href="?action=toggle_status&id=<%=rss.getInt("id")%>&r=seeker#users" class="btn btn-sm btn-outline-primary">Toggle</a></td>
                </tr>
                <% } rss.close(); %>
              </tbody>
            </table>
          </div>
        </div>
        <div class="col-md-6">
          <h4><i class="fas fa-building"></i> Companies</h4>
          <div class="table-responsive">
            <table class="table table-hover">
              <thead class="table-dark">
                <tr><th>Name</th><th>Email</th><th>Status</th><th>Action</th></tr>
              </thead>
              <tbody>
                <% 
                ResultSet rsc = con.createStatement().executeQuery("SELECT * FROM users WHERE role='company' ORDER BY id DESC");
                while(rsc.next()) { 
                %>
                <tr>
                  <td><%=rsc.getString("name")%></td>
                  <td><%=rsc.getString("email")%></td>
                  <td><span class="badge <%=rsc.getString("status").equals("active") ? "bg-success" : "bg-danger" %>"><%=rsc.getString("status")%></span></td>
                  <td><a href="?action=toggle_status&id=<%=rsc.getInt("id")%>&r=company#users" class="btn btn-sm btn-outline-primary">Toggle</a></td>
                </tr>
                <% } rsc.close(); %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    

    <!-- Jobs Tab -->
    <div class="tab-pane fade" id="jobs" role="tabpanel">
      <div class="mb-4">
        <div class="d-flex justify-content-between align-items-center">
          <h4><i class="fas fa-list"></i> Jobs</h4>
          <a href="add_job.jsp" class="btn btn-success"><i class="fas fa-plus"></i> Add Job</a>
        </div>
      </div>
      <div class="table-responsive">
        <table class="table table-hover">
          <thead class="table-dark">
            <tr><th>ID</th><th>Title</th><th>Company</th><th>Salary</th><th>Exp</th><th>Applicants</th><th>Date</th><th>Action</th></tr>
          </thead>
          <tbody>
            <% 
            ResultSet rsj = con.createStatement().executeQuery("SELECT * FROM jobs ORDER BY id DESC");
            while(rsj.next()) { 
            %>
            <tr>
              <td><%=rsj.getInt("id")%></td>
              <td><%=rsj.getString("title")%></td>
              <td><%=rsj.getString("company") != null ? rsj.getString("company") : "N/A" %></td>
              <td><%=rsj.getString("salary")%></td>
              <td><%=rsj.getString("experience")%></td>
              <td>
                <% 
                PreparedStatement psa = con.prepareStatement("SELECT COUNT(*) c FROM applications WHERE job_id=?");
                psa.setInt(1, rsj.getInt("id"));
                ResultSet rsa = psa.executeQuery(); rsa.next(); 
                %>
                <span class="badge bg-info"><%=rsa.getInt("c")%></span>
                <% rsa.close(); psa.close(); %>
              </td>
              <td><%= new java.text.SimpleDateFormat("MMM dd").format(rsj.getTimestamp("created_at"))%></td>
              <td><a href="?action=delete_job&id=<%=rsj.getInt("id")%>#jobs" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')">Delete</a></td>
            </tr>
            <% } rsj.close(); %>
          </tbody>
        </table>
      </div>
    </div>
    
    <!-- Notifications Tab -->
    <div class="tab-pane fade" id="notifications" role="tabpanel">
      <h4><i class="fas fa-paper-plane"></i> Send Notifications</h4>
      <form method="POST" action="admin.jsp#notifications">
        <input type="hidden" name="action" value="send_notification">
        <div class="mb-3">
          <label class="form-label">Type</label>
          <select name="type" class="form-select">
            <option value="policy">Policy Update</option>
            <option value="rule">Rule Change</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">Target</label>
          <select name="target" class="form-select" onchange="toggleEmailField()" id="target">
            <option value="all-seekers">All Seekers</option>
            <option value="all-companies">All Companies</option>
            <option value="specific">Specific Email</option>
          </select>
        </div>
        <div class="mb-3" id="emailField" style="display:none;">
          <label class="form-label">Email</label>
          <input type="email" name="target_email" class="form-control" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Message</label>
          <textarea name="message" class="form-control" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-success">Send Notification</button>
      </form>
      
      <h5 class="mt-5 pt-4 border-top">Recent Notifications</h5>
      <div class="table-responsive">
        <table class="table table-sm table-hover">
          <thead>
            <tr><th>Email</th><th>Type</th><th>Date</th></tr>
          </thead>
          <tbody>
            <% 
            ResultSet rsn;
            try {
              rsn = con.createStatement().executeQuery("SELECT * FROM notifications ORDER BY sent_date DESC LIMIT 10");
            } catch (Exception e) {
              rsn = null;
            }
            if (rsn != null) {
              while(rsn.next()) { 
            %>
            <tr>
              <td><%=rsn.getString("to_user")%></td>
              <td><span class="badge bg-secondary"><%=rsn.getString("type")%></span></td>
              <td><%=rsn.getTimestamp("sent_date") != null ? new java.text.SimpleDateFormat("MMM dd HH:mm").format(rsn.getTimestamp("sent_date")) : "" %></td>
            </tr>
            <% 
              }
              try { rsn.close(); } catch(Exception ex) {}
            } else { %>
            <tr>
              <td colspan="3" class="text-center text-muted">Notifications table not created yet</td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
function toggleEmailField() {
  var target = document.getElementById('target').value;
  document.getElementById('emailField').style.display = (target === 'specific') ? 'block' : 'none';
}
</script>

<%@ include file="footer.jsp" %>

