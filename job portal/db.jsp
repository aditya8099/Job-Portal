<%@ page import="java.sql.*" %>
<%
Connection con=null;
try{
Class.forName("com.mysql.cj.jdbc.Driver");
con=DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal3","root","Aditya$8099");
}catch(Exception e){ out.println(e); }
%>
