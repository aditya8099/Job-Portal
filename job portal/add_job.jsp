<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<%
if(request.getMethod().equalsIgnoreCase("POST")) {
%>
<%@ include file="db.jsp" %>
<%
String title = request.getParameter("title");
String description = request.getParameter("description");
String company = request.getParameter("company");
String salary = request.getParameter("salary");
String experience = request.getParameter("experience");

PreparedStatement ps = con.prepareStatement("INSERT INTO jobs(title,description,company,salary,experience) VALUES(?,?,?,?,?)");
ps.setString(1, title);
ps.setString(2, description);
ps.setString(3, company);
ps.setString(4, salary);
ps.setString(5, experience);
ps.executeUpdate();
ps.close();
con.close();

session.setAttribute("successMsg", "Job posted successfully!");
response.sendRedirect("admin.jsp#jobs");
return;
}
%>
<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card">
        <div class="card-header bg-primary text-white">
          <h4><i class="fas fa-plus"></i> Add New Job</h4>
        </div>
        <div class="card-body">
          <form method="POST">
            <div class="mb-3">
              <label class="form-label fw-bold">Job Title <span class="text-danger">*</span></label>
              <input type="text" name="title" class="form-control" required>
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Company</label>
              <input type="text" name="company" class="form-control">
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Salary</label>
              <input type="text" name="salary" class="form-control" placeholder="e.g. 50k-70k LPA">
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Experience</label>
              <input type="text" name="experience" class="form-control" placeholder="e.g. 2-5 years">
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Description <span class="text-danger">*</span></label>
              <textarea name="description" class="form-control" rows="5" required placeholder="Job responsibilities, requirements, benefits..."></textarea>
            </div>
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-success flex-fill">
                <i class="fas fa-plus"></i> Post Job
              </button>
              <a href="admin.jsp#jobs" class="btn btn-secondary">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>
