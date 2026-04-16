<%@ include file="header.jsp" %>
<div class="row justify-content-center mt-4">
  <div class="col-md-5">
    <div class="card shadow-lg border-0">
      <div class="card-body p-5">
        <h3 class="card-title text-center mb-4 text-success">Register for Job Portal</h3>
        <form method="post">
          <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input name="name" type="text" class="form-control form-control-lg" placeholder="Enter full name" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Email</label>
            <input name="email" type="email" class="form-control form-control-lg" placeholder="Enter email" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control form-control-lg" placeholder="Create password" required>
          </div>
          <div class="mb-4">
            <label class="form-label">Role</label>
            <select name="role" class="form-select form-select-lg">
              <option value="seeker">Job Seeker</option>
              <option value="company">Company</option>
            </select>
          </div>
          <button type="submit" class="btn btn-success w-100 py-3 fw-bold">Register Now</button>
        </form>
        <div class="text-center mt-4">
          <a href="login.jsp" class="btn btn-outline-primary w-100 py-2">Have Account? Login</a>
        </div>
      </div>
    </div>
  </div>
</div>
<%
if("POST".equalsIgnoreCase(request.getMethod())){
%>
<%@ include file="db.jsp" %>
<%
  String email = request.getParameter("email");
  PreparedStatement checkPs = con.prepareStatement("SELECT COUNT(*) FROM users WHERE email=?");
  checkPs.setString(1, email);
  ResultSet checkRs = checkPs.executeQuery();
  checkRs.next();
  int count = checkRs.getInt(1);
  checkPs.close();
  checkRs.close();
  
  if(count > 0) {
%>
<div class="alert alert-danger mt-3 text-center">
  <strong>Email already registered!</strong> Please <a href="login.jsp">login</a> or use different email.
</div>
<%
  } else {
    PreparedStatement ps = con.prepareStatement("INSERT INTO users(name,email,password,role) VALUES(?,?,?,?)");
    ps.setString(1, request.getParameter("name"));
    ps.setString(2, email);
    ps.setString(3, request.getParameter("password"));
    ps.setString(4, request.getParameter("role"));
    ps.executeUpdate();
    ps.close();
    con.close();
%>
<div class="alert alert-success mt-3 text-center">
  Registration successful! <a href="login.jsp">Login now</a>.
</div>
<%
  }
}
%>
<%@ include file="footer.jsp" %>
