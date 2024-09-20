<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Employee</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            margin-top: 50px;
        }
        .card {
            width: 45%;
            margin-left: 350px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            background-color: #f9f9f9;
        }
        .navbar {
            background-color: #343a40;
        }
        .navbar-link, .navbar-text {
            color: #ffffff;
        }
        /* Custom CSS for dropdown hover */
        .nav-item.dropdown:hover .dropdown-menu {
            display: block;
        }
        .nav-item.dropdown .dropdown-menu {
            margin-top: 0;
        }
        .navbar-nav .nav-link:hover {
            background-color: #FFA500;
            color: #000000;
        }
        .navbar-nav .nav-link:active {
            background-color: #007bff;
            color: white !important;
        }
        .navbar-nav .profile-dropdown {
            position: relative;
        }
        .navbar-nav .profile-dropdown .dropdown-menu {
            position: absolute;
            right: 0;
            top: 100%;
            left: auto;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || role == null) {
            response.sendRedirect("login.jsp"); // Redirect to login if session attributes are not set
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <a class="navbar-brand" href="#">Star Tailor</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="admin_dashboard.jsp">Home</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="supplierReport.jsp" id="navbarDropdown" role="button">Suppliers Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="materialReport.jsp" id="navbarDropdown" role="button">Materials Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="productReport.jsp" id="navbarDropdown" role="button">Products Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="bookingReport.jsp" id="navbarDropdown" role="button">Bookings Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="storeInSales.jsp" id="navbarDropdown" role="button">Sales Report</a>
                </li>
                <li class="nav-item dropdown active">
                    <a class="nav-link dropdown-toggle" href="bookingReport.jsp" id="navbarDropdown" role="button">Employee Details</a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item active" href="addEmployee.jsp">Add Employee</a>
                        <a class="dropdown-item" href="employeeList.jsp">View Employee List</a>
                        <a class="dropdown-item " href="employeeReport.jsp">Employee Report</a>
                    </div>
                </li>
                <li class="nav-item profile-dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNVDiqtBCIKFXeL9pBcRr5P--loPgYsfE5hqt9TwvBScfdnaPFexChVvUkucG3r6tbjdA&usqp=CAU" alt="User Profile Picture" class="rounded-circle" width="30" height="30">
                        <span><%= username %></span>
                    </a>
                    <div class="dropdown-menu">
                        <a href="#" class="dropdown-item disabled"><%= role %></a>
                        <div class="dropdown-divider"></div>
                        <a href="userProfile.jsp" class="dropdown-item">Profile</a>
                        <a href="logout.jsp" class="dropdown-item">Logout</a>
                    </div>
                </li>
            </ul>
        </div>
    </nav>
    <div class="container">
        <% 
        boolean showSuccessMessage = false;
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            try {
                // Retrieve form data
                String empId = request.getParameter("empId");
                String empName = request.getParameter("empName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String position = request.getParameter("position");
                double salary = Double.parseDouble(request.getParameter("salary"));

                // Load the SQL Server JDBC driver
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                // Insert employee into employees table
                String insertSql = "exec add_employee ?, ?, ?, ?, ?, ?";
                PreparedStatement stmt = conn.prepareStatement(insertSql);
                stmt.setString(1, empId);
                stmt.setString(2, empName);
                stmt.setString(3, phone);
                stmt.setString(4, email);
                stmt.setString(5, position);
                stmt.setDouble(6, salary);
                stmt.executeUpdate();

                // Close resources
                stmt.close();
                conn.close();

                // Show success message
                showSuccessMessage = true;

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        %>
        <% if (showSuccessMessage) { %>
            <div class="alert alert-success" role="alert">
                Employee details added successfully.
            </div>
        <% } %>
        <div class="card">
            <div class="card-header">
                <h2 class="my-4 text-center">Add Employee</h2>
            </div>
            <div class="card-body">
                <form action="addEmployee.jsp" method="post">
                    <div class="form-group">
                        <label for="empId">Employee ID:</label>
                        <input type="text" class="form-control" id="empId" name="empId" required>
                    </div>
                    <div class="form-group">
                        <label for="empName">Name:</label>
                        <input type="text" class="form-control" id="empName" name="empName" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone:</label>
                        <input type="text" class="form-control" id="phone" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="position">Position:</label>
                        <input type="text" class="form-control" id="position" name="position" required>
                    </div>
                    <div class="form-group">
                        <label for="salary">Salary:</label>
                        <input type="number" step="0.01" class="form-control" id="salary" name="salary" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Employee</button>
                </form>
                <br>
                <a href="employeeList.jsp" class="btn btn-secondary">View Employee List</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
