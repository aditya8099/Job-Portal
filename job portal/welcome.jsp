<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="header.jsp" %>
<div class="container mt-5 pt-4 min-vh-100 d-flex align-items-center">
  <div class="row justify-content-center">
    <div class="col-lg-8 text-center">
      <h1 class="display-2 fw-bold text-dark mb-4 lh-1 animate__animated animate__fadeIn">Welcome to QueryCareer</h1>
      <p class="lead mb-5 opacity-75">Your gateway to thousands of exciting career opportunities. Join the best companies and advance your professional journey.</p>
      <div class="d-flex flex-column flex-md-row gap-3 justify-content-center">
        <a href="login.jsp" class="btn btn-primary btn-lg px-5 py-3 fw-bold shadow-lg animate__animated animate__pulse animate__infinite">Login to Dashboard</a>
        <a href="register.jsp" class="btn btn-outline-success btn-lg px-5 py-3 fw-bold shadow-lg animate__animated animate__pulse animate__infinite">Create Account Free</a>
      </div>
      <div class="mt-5">
        <p class="text-muted">Already have an account? <a href="login.jsp">Sign in here</a> | New user? <a href="register.jsp">Get started</a></p>
      </div>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>
