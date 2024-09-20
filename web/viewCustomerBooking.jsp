<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Customer Bookings</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
    body {
        font-family: "Arial", sans-serif;
        background-color: #f8f9fa;
    }
    .container {
        margin-top: 30px;
    }
    table {
        width: 85%; /* Reduce table width */
        border-collapse: collapse;
        margin-top: 15px;
    }
    th, td {
        padding: 8px; /* Reduce padding */
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
        margin: 10px 0; /* Reduce margin */
        color: green;
    }
    .error {
        text-align: center;
        margin: 10px 0; /* Reduce margin */
        color: red;
    }
</style>

</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
    <a class="navbar-brand" href="#">Star Tailor</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="employee_dashboard.jsp">Home</a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Supplier Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="addSupplier.jsp">Add Supplier</a>
                    <a class="dropdown-item" href="viewSuppliers.jsp">View Supplier List</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Material Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="addMaterial.jsp">Add Materials</a>
                    <a class="dropdown-item" href="viewMaterials.jsp">View Material List</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Product Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="product.jsp">Add Products</a>
                    <a class="dropdown-item" href="viewProducts.jsp">View Product List</a>
                </div>
            </li>
            <li class="nav-item dropdown active">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Booking Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item active" href="viewCustomerBooking.jsp">View Booking List</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                    <a class="nav-link dropdown" href="sendEmail.jsp" id="navbarDropdown" role="button">
                        Communication
                    </a>
                </li>
            <li class="nav-item dropdown profile-dropdown">
                    <a href="#" class="nav-link dropdown-toggle" id="profileDropdown" role="button" data-toggle="dropdown">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNVDiqtBCIKFXeL9pBcRr5P--loPgYsfE5hqt9TwvBScfdnaPFexChVvUkucG3r6tbjdA&usqp=CAU" alt="User Profile Picture" class="rounded-circle" width="30" height="30">
                        <% 
                            String username = (String) session.getAttribute("username");
                            String role = (String) session.getAttribute("role");
                        %>
                        <%= username %>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="profileDropdown">
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
    <h1 class="my-4 text-center">Booking List</h1>
    <div class="row justify-content-center">
    <%
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            String message = "";
            String error = "";

            // Handle delete request
            if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete_id") != null) {
                int bookingIdToDelete = Integer.parseInt(request.getParameter("delete_id"));

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    String deleteQuery = "DELETE FROM customerbooking WHERE booking_id = ?";
                    pst = conn.prepareStatement(deleteQuery);
                    pst.setInt(1, bookingIdToDelete);

                    int rowsDeleted = pst.executeUpdate();
                    if (rowsDeleted > 0) {
                        message = "Booking deleted successfully!";
                    } else {
                        error = "Failed to delete booking!";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    error = "Error deleting booking: " + e.getMessage();
                } finally {
                    try {
                        if (pst != null) pst.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

            // Fetch bookings
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                String query = "SELECT * FROM customerbooking";
                pst = conn.prepareStatement(query);
                rs = pst.executeQuery();
        %>

    <!-- Display Customer Bookings Table -->
    <table class="table table-bordered table-hover">
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
                <th>Product Color</th>
                <th>Quantity</th>
                <th>Status</th>
                <th>Actions</th>
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
                                String color = rs.getString("color");
                                int productQuantity = rs.getInt("product_quantity");
                                String status = rs.getString("status");
                               
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
                    <td><%= color %></td>
                    <td><%= productQuantity %></td>
                    <td><%= status %></td>
                    <td>
                        <div class="btn-group" role="group">
                            <form action="editBooking.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="booking_id" value="<%= bookingId %>">
                                <button type="submit" class="btn btn-warning mr-2">Edit</button>
                            </form>
                            
                            <form method="post" style="display:inline;">
                                <input type="hidden" name="delete_id" value="<%= bookingId %>">
                                <button class="btn btn-delete mr-2" type="submit">Delete</button>
                            </form>
                                <form action="bookingDetails.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="booking_id" value="<%= bookingId %>">
                                <input type="hidden" name="product_quantity" value="<%= productQuantity %>">
                                <button type="submit" class="btn btn-success mr-2">View</button>
                            </form>
                        </div>
                    </td>
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
</div>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
