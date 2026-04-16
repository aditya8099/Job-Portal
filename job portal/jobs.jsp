<%@ include file="header.jsp" %>
<div class="container mt-4">
  <div class="row g-4">
    <div class="col-12">
      <div class="input-group shadow-lg">
        <input name="k" type="search" class="form-control form-control-lg border-0 ps-4" placeholder="Search jobs by title...">
        <button class="btn btn-primary px-4" type="submit">Search</button>
      </div>
    </div>
  </div>
</div>
<%@ include file="db.jsp" %>
<%
String k=request.getParameter("k");
String sql="select * from jobs";
if(k!=null && !k.equals("")) sql+=" where title like '%"+k+"%'";
ResultSet rs=con.createStatement().executeQuery(sql);
%>
<div class="container mt-4">
  <div class="row g-4">
<%
int count = 0;
while(rs.next()){
count++;
%>
    <div class="col-lg-6 col-xl-4">
      <div class="card h-100 shadow-lg border-0 hover-shadow">
        <div class="card-body p-4">
          <h5 class="card-title fw-bold text-primary mb-3"><%=rs.getString("title")%></h5>
          <p class="card-text text-muted"><%=rs.getString("description")%></p>
          <% if(rs.getString("salary") != null && !rs.getString("salary").isEmpty()) { %>
          <div class="mb-2">
            <small class="badge bg-success"><%=rs.getString("salary")%></small>
          </div>
          <% } %>
          <% if(rs.getString("experience") != null && !rs.getString("experience").isEmpty()) { %>
          <small class="text-muted d-block mb-2">Exp: <%=rs.getString("experience")%></small>
          <% } %>
          <small class="text-muted d-block mb-3">Posted: <%= new java.text.SimpleDateFormat("MMM dd").format(rs.getTimestamp("created_at")) %></small>
          <div class="d-flex justify-content-between align-items-end mt-3">
            <a href="apply.jsp?id=<%=rs.getInt("id")%>" class="btn btn-success px-4">Apply Now</a>

          </div>
        </div>
      </div>
    </div>
<%
if(count % 3 == 0) out.println("</div><div class=\"row g-4\">");
}
%>
  </div>
  <% if(count == 0) { %>
  <div class="text-center py-5">
    <h3 class="text-muted mb-4">No jobs found</h3>
    <a href="index.jsp" class="btn btn-outline-primary">Back to Home</a>
  </div>
  <% } %>
</div>
<%@ include file="footer.jsp" %>
