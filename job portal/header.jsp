

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
:root {
  --bs-body-bg: #ffffff;
  --bs-body-color: #212529;
}

[data-theme="dark"] {
  --bs-body-bg: #121212;
  --bs-body-color: #ffffff;
  color-scheme: dark;
}
[data-theme="dark"] h1, [data-theme="dark"] .display-3, [data-theme="dark"] .card-title {
  color: #ffffff !important;
}
[data-theme="dark"] .text-dark {
  color: #ffffff !important;
}

[data-theme="dark"] .btn-success, [data-theme="dark"] .btn-primary, [data-theme="dark"] .btn-outline-primary {
  color: #ffffff !important;
}
[data-theme="dark"] .btn-success {
  background-color: #10b981 !important;
  border-color: #059669 !important;
}
[data-theme="dark"] .btn-success:hover {
  background-color: #059669 !important;
  border-color: #047857 !important;
}
[data-theme="dark"] .btn-primary {
  background-color: #3b82f6 !important;
  border-color: #2563eb !important;
}
[data-theme="dark"] .btn-primary:hover {
  background-color: #2563eb !important;
  border-color: #1d4ed8 !important;
}
[data-theme="dark"] .btn-outline-primary {
  color: #3b82f6 !important;
  border-color: #3b82f6 !important;
}
[data-theme="dark"] .btn-outline-primary:hover {
  background-color: #3b82f6 !important;
  color: #ffffff !important;
  border-color: #3b82f6 !important;
}

[data-theme="dark"] .navbar-brand {
  color: #ffffff !important;
}


[data-theme="dark"] .navbar-dark {
  background-color: #1f1f1f !important;
}
[data-theme="dark"] .card {
  background-color: #1f1f1f;
  border-color: #333;
  color: #e0e0e0;
}
[data-theme="dark"] .footer {
  background-color: #1f1f1f !important;
  color: #e0e0e0;
}
body {
  background-color: var(--bs-body-bg);
  color: var(--bs-body-color);
  transition: background-color 0.3s ease, color 0.3s ease;
}
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">


<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-lg">
  <div class="container">
    <a class="navbar-brand fw-bold fs-3" href="index.jsp">QueryCareer</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

  <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">

        <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="jobs.jsp">Jobs</a></li>
        <li class="nav-item"><a class="nav-link" href="profile.jsp">Profile</a></li>
        <% if(session.getAttribute("user")!=null) { %>
        <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
        <% } else { %>
        <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="register.jsp">Register</a></li>

        <% } %>
      </ul>

    </div>
  </div>
</nav>

<script>
document.addEventListener('DOMContentLoaded', function() {

  const body = document.body;
  
  // Toggle light mode by default
  body.setAttribute('data-theme', 'light');
  
  // Add toggle button
  const toggleBtn = document.createElement('button');
  toggleBtn.className = 'btn btn-sm btn-outline-light ms-2';
  toggleBtn.innerHTML = '<i class="fas fa-moon"></i>';
  toggleBtn.onclick = () => {
    const current = body.getAttribute('data-theme');
    body.setAttribute('data-theme', current === 'dark' ? 'light' : 'dark');
    toggleBtn.innerHTML = current === 'dark' ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';
  };
  document.querySelector('.navbar-nav').appendChild(toggleBtn);
}
);

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<div class="container mt-3">


