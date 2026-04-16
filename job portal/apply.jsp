<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="header.jsp" %>
<div class="container mt-4">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-lg border-0">
        <div class="card-body p-5 text-center">
          <%@ include file="db.jsp" %>
          <%
          String jobIdStr = request.getParameter("id");
          int jobId = Integer.parseInt(jobIdStr);
          String jobTitle = "";
          String jobDesc = "";
          String jobSalary = "";
          String jobExp = "";
          java.util.Date postedDate = null;
          
          // Fetch job details
          PreparedStatement psJob = con.prepareStatement("SELECT title, description, salary, experience, created_at FROM jobs WHERE id = ?");
          psJob.setInt(1, jobId);
          ResultSet rsJob = psJob.executeQuery();
          if (rsJob.next()) {
            jobTitle = rsJob.getString("title");
            jobDesc = rsJob.getString("description");
            jobSalary = rsJob.getString("salary");
            jobExp = rsJob.getString("experience");
            postedDate = rsJob.getTimestamp("created_at");
          }
          rsJob.close();
          psJob.close();
          
// Check if already applied
          String applicant = (String)session.getAttribute("user");
          if(applicant == null || applicant.isEmpty()) {
            %>
            <script>
              alert("You must be logged in to apply for jobs. Please login first.");
              window.location.href = "login.jsp";
            </script>
            <%
            return;
          }
          PreparedStatement psCheck = con.prepareStatement("SELECT COUNT(*) FROM applications WHERE job_id=? AND applicant=?");
          psCheck.setInt(1, jobId);
          psCheck.setString(2, applicant);
          ResultSet rsCheck = psCheck.executeQuery();
          rsCheck.next();
          int appliedCount = rsCheck.getInt(1);
          rsCheck.close();
          psCheck.close();
          boolean alreadyApplied = appliedCount > 0;
          
          String statusMsg, statusIcon, statusColor;
          if (alreadyApplied) {
            statusMsg = "You have already applied for this job!";
            statusIcon = "fa-exclamation-triangle";
            statusColor = "warning";
          } else {
            // Insert application
            PreparedStatement ps=con.prepareStatement("insert into applications(job_id,applicant) values(?,?)");
            ps.setInt(1, jobId);
            ps.setString(2, applicant);
            ps.executeUpdate();
            ps.close();
            statusMsg = "Application Submitted Successfully!";
            statusIcon = "fa-check-circle";
            statusColor = "success";
          }
          %>
          <h4 class="mb-3 fw-bold text-primary">Applied for Job:</h4>
          <h5 class="mb-2"><%=jobTitle%></h5>
          <% if(jobSalary != null && !jobSalary.isEmpty()) { %>
          <div class="mb-1">
            <small class="badge bg-success">Salary: <%=jobSalary%></small>
          </div>
          <% } %>
          <% if(jobExp != null && !jobExp.isEmpty()) { %>
          <small class="text-muted d-block mb-1">Exp: <%=jobExp%></small>
          <% } %>
          <% if(postedDate != null) { %>
          <small class="text-muted d-block mb-2">Posted: <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(postedDate) %></small>
          <% } %>
          <p class="text-muted mb-4"><%=jobDesc.length() > 200 ? jobDesc.substring(0, 200) + "..." : jobDesc%></p>
          <i class="fas <%=statusIcon%> fa-5x text-<%=statusColor%> mb-4"></i>
          <h2 class="text-<%=statusColor%> mb-4"><%=statusMsg%> <strong><%=jobTitle%></strong></h2>
          <p class="lead mb-4">Your application for the job has been successfully sent.</p>
          <a href="jobs.jsp" class="btn btn-primary px-5 py-2 me-3">View Jobs</a>
          <a href="seeker.jsp" class="btn btn-outline-secondary px-5 py-2">Dashboard</a>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>
