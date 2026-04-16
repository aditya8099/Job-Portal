<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
String companyName = (String)session.getAttribute("user");
String email = (String)session.getAttribute("email");
if(companyName == null || !"company".equals(session.getAttribute("role"))) {
  response.sendRedirect("login.jsp");
  return;
}
String message = "";
String editJobId = request.getParameter("edit");
String deleteAction = request.getParameter("action");
boolean isEdit = editJobId != null;
int editId = 0;
String editTitle = "";
String editDesc = "";
String editSalary = "";
String editExperience = "";
%>
<%@ include file="db.jsp" %>
<%
if("delete".equals(deleteAction)) {
  int delId = Integer.parseInt(request.getParameter("id"));
  PreparedStatement dps = con.prepareStatement("DELETE FROM jobs WHERE id = ? AND company = ?");
  dps.setInt(1, delId);
  dps.setString(2, companyName);
  dps.executeUpdate();
  dps.close();
  message = "Job deleted successfully!";
}
if("POST".equalsIgnoreCase(request.getMethod())) {
  String title = request.getParameter("t");
  String desc = request.getParameter("d");
  String salary = request.getParameter("salary");
  String experience = request.getParameter("experience");
  String editIdParam = request.getParameter("edit_id");
  if(editIdParam != null && !editIdParam.trim().equals("") && !editIdParam.trim().equals("0")) {
    try {
      int updateId = Integer.parseInt(editIdParam.trim());
      PreparedStatement ups = con.prepareStatement("UPDATE jobs SET title = ?, description = ?, salary = ?, experience = ? WHERE id = ? AND company = ?");
      ups.setString(1, title);
      ups.setString(2, desc);
      ups.setString(3, salary);
      ups.setString(4, experience);
      ups.setInt(5, updateId);
      ups.setString(6, companyName);
      int rows = ups.executeUpdate();
      ups.close();
      message = (rows > 0) ? "Job updated! Rows: " + rows : "No changes - job not found.";
    } catch(Exception e) {
      message = "Update error: " + e.getMessage();
    }
  } else {
    if(title != null && title.trim().length() > 0 && desc != null && desc.trim().length() > 0) {
      PreparedStatement ps = con.prepareStatement("INSERT INTO jobs (title, description, company, salary, experience) VALUES (?, ?, ?, ?, ?)");
      ps.setString(1, title.trim());
      ps.setString(2, desc.trim());
      ps.setString(3, companyName);
      ps.setString(4, salary != null ? salary.trim() : "");
      ps.setString(5, experience != null ? experience.trim() : "");
      int rows = ps.executeUpdate();
      ps.close();
      message = "Job posted! Rows: " + rows;
    } else {
      message = "Error: Title and description required.";
    }
  }
}
if(isEdit && editJobId != null) {
  try {
    int eid = Integer.parseInt(editJobId);
    PreparedStatement eps = con.prepareStatement("SELECT title, description, salary, experience FROM jobs WHERE id = ? AND company = ?");
    eps.setInt(1, eid);
    eps.setString(2, companyName);
    ResultSet ers = eps.executeQuery();
    if(ers.next()) {
      editTitle = ers.getString("title");
      editDesc = ers.getString("description");
      editSalary = ers.getString("salary");
      editExperience = ers.getString("experience");
      editId = eid;
    } else {
      isEdit = false;
      message = "Job not found!";
    }
    ers.close();
    eps.close();
  } catch(Exception e) {
    message = "Edit load error.";
  }
}
PreparedStatement psJobs = con.prepareStatement("SELECT * FROM jobs WHERE company = ? ORDER BY id DESC");
psJobs.setString(1, companyName);
ResultSet rsJobs = psJobs.executeQuery();
PreparedStatement psApps = con.prepareStatement("SELECT a.id as app_id, j.title, a.applicant, a.status FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.company = ? ORDER BY a.id DESC");
psApps.setString(1, companyName);
ResultSet rsApps = psApps.executeQuery();
%>
<div class="container mt-4">
  <h2 class="mb-5 text-center fw-bold text-success">Welcome, <%=companyName%>!</h2>
  <% if(message.length() > 0) { %>
  <div class="alert alert-success text-center"><%=message%></div>
  <% } %>
  <div class="row g-4 mb-5">
    <div class="col-lg-8">
      <div class="card shadow-lg border-0">
        <div class="card-header bg-success text-white">
          <h5 class="mb-0 fw-bold"><i class="fas fa-plus-circle me-2"></i><%= isEdit ? "Edit Job" : "Post New Job" %></h5>
        </div>
        <div class="card-body p-4">
          <form method="post">
            <input type="hidden" name="edit_id" value="<%=editId%>">
            <div class="mb-3">
              <label class="form-label fw-bold">Job Title *</label>
              <input name="t" type="text" class="form-control form-control-lg" value="<%=editTitle%>" placeholder="e.g. Software Engineer" required>
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Salary</label>
              <input name="salary" type="text" class="form-control" value="<%=editSalary%>" placeholder="e.g. 5-10LPA">
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Experience</label>
              <input name="experience" type="text" class="form-control" value="<%=editExperience%>" placeholder="e.g. 2+ years">
            </div>
            <div class="mb-4">
              <label class="form-label fw-bold">Description *</label>
              <textarea name="d" class="form-control" rows="5" placeholder="Job responsibilities, requirements..." required><%=editDesc%></textarea>
            </div>
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-success px-4 py-2 fw-bold"><%= isEdit ? "Update Job" : "Post Job" %></button>
              <% if(isEdit) { %>
              <a href="company.jsp" class="btn btn-outline-secondary px-4 py-2">Cancel</a>
              <% } %>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="card shadow-lg border-0 h-100">
        <div class="card-header bg-primary text-white">
          <h6 class="mb-0 fw-bold">Quick Actions</h6>
        </div>
        <div class="card-body">
          <a href="company.jsp" class="btn btn-primary w-100 mb-3 <%= !isEdit ? "active" : "" %>">Post Job</a>
          <a href="jobs.jsp" class="btn btn-outline-success w-100 mb-3">Browse Jobs</a>
          <a href="#applications" class="btn btn-outline-primary w-100 mb-3">Applications</a>
          <a href="logout.jsp" class="btn btn-danger w-100">Logout</a>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-md-6">
      <h4>My Jobs</h4>
      <div class="table-responsive">
        <table class="table">
          <thead>
            <tr>
              <th>Title</th>
              <th>Salary</th>
              <th>Exp</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <% while(rsJobs.next()) { %>
            <tr>
              <td><%=rsJobs.getString("title")%></td>
              <td><%=rsJobs.getString("salary")%></td>
              <td><%=rsJobs.getString("experience")%></td>
<td>
                <a href="company.jsp?edit=<%=rsJobs.getInt("id")%>" class="btn btn-sm btn-primary">Edit</a>
                <a href="company.jsp?action=delete&id=<%=rsJobs.getInt("id")%>" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')">Del</a>
              </td>

            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
    <div class="col-md-6">
      <h4>Applications</h4>
      <div class="table-responsive">
        <table class="table">
          <thead>
            <tr>
              <th>Job</th>
              <th>Applicant</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <% while(rsApps.next()) { %>
            <tr>
              <td><%=rsApps.getString("title")%></td>
              <td><%=rsApps.getString("applicant")%></td>

              <td>
                <form method="get" action="update_status.jsp?t=<%=System.currentTimeMillis()%>" style="display:inline">
                  <input type="hidden" name="id" value="<%=rsApps.getInt("app_id")%>">
                  <select name="status" onchange="this.form.submit()" class="form-select form-select-sm">
                    <option value="pending" <%= "pending".equals(rsApps.getString("status")) ? "selected" : "" %>>Pending</option>
                    <option value="accepted" <%= "accepted".equals(rsApps.getString("status")) ? "selected" : "" %>>Accepted</option>
                    <option value="rejected" <%= "rejected".equals(rsApps.getString("status")) ? "selected" : "" %>>Rejected</option>
                  </select>
                </form>
              </td>
            </tr>

            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>

