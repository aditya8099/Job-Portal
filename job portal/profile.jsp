<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="false" %>
<%!
String readPartString(javax.servlet.http.HttpServletRequest request, String name) {
  try {
    javax.servlet.http.Part part = request.getPart(name);
    if (part == null || part.getSize() == 0) return "";
    java.io.InputStream is = part.getInputStream();
    if (is == null || is.available() == 0) return "";
    java.util.Scanner s = new java.util.Scanner(is, "UTF-8").useDelimiter("\\A");
    return s.hasNext() ? s.next().trim() : "";
  } catch (Exception e) { 
    System.out.println("Part read error for " + name + ": " + e.getMessage());
    return "";
  }
}
%>
<%@ include file="header.jsp" %>
<%
  // Edit form POST handler FIRST to avoid variable scope issues
  boolean isPostUpdate = "POST".equalsIgnoreCase(request.getMethod()) && session.getAttribute("role") != null && "seeker".equals(session.getAttribute("role").toString());
  String updateMsg = "";
  if (isPostUpdate) {
    String summary = readPartString(request, "summary");
    String skills = readPartString(request, "skills");
    String education = readPartString(request, "education");
    String certificates = readPartString(request, "certificates");
    String mobile = readPartString(request, "mobile");
    String currentEmail = (String) session.getAttribute("email");
    
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal3","root","Aditya$8099");
      
      // Update text fields
      PreparedStatement ups = con.prepareStatement("UPDATE users SET summary=?, skills=?, education=?, certificates=?, mobile=? WHERE email=?");
      ups.setString(1, summary);
      ups.setString(2, skills);
      ups.setString(3, education);
      ups.setString(4, certificates);
      ups.setString(5, mobile);
      ups.setString(6, currentEmail);
      int rowsUpdated = ups.executeUpdate();
      ups.close();
      

      // Resume and photo uploads now enabled with web.xml
      try {
        javax.servlet.http.Part resumePart = request.getPart("resume");
        if (resumePart != null && resumePart.getSize() > 0) {

          String resumeDir = application.getRealPath("/uploads/resume");
          new java.io.File(resumeDir).mkdirs();
          String fileName = System.currentTimeMillis() + "_" + resumePart.getSubmittedFileName();
          resumePart.write(resumeDir + "/" + fileName);
          PreparedStatement rps = con.prepareStatement("UPDATE users SET resume=? WHERE email=?");
          rps.setString(1, "uploads/resume/" + fileName);
          rps.setString(2, currentEmail);
          rps.executeUpdate();
          rps.close();
          updateMsg += " Resume uploaded";
        }
      } catch (Exception e) {
        updateMsg += " Resume error: " + e.getMessage();
      }

      try {
        javax.servlet.http.Part photoPart = request.getPart("photo");
        if (photoPart != null && photoPart.getSize() > 0) {

          String photoDir = application.getRealPath("/uploads/photo");
          new java.io.File(photoDir).mkdirs();
          String fileName = System.currentTimeMillis() + "_" + photoPart.getSubmittedFileName();
          photoPart.write(photoDir + "/" + fileName);
          PreparedStatement pps = con.prepareStatement("UPDATE users SET photo=? WHERE email=?");
          pps.setString(1, "uploads/photo/" + fileName);
          pps.setString(2, currentEmail);
          pps.executeUpdate();
          pps.close();
          updateMsg += " Photo uploaded";
        }
      } catch (Exception e) {
        updateMsg += " Photo error: " + e.getMessage();
      }
      
      if(rowsUpdated == 0) {
        session.setAttribute("errorMsg", "No rows updated! Email '" + currentEmail + "' not found in DB.");
      } else {
        updateMsg = " Email used: '" + currentEmail + "' Rows affected: " + rowsUpdated + updateMsg;
        session.setAttribute("successMsg", updateMsg);
      }
    } catch (Exception e) {
      session.setAttribute("errorMsg", "Update error: " + e.getMessage() + " Email: '" + currentEmail + "'");
    }
    response.sendRedirect("profile.jsp?t=" + System.currentTimeMillis());
    return;
  }
%>
<script>
function toggleEditForm() {
  console.log('Edit button clicked');
  var editForm = document.getElementById('editForm');
  var profileSection = document.querySelector('.profile-section');
  if (editForm && profileSection) {
    if (editForm.style.display !== 'none') {
      editForm.style.setProperty('display', 'none', 'important');
      profileSection.style.setProperty('display', 'block', 'important');
    } else {
      editForm.style.setProperty('display', 'block', 'important');
      profileSection.style.setProperty('display', 'none', 'important');
    }
  } else {
    console.error('Elements not found');
  }
}
</script>
<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card shadow">
        <div class="card-header bg-success text-white text-center">
          <h4><i class="fas fa-user"></i> <%= request.getParameter("view") != null ? "Job Seeker Profile" : "My Profile" %></h4>
        </div>
        <div class="card-body">
          <%
            String viewName = request.getParameter("view");
            boolean isViewMode = viewName != null;
            String currentEmail = (String) session.getAttribute("email");
            String targetEmail = "";
            String targetName = "";
            
            if (isViewMode) {
              targetName = viewName;
            } else {
              if(session.getAttribute("role") == null || !"seeker".equals(session.getAttribute("role"))) {
          %>
          <div class="alert alert-warning">Jobseeker login required.</div>
          <a href="login.jsp" class="btn btn-primary">Login</a>
          <%
                return;
              }
              targetEmail = currentEmail;
              targetName = (String) session.getAttribute("user");
            }
          %>
          <%@ include file="db.jsp" %>
          <%
            String query = isViewMode ? 
              "SELECT * FROM users WHERE name=?" : 
              "SELECT * FROM users WHERE email=?";
            PreparedStatement ps = con.prepareStatement(query);
            if (isViewMode) {
              ps.setString(1, targetName);
            } else {
              ps.setString(1, targetEmail);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
              targetEmail = rs.getString("email");
              targetName = rs.getString("name");
          %>
          <% 
            String successMsg = (String) session.getAttribute("successMsg");
            String errorMsg = (String) session.getAttribute("errorMsg");
            if (successMsg != null) {
              session.removeAttribute("successMsg");
          %>
              <div class='alert alert-success'><%= successMsg %></div>
          <% 
            }
            if (errorMsg != null) {
              session.removeAttribute("errorMsg");
          %>
              <div class='alert alert-danger'><%= errorMsg %></div>
          <% 
            }
          %>
          <div class="profile-section" style="transition: opacity 0.3s ease;">
            <div class="text-center mb-4">
              <img src="<%= rs.getString("photo") != null ? rs.getString("photo") : "https://ui-avatars.com/api/?name=User&size=120&background=10b981&color=fff" %>" 
                   alt="Profile Photo" class="img-thumbnail rounded-circle mb-3" style="width:120px;height:120px;object-fit:cover;">
              <h5 class="fw-bold text-primary"><%= targetName %></h5>
              <p class="text-muted"><%= targetEmail %></p>
            </div>
            <dl class="row mb-4">
              <dt class="col-sm-4 fw-bold">Summary</dt>
              <dd class="col-sm-8"><%= rs.getString("summary") != null ? rs.getString("summary") : "Not provided" %></dd>
              <dt class="col-sm-4 fw-bold">Skills</dt>
              <dd class="col-sm-8"><%= rs.getString("skills") != null ? rs.getString("skills") : "Not provided" %></dd>
              <dt class="col-sm-4 fw-bold">Education</dt>
              <dd class="col-sm-8"><%= rs.getString("education") != null ? rs.getString("education") : "Not provided" %></dd>
              <dt class="col-sm-4 fw-bold">Certificates</dt>
              <dd class="col-sm-8"><%= rs.getString("certificates") != null ? rs.getString("certificates") : "Not provided" %></dd>
              <dt class="col-sm-4 fw-bold">Mobile</dt>
              <dd class="col-sm-8"><%= rs.getString("mobile") != null ? rs.getString("mobile") : "Not provided" %></dd>
            </dl>
            <% if (rs.getString("resume") != null && !rs.getString("resume").isEmpty()) { %>
            <div class="text-center mb-4">
              <a href="<%= rs.getString("resume") %>" class="btn btn-success btn-lg px-4" download><i class="fas fa-download me-2"></i>Download Resume</a>
            </div>
            <% } else { %>
            <div class="alert alert-info text-center">Resume not uploaded</div>
            <% } %>
            <% if (!isViewMode) { %>
            <div class="text-end">
              <button class="btn btn-outline-primary" onclick="toggleEditForm()">Edit Profile</button>
            </div>
            <% } else { %>
            <div class="text-end">
              <a href="company.jsp" class="btn btn-outline-secondary me-2">Back to Dashboard</a>
              <a href="logout.jsp" class="btn btn-outline-danger">Logout</a>
            </div>
            <% } %>
          </div>
          <div id="editForm" style="display:none;">
            <form method="post" enctype="multipart/form-data" class="border p-4 rounded mt-3">
              <div class="mb-3">

                <label for="summaryField" class="form-label fw-bold">Summary <span class="text-danger">*</span></label>
                <textarea id="summaryField" name="summary" class="form-control" rows="3" required><%= rs.getString("summary") != null ? rs.getString("summary") : "" %></textarea>
              </div>
              <div class="mb-3">

                <label for="skillsField" class="form-label fw-bold">Skills <span class="text-danger">*</span></label>
                <input id="skillsField" name="skills" class="form-control" value="<%= rs.getString("skills") != null ? rs.getString("skills") : "" %>">
              </div>
              <div class="mb-3">

                <label for="educationField" class="form-label fw-bold">Education <span class="text-danger">*</span></label>
                <textarea id="educationField" name="education" class="form-control" rows="3"><%= rs.getString("education") != null ? rs.getString("education") : "" %></textarea>
              </div>
              <div class="mb-3">

                <label for="certificatesField" class="form-label fw-bold">Certificates <span class="text-danger">*</span></label>
                <textarea id="certificatesField" name="certificates" class="form-control" rows="2"><%= rs.getString("certificates") != null ? rs.getString("certificates") : "Not provided" %></textarea>
              </div>
              <div class="mb-3">

                <label for="mobileField" class="form-label fw-bold">Mobile No <span class="text-danger">*</span></label>
                <input id="mobileField" name="mobile" type="tel" class="form-control" value="<%= rs.getString("mobile") != null ? rs.getString("mobile") : "" %>">
              </div>
              <div class="mb-3">
                <label class="form-label fw-bold">Resume (.pdf)</label>
                <input type="file" name="resume" class="form-control" accept=".pdf">
              </div>
              <div class="mb-3">
                <label class="form-label fw-bold">Photo (.jpg/.jpeg)</label>
                <input type="file" name="photo" class="form-control" accept=".jpg,.jpeg">
              </div>
              <div class="d-flex gap-2">
                <button type="submit" class="btn btn-success flex-fill">Save Changes</button>
                <button type="button" class="btn btn-outline-secondary" onclick="toggleEditForm()">Cancel</button>
              </div>
            </form>
          </div>
          <% 
            rs.close();
            ps.close();
          } else { %>
          <div class="alert alert-warning text-center">Profile not found</div>
          <a href="<%= isViewMode ? "company.jsp" : "seeker.jsp" %>" class="btn btn-primary">Back</a>
          <% } %>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>

