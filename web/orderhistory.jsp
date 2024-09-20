<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking History</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="path/to/your/custom.css">
    <style>
        body {
            font-family: "Arial", sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        table {
            width: 80%;
            border-collapse: collapse;
            margin-top: 20px;
            margin-left: 90px;
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
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .sidebar {
            height: 100vh;
            width: 220px;
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
           background-color: #007bff;
            color: white;
            text-decoration: none;
        }
        .sidebar a.active {
            background-color: #007bff;
            color: white;
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
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNVDiqtBCIKFXeL9pBcRr5P--loPgYsfE5hqt9TwvBScfdnaPFexChVvUkucG3r6tbjdA&usqp=CAU" alt="User Profile Picture" class="rounded-circle" width="30" height="30">
                <% String username = (String) session.getAttribute("username"); %>
                <span><%= username %></span>
            </a>
            <div class="dropdown-menu">
                <a href="#" class="dropdown-item disabled"><%= session.getAttribute("role") %></a>
                <div class="dropdown-divider"></div>
                <a href="userProfile.jsp" class="dropdown-item">Profile</a>
                <a href="logout.jsp" class="dropdown-item">Logout</a>
            </div>
        </div><br>
        <a href="customer_dashboard.jsp" class="<%= request.getRequestURI().contains("customer_dashboard.jsp") ? "active" : "" %>">Home</a>
        <div class="dropdown">
            <a href="#" class="dropdown-toggle <%= request.getRequestURI().contains("customerVisible.jsp") || request.getRequestURI().contains("customerBooking.jsp") ? "active" : "" %>">Products</a>
            <div class="dropdown-menu">
                <a href="customerVisible.jsp" class="<%= request.getRequestURI().contains("customerVisible.jsp") ? "active" : "" %>">Available Products</a>
                <a href="customerBooking.jsp" class="<%= request.getRequestURI().contains("customerBooking.jsp") ? "active" : "" %>">Customer Booking</a>
            </div>
        </div>
        <div class="dropdown">
            <a href="#" class="dropdown-toggle <%= request.getRequestURI().contains("viewBooking.jsp") ? "active" : "" %>">Booking Details</a>
            <div class="dropdown-menu">
                <a href="orderhistory.jsp" class="<%= request.getRequestURI().contains("viewBooking") ? "active" : "" %>">View Booking List</a>
            </div>
        </div>
    </div>

    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="customer_dashboard.jsp">Home <span class="sr-only">(current)</span></a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h1 class="my-4 text-center">Booking History</h1>
        <div class="justify-content-center">

        <%
            String customerEmail = (String) session.getAttribute("email");

            if (customerEmail == null) {
                out.println("<div class='alert alert-danger'>You must be logged in to view this page. <a href='login.jsp'>Login</a></div>");
            } else {
                String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) {
        %>
                    <div class="alert <%= message.contains("Error") ? "alert-danger" : "alert-success" %>" role="alert">
                        <%= message %>
                    </div>
        <% 
                } 

                // Deletion logic
                String deleteId = request.getParameter("delete_id");
                if (deleteId != null && !deleteId.isEmpty()) {
                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                        String deleteSql = "DELETE FROM customerbooking WHERE booking_id = ? AND email = ?";
                        PreparedStatement deletePst = conn.prepareStatement(deleteSql);
                        deletePst.setInt(1, Integer.parseInt(deleteId));
                        deletePst.setString(2, customerEmail);

                        int rowsAffected = deletePst.executeUpdate();

                        if (rowsAffected > 0) {
                            response.sendRedirect("orderhistory.jsp?message=Booking deleted successfully");
                        } else {
                            response.sendRedirect("orderhistory.jsp?message=Failed to delete booking");
                        }

                        deletePst.close();
                        conn.close();
                        return; // Stop further processing
                    } catch (Exception e) {
                        response.sendRedirect("orderhistory.jsp?message=Error: " + e.getMessage());
                        return;
                    }
                }
        %>

        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Customer Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Product Name</th>
                    <th>Material Type</th>
                    <th>Body Size</th>
                    <th>Product Color</th>
                    <th>Quantity</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    String sql = "SELECT customer_name, phone, email, address, product_name, material_type, body_size, color, product_quantity, status, booking_id FROM customerbooking WHERE email = ?";
                    PreparedStatement pst = conn.prepareStatement(sql);
                    pst.setString(1, customerEmail);
                    ResultSet rs = pst.executeQuery();

                    while (rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getString("customer_name") %></td>
                            <td><%= rs.getString("phone") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("address") %></td>
                            <td><%= rs.getString("product_name") %></td>
                            <td><%= rs.getString("material_type") %></td>
                            <td><%= rs.getString("body_size") %></td>
                            <td><%= rs.getString("color") %></td>
                            <td><%= rs.getInt("product_quantity") %></td>
                            <td><%= rs.getString("status") %></td>
                            <td class="action-buttons">
                                <a href="editCustomerBooking.jsp?booking_id=<%= rs.getInt("booking_id") %>" class="btn btn-primary">Edit</a>
                                <form class="delete-form" action="orderhistory.jsp" method="POST">
                                    <input type="hidden" name="delete_id" value="<%= rs.getInt("booking_id") %>">
                                    <button type="submit" class="btn btn-danger">Delete</button>
                                </form>
                            </td>
                        </tr>
            <%
                    }

                    rs.close();
                    pst.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
            </tbody>
        </table>
        <% } %>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function () {
            $(".delete-form").submit(function (event) {
                event.preventDefault();
                var form = $(this);

                if (confirm("Are you sure you want to delete this booking?")) {
                    $.ajax({
                        type: "POST",
                        url: form.attr('action'),
                        data: form.serialize(),
                        success: function (response) {
                            window.location.reload();
                        },
                        error: function (xhr, status, error) {
                            alert("Error: " + error);
                        }
                    });
                }
            });
        });
    </script>

</body>
</html>
