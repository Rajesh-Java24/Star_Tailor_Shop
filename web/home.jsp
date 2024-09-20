<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sidebar Dropdown</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome CSS (for icons) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            font-family: "Lato", sans-serif;
        }
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #111;
            padding-top: 20px;
        }
        .sidebar a {
            padding: 10px 15px;
            text-decoration: none;
            font-size: 18px;
            color: white;
            display: block;
        }
        .sidebar a:hover {
            background-color: #575757;
        }
        .sidebar .dropdown-menu {
            display: none;
            background-color: #333;
            padding-left: 20px;
        }
        .sidebar .dropdown-menu a {
            padding: 10px 15px;
            font-size: 16px;
        }
        .sidebar .dropdown:hover .dropdown-menu {
            display: block;
        }
        .caret-icon {
            float: right;
            margin-top: 5px;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        .navbar {
            margin-left: 250px;
        }
        .navbar-nav .nav-link:hover {
            background-color: #f8f9fa;
            color: #000;
        }
        .navbar-nav .nav-link:active {
            background-color: #007bff;
            color: white !important;
        }
        .profile-section {
            padding: 15px;
            background-color: #333;
            color: white;
            text-align: center;
            margin-bottom: 20px;
        }
        .profile-section img {
            border-radius: 50%;
            width: 80px;
            height: 80px;
            margin-bottom: 10px;
        }
        .profile-section h4 {
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <a href="#home">*STAR TAILOR*</a><br><br>
        <div class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <img src="https://via.placeholder.com/80" alt="User Profile Picture" class="rounded-circle" width="30" height="30">
                <span><%= username %></span> 
            </a>
            <div class="dropdown-menu">
                <a href="#" class="dropdown-item disabled"><%= role %></a>
                <div class="dropdown-divider"></div>
                <a href="userProfile.jsp" class="dropdown-item">Profile</a>
                <a href="logout.jsp" class="dropdown-item">Logout</a>
            </div>
        </div>
        <a href="#home">Home</a>
        <div class="dropdown">
            <a href="#" class="dropdown-toggle">Orders</a>
            <div class="dropdown-menu">
                <a href="addOrder.jsp">Add Order</a>
                <a href="orderHistory.jsp">Order History</a>
                
            </div>
        </div>
        <div class="dropdown">
            <a href="#" class="dropdown-toggle">Dropdown 2</a>
            <div class="dropdown-menu">
                <a href="#">Link 4</a>
                <a href="#">Link 5</a>
                <a href="#">Link 6</a>
            </div>
        </div>
        <a href="#about">About</a>
    </div>

    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Contact</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link logout-btn" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <h1>Welcome, <%= username %>!</h1>
            <h2>Welcome to the Dashboard</h2>
            <p>This is your main content area.</p>
            <!-- Add your content here -->
        </div>
    </div>
    
    <!-- Bootstrap JS and dependencies (jQuery and Popper.js) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Font Awesome JS (for icons) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
</body>
</html>