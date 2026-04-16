<%@ include file="header.jsp" %>
<div class="container mt-4">
  <h2 class="mb-5 text-center fw-bold text-success">Welcome, Job Seeker!</h2>
  <div class="row g-4">
    <div class="col-lg-8">
      <div class="card shadow-lg border-0">
        <div class="card-body p-4">
          <h5 class="card-title mb-4">My Applications</h5>

  <%@ include file="db.jsp" %>
  <%
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) {
      session.removeAttribute("successMsg");
  %>
      <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
        <%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
  <%
    }
    if (errorMsg != null) {
      session.removeAttribute("errorMsg");
  %>
      <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
        <%= errorMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
  <%
    }
  %>

          <%
          String seekerName = (String)session.getAttribute("user");
          PreparedStatement psApps = con.prepareStatement("SELECT a.id, j.title, j.salary, j.experience, a.status FROM applications a JOIN jobs j ON a.job_id = j.id WHERE a.applicant = ? ORDER BY a.id DESC");
          psApps.setString(1, seekerName);
          ResultSet rsApps = psApps.executeQuery();
          boolean hasApps = false;
          while(rsApps.next()) {
            hasApps = true;
          %>
          <div class="border-bottom pb-3 mb-3">
            <h6 class="fw-bold"><%=rsApps.getString("title")%></h6>
            <% if(rsApps.getString("salary") != null && !rsApps.getString("salary").isEmpty()) { %>
            <small class="badge bg-success me-1"><%=rsApps.getString("salary")%></small>
            <% } %>
            <small class="text-muted me-1">Exp: <%=rsApps.getString("experience")%></small>
            <span class="badge bg-<%= rsApps.getString("status").equals("accepted") ? "success" : rsApps.getString("status").equals("rejected") ? "danger" : rsApps.getString("status").equals("not_eligible") ? "warning" : "secondary" %>"><%=rsApps.getString("status")%></span>
            <% if("accepted".equals(rsApps.getString("status"))) { %>
            <div class="alert alert-success mt-2">
              Congratulations! You have been accepted for this position 🎉
            </div>
            <% } else if("rejected".equals(rsApps.getString("status")) || "not_eligible".equals(rsApps.getString("status"))) { %>
            <div class="alert alert-warning mt-2">
              Sorry, your application has been <%= rsApps.getString("status") %>.
            </div>
            <% } else { %>
            <div class="alert alert-info mt-2">
              Your application is pending. We will notify you soon.
            </div>
            <% } %>
          </div>
          <% } 
          rsApps.close();
          psApps.close();
          if(!hasApps) { %>
          <p class="text-muted text-center py-4">No applications submitted yet. Apply for jobs to see status here!</p>
          <% } %>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="card shadow-lg border-0 h-100">
        <div class="card-header bg-light">
          <h6 class="mb-0 fw-bold">Quick Actions</h6>
        </div>
        <div class="card-body">
          <a href="jobs.jsp" class="btn btn-outline-primary w-100 mb-2">Browse All Jobs</a>
          <a href="profile.jsp" class="btn btn-success w-100 mb-2">My Profile</a>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>
