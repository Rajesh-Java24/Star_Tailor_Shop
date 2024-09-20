<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee List</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        .container {
            margin-top: 50px;
        }
        .table th {
            background-color: #007bff;
            color: white;
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
    <script>
        function deleteEmployee(empId) {
            if (confirm('Are you sure you want to delete this employee?')) {
                document.getElementById('deleteEmployeeId').value = empId;
                document.getElementById('deleteEmployeeForm').submit();
            }
        }
    </script>
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
                <li class="nav-item dropdown">
                    <a class="nav-link" href="supplierReport.jsp" id="navbarDropdown" role="button">Suppliers Report</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link" href="materialReport.jsp" id="navbarDropdown" role="button">Materials Report</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link" href="productReport.jsp" id="navbarDropdown" role="button">Products Report</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link" href="bookingReport.jsp" id="navbarDropdown" role="button">Bookings Report</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link" href="storeInSales.jsp" id="navbarDropdown" role="button">Sales Report</a>
                </li>
                <li class="nav-item dropdown active">
                    <a class="nav-link dropdown-toggle" href="bookingReport.jsp" id="navbarDropdown" role="button">Employee Details</a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="addEmployee.jsp">Add Employee</a>
                        <a class="dropdown-item active" href="employeeList.jsp">View Employee List</a>
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
        <div class="card">
            <div class="card-header">
                <h2 class="my-4 text-center">Edit Employee</h2>
            </div>
            <div class="card-body">
                <% 
                String empId = request.getParameter("empId");
                String empName = "";
                String phone = "";
                String email = "";
                String position = "";
                double salary = 0.0;

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    // Get employee details
                    String selectSql = "exec fetch_employees ?";
                    PreparedStatement selectStmt = conn.prepareStatement(selectSql);
                    selectStmt.setString(1, empId);
                    ResultSet rs = selectStmt.executeQuery();

                    if (rs.next()) {
                        empName = rs.getString("emp_Name");
                        phone = rs.getString("phone");
                        email = rs.getString("email");
                        position = rs.getString("position");
                        salary = rs.getDouble("salary");
                    }

                    rs.close();
                    selectStmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
                <form action="editEmployee.jsp" method="post">
                    <input type="hidden" name="empId" value="<%= empId %>">
                    <div class="form-group">
                        <label for="empName">Name:</label>
                        <input type="text" class="form-control" id="empName" name="empName" value="<%= empName %>" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone:</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="<%= phone %>" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
                    </div>
                    <div class="form-group">
                        <label for="position">Position:</label>
                        <input type="text" class="form-control" id="position" name="position" value="<%= position %>" required>
                    </div>
                    <div class="form-group">
                        <label for="salary">Salary:</label>
                        <input type="number" step="0.01" class="form-control" id="salary" name="salary" value="<%= salary %>" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Employee</button>
                </form>
                <br>
                <a href="employeeList.jsp" class="btn btn-secondary">Back to Employee List</a>
            </div>
        </div>
    </div>

    <% 
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Retrieve form data
            String newEmpId = request.getParameter("empId");
            String newEmpName = request.getParameter("empName");
            String newPhone = request.getParameter("phone");
            String newEmail = request.getParameter("email");
            String newPosition = request.getParameter("position");
            double newSalary = Double.parseDouble(request.getParameter("salary"));

            // Load the SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

            // Update employee in employees table
            String updateSql = "exec update_employee ?,?,?,?,?,?";
            PreparedStatement stmt = conn.prepareStatement(updateSql);
            stmt.setString(1, newEmpName);
            stmt.setString(2, newPhone);
            stmt.setString(3, newEmail);
            stmt.setString(4, newPosition);
            stmt.setDouble(5, newSalary);
            stmt.setString(6, newEmpId);
            stmt.executeUpdate();

            // Close resources
            stmt.close();
            conn.close();

            // Redirect back to employee list
            response.sendRedirect("employeeList.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    %>
    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
