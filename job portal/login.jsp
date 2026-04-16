<%@ include file="header.jsp" %>
<div class="row justify-content-center mt-4">
  <div class="col-md-5">
    <div class="card shadow-lg border-0">
      <div class="card-body p-5">
        <h3 class="card-title text-center mb-4 text-primary">Login to Job Portal</h3>
        <form method="post">
          <div class="mb-3">
            <label class="form-label">Email</label>
            <input name="email" type="email" class="form-control form-control-lg" placeholder="Enter email" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control form-control-lg" placeholder="Enter password" required>
          </div>
          <button type="submit" class="btn btn-primary w-100 py-3 fw-bold">Login</button>
        </form>
        <div class="text-center mt-4">
          <a href="register.jsp" class="btn btn-outline-success w-100 py-2">Create New Account</a>
        </div>
      </div>
      </div>
    </div>
  </div>
</div>
<%
if(request.getMethod().equalsIgnoreCase("POST")){
%><%@ include file="db.jsp" %><%
PreparedStatement ps=con.prepareStatement("select * from users where email=? and password=?");
ps.setString(1,request.getParameter("email"));
ps.setString(2,request.getParameter("password"));
ResultSet rs=ps.executeQuery();
if(rs.next()){
session.setAttribute("user",rs.getString("name"));
session.setAttribute("email",rs.getString("email"));
session.setAttribute("role",rs.getString("role"));
if(rs.getString("role").equals("admin")) response.sendRedirect("admin.jsp");
else if(rs.getString("role").equals("company")) response.sendRedirect("company.jsp");
else response.sendRedirect("seeker.jsp");
}else{
out.println("<div class=\"alert alert-danger mt-3 text-center mx-auto\" style=\"max-width: 500px;\">Invalid credentials. Please try again.</div>");
}
}
%>
<%@ include file="footer.jsp" %>
