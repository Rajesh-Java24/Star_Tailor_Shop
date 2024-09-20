<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings Report</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            font-family: "Arial", sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f2f2f2;
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
        .btn-view {
            background-color: #2196F3;
            color: white;
        }
        .btn-view:hover {
            background-color: #1e87db;
        }
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
        .btn-delete:hover {
            background-color: #e53935;
        }
        .message {
            text-align: center;
            margin: 15px 0;
            color: green;
        }
        .error {
            text-align: center;
            margin: 15px 0;
            color: red;
        }
        .search-print {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .search-box {
            width: 200px;
            margin-right: 10px;
            margin-left: 820px;
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
        function printTable() {
            var printContents = document.getElementById('bookingTable').outerHTML;
            var originalContents = document.body.innerHTML;
            document.body.innerHTML = printContents;
            window.print();
            document.body.innerHTML = originalContents;
        }

        function searchTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("bookingTable");
            tr = table.getElementsByTagName("tr");
            for (i = 1; i < tr.length; i++) {
                tr[i].style.display = "none";
                td = tr[i].getElementsByTagName("td");
                for (var j = 0; j < td.length; j++) {
                    if (td[j]) {
                        txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                    }
                }
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
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="supplierReport.jsp" id="navbarDropdown" role="button">Suppliers Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="materialReport.jsp" id="navbarDropdown" role="button">Materials Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link" href="productReport.jsp" id="navbarDropdown" role="button">Products Report</a>
                </li>
                <li class="nav-item dropdown active">
                    <a class="nav-link" href="bookingReport.jsp" id="navbarDropdown" role="button">Bookings Report</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link" href="storeInSales.jsp" id="navbarDropdown" role="button">Sales Report</a>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link dropdown-toggle" href="bookingReport.jsp" id="navbarDropdown" role="button">Employee Details</a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="addEmployee.jsp">Add Employee</a>
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
    <h1 class="my-4 text-center">Bookings Report</h1>
    <div class="search-print">
        <input type="text" id="searchInput" onkeyup="searchTable()" class="form-control search-box" placeholder="Search bookings...">
        <button onclick="printTable()" class="btn btn-dark">Print</button>
    </div>
    <%
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            String message = "";
            String error = "";

            
            // Fetch bookings
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                String query = "SELECT * FROM customerbooking";
                pst = conn.prepareStatement(query);
                rs = pst.executeQuery();
        %>

    <!-- Display Customer Bookings Table -->
    <table id="bookingTable" class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Customer Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Address</th>
                <th>Product Name</th>
                <th>Material Type</th>
                <th>Body Size</th>
                <th>Quantity</th>
                
            </tr>
        </thead>
        <tbody>
            
               <%
                            while (rs.next()) {
                                int bookingId = rs.getInt("booking_id");
                                String customerName = rs.getString("customer_name");
                                String phone = rs.getString("phone");
                                String email = rs.getString("email");
                                String address = rs.getString("address");
                                String productName = rs.getString("product_name");
                                String materialType = rs.getString("material_type");
                                String bodySize = rs.getString("body_size");
                                int productQuantity = rs.getInt("product_quantity");
                               
                        %>
                <tr id="booking-<%= bookingId %>">
                    <td><%= bookingId %></td>
                    <td><%= customerName %></td>
                    <td><%= phone %></td>
                    <td><%= email %></td>
                    <td><%= address %></td>
                    <td><%= productName %></td>
                    <td><%= materialType %></td>
                    <td><%= bodySize %></td>
                    <td><%= productQuantity %></td>
                    
                </tr>
                <%
                }
            %>
            <% } catch (Exception e) {
                e.printStackTrace();
                error = "Error fetching bookings: " + e.getMessage();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pst != null) pst.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } %>
        </tbody>
    </table>
    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <% if (!error.isEmpty()) { %>
        <div class="error"><%= error %></div>
    <% } %>
</div>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
