<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%
String appIdStr = request.getParameter("id");
String status = request.getParameter("status");
if (appIdStr != null && status != null) {
  int appId = Integer.parseInt(appIdStr);
  PreparedStatement ps = con.prepareStatement("UPDATE applications SET status = ? WHERE id = ?");
  ps.setString(1, status);
  ps.setInt(2, appId);
  ps.executeUpdate();
  ps.close();
}
response.sendRedirect("company.jsp");
%>
