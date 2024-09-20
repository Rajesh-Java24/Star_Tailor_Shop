<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <h2 class="my-4 text-center">Employee List</h2>
        <div class="text-right add-button">
        <a href="addEmployee.jsp" class="btn btn-primary mb-3">Add New Employee</a>
        </div>
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Position</th>
                    <th>Salary</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("deleteEmployeeId") != null) {
                        String deleteEmployeeId = request.getParameter("deleteEmployeeId");
                        try {
                            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                            String deleteQuery = "DELETE FROM employees WHERE emp_Id = ?";
                            PreparedStatement pstmt = conn.prepareStatement(deleteQuery);
                            pstmt.setString(1, deleteEmployeeId);
                            pstmt.executeUpdate();
                            pstmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    }

                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                        String selectSql = "SELECT * FROM employees";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(selectSql);

                        while (rs.next()) {
                            String empId = rs.getString("emp_Id");
                            String empName = rs.getString("emp_Name");
                            String phone = rs.getString("phone");
                            String email = rs.getString("email");
                            String position = rs.getString("position");
                            double salary = rs.getDouble("salary");

                            out.println("<tr id='employee-" + empId + "'>");
                            out.println("<td>" + empId + "</td>");
                            out.println("<td>" + empName + "</td>");
                            out.println("<td>" + phone + "</td>");
                            out.println("<td>" + email + "</td>");
                            out.println("<td>" + position + "</td>");
                            out.println("<td>" + salary + "</td>");
                            out.println("<td>");
                            out.println("<a href='editEmployee.jsp?empId=" + empId + "' class='btn btn-warning btn-sm'>Edit</a> ");
                            out.println("<button onclick='deleteEmployee(\"" + empId + "\")' class='btn btn-danger btn-sm'>Delete</button>");
                            out.println("</td>");
                            out.println("</tr>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    <form id="deleteEmployeeForm" method="POST" style="display:none;">
        <input type="hidden" id="deleteEmployeeId" name="deleteEmployeeId">
    </form>
    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
