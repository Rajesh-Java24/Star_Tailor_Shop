<%@page import="com.utility.EmailUtility"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Material</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: "Arial", sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            margin: auto;
            max-width: 500px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Supplier Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="addSupplier.jsp">Add Supplier</a>
                        <a class="dropdown-item" href="viewSuppliers.jsp">View Supplier List</a>
                    </div>
                </li>
                <li class="nav-item dropdown ">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Material Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item active" href="addMaterial.jsp">Add Materials</a>
                        <a class="dropdown-item" href="viewMaterials.jsp">View Material List</a>
                    </div>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Product Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="product.jsp">Add Products</a>
                        <a class="dropdown-item" href="viewProducts.jsp">View Product List</a>
                    </div>
                </li>
                <li class="nav-item dropdown active">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Booking Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="viewCustomerBooking.jsp">View Booking List</a>
                    </div>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Communication
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="sendEmail.jsp">Send Email</a>
                    </div>
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
        <h2 class="my-4 text-center">Edit Booking</h2>
        
        <div class="row justify-content-center">
        <div class="card col-md-7">
            <div class="card-body">
        <%
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            String message = "";
            String error = "";
            int bookingId = 0;
            String customerName = "";
            String phone = "";
            String email = "";
            String address = "";
            String productName = "";
            String materialType = "";
            String bodySize = "";
            String color = "";
            int productQuantity = 0;
            String status = "";

            // Handle booking ID retrieval
            String bookingIdParam = request.getParameter("booking_id");
            if (bookingIdParam != null && !bookingIdParam.isEmpty()) {
                try {
                    bookingId = Integer.parseInt(bookingIdParam);
                } catch (NumberFormatException e) {
                    error = "Invalid booking ID format!";
                }
            } else {
                error = "Booking ID not provided!";
            }

            // Fetch booking details if ID is valid
            if (bookingId > 0 && error.isEmpty()) {
                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    String query = "SELECT * FROM customerbooking WHERE booking_id = ?";
                    pst = conn.prepareStatement(query);
                    pst.setInt(1, bookingId);
                    rs = pst.executeQuery();

                    if (rs.next()) {
                        customerName = rs.getString("customer_name");
                        phone = rs.getString("phone");
                        email = rs.getString("email");
                        address = rs.getString("address");
                        productName = rs.getString("product_name");
                        materialType = rs.getString("material_type");
                        bodySize = rs.getString("body_size");
                        color = rs.getString("color");
                        productQuantity = rs.getInt("product_quantity");
                        status = rs.getString("status");
                    } else {
                        error = "Booking not found!";
                    }
                } catch (Exception e) {
                    error = "Error fetching booking details: " + e.getMessage();
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pst != null) pst.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

            // Handle form submission
            if ("POST".equalsIgnoreCase(request.getMethod()) && bookingId > 0 && error.isEmpty()) {
                customerName = request.getParameter("customer_name");
                phone = request.getParameter("phone");
                email = request.getParameter("email");
                address = request.getParameter("address");
                materialType = request.getParameter("material_type");
                bodySize = request.getParameter("body_size");
                color = request.getParameter("color");
                try {
                    productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
                } catch (NumberFormatException e) {
                    error = "Invalid product quantity!";
                }
                status = request.getParameter("status");

                if (customerName != null && !customerName.isEmpty()) {
                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                        String updateQuery = "UPDATE customerbooking SET customer_name = ?, phone = ?, email = ?, address = ?, material_type = ?, body_size = ?, color = ?, product_quantity = ?, status = ? WHERE booking_id = ?";
                        pst = conn.prepareStatement(updateQuery);
                        pst.setString(1, customerName);
                        pst.setString(2, phone);
                        pst.setString(3, email);
                        pst.setString(4, address);
                        pst.setString(5, materialType);
                        pst.setString(6, bodySize);
                        pst.setString(7, color);
                        pst.setInt(8, productQuantity);
                        pst.setString(9, status);
                        pst.setInt(10, bookingId);

                        int rowsUpdated = pst.executeUpdate();
                        if (rowsUpdated > 0) {
                            message = "Booking updated successfully!";
                            
                            // Send email notification
                            String subject = "Booking Status Updated";
                            String content = "Dear " + customerName + ",\n\n"
                                            + "Your booking status has been updated to: " + status + ".\n\n"
                                            + "Details:\n"
                                            + "Product: " + productName + "\n"
                                            + "material_type: " + materialType +"\n"
                                            + "body_size: " + bodySize + "\n"
                                            + "color: " + color + "\n"
                                            + "Quantity: " + productQuantity + "\n"
                                            + "Status: " + status + "\n\n"
                                            + "Thank you for choosing Star Tailor!";
                            
                            try {
                                EmailUtility.sendEmail(email, subject, content);
                            } catch (Exception e) {
                                error = "Error sending email: " + e.getMessage();
                            }
                        } else {
                            error = "Update failed!";
                        }
                    } catch (Exception e) {
                        error = "Error updating booking: " + e.getMessage();
                        e.printStackTrace();
                    } finally {
                        try {
                            if (pst != null) pst.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    error = "Please provide all the required fields!";
                }
            }
        %>
        <form action="editBooking.jsp" method="post">
            <input type="hidden" name="booking_id" value="<%= bookingId %>">
            <div class="form-group">
                <label for="customer_name">Customer Name:</label>
                <input type="text" id="customer_name" name="customer_name" value="<%= customerName %>" class="form-control" readonly >
            </div>
            <div class="form-group">
                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone" value="<%= phone %>" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= email %>" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <textarea id="address" name="address" class="form-control" readonly><%= address %></textarea>
            </div>
            <div class="form-group">
                <label for="product_name">Product Name:</label>
                <input type="text" id="product_name" name="product_name" value="<%= productName %>" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="material_type">Material Type:</label>
                <input type="text" id="material_type" name="material_type" value="<%= materialType %>" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="body_size">Body Size:</label>
                <input type="text" id="body_size" name="body_size" value="<%= bodySize %>" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="color">Color:</label>
                <input type="text" id="color" name="color" value="<%= color %>" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="product_quantity">Product Quantity:</label>
                <input type="number" id="product_quantity" name="product_quantity" value="<%= productQuantity %>" class="form-control" readonly >
            </div>
            <div class="form-group">
                <label for="status">Status:</label>
                <select id="status" name="status" class="form-control">
                    <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                    <option value="In Progress" <%= "In Progress".equals(status) ? "selected" : "" %>>In Progress</option>
                    <option value="Completed" <%= "Completed".equals(status) ? "selected" : "" %>>Completed</option>
                    <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                </select>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Update Booking</button>
            </div>
            <% if (!message.isEmpty()) { %>
                <div class="alert alert-success"><%= message %></div>
            <% } %>
            <% if (!error.isEmpty()) { %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>
        </form>
    </div>
        </div>
        </div>
    </div>
        
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
