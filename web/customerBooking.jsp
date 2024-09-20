<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@page import="com.utility.EmailUtility"%> <!-- Adjust the package name accordingly -->


<!DOCTYPE html>
<html>
<head>
    <title>Book Product</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <script>
        function updatePrice() {
            var price = parseFloat(document.getElementById("product_price").value) || 0;
            var quantity = parseInt(document.getElementById("product_quantity").value) || 0;
            var totalPrice = price * quantity;
            document.getElementById("total_price").value = totalPrice.toFixed(2);
        }
    </script>
    <style>
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .card {
            margin: auto;
            max-width: 500px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            background-color: #f9f9f9;
        }
        .card img {
            width: 200px;
            height: 200px;
            object-fit: contain;
            border-radius: 8px;
            display: block;
            margin: 0 auto;
        }
        .card h3 {
            margin: 10px 0;
        }
        .card p {
            margin: 5px 0;
        }
        .card button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .card button:hover {
            background-color: #45a049;
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
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
<!-- Main Content -->
<div class="main-content">
    <div class="container">
        <div class="card">
            <div class="card-body">
                <h2>Book Product</h2>
                <%
                    String message = "";
                    String error = "";
                    Connection conn = null;
                    PreparedStatement pst = null;

                    // Retrieve product ID from the request
                    int productId = 0;
                    if (request.getParameter("product_id") != null) {
                        try {
                            productId = Integer.parseInt(request.getParameter("product_id"));
                        } catch (NumberFormatException e) {
                            error = "Invalid product ID!";
                            productId = 0;
                        }
                    } else {
                        error = "First choose Product";
                    }

                    // Fetch product details based on product ID
                    String productName = "";
                    String materialType = "";
                    String bodySize = "";
                    BigDecimal price = BigDecimal.ZERO;
                    String color = "";
                    int productQuantity = 0;

                    if (productId > 0) {
                        try {
                            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                            conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                            String query = "SELECT product_name, product_price, product_quantity, color FROM Product2 WHERE product_id = ?";
                            pst = conn.prepareStatement(query);
                            pst.setInt(1, productId);
                            ResultSet rs = pst.executeQuery();

                            if (rs.next()) {
                                productName = rs.getString("product_name");
                                price = rs.getBigDecimal("product_price");
                                color = rs.getString("color");
                                productQuantity = rs.getInt("product_quantity");
                            } else {
                                error = "Product not found!";
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            error = "Error fetching product details: " + e.getMessage();
                        } finally {
                            try {
                                if (pst != null) pst.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }

                    // Handle form submission
                    if ("POST".equalsIgnoreCase(request.getMethod()) && productId > 0) {
                        String customerName = request.getParameter("customer_name");
                        String phone = request.getParameter("phone");
                        String email = request.getParameter("email");
                        String address = request.getParameter("address");
                        String materialTypeValue = request.getParameter("material_type");
                        String bodySizeValue = request.getParameter("body_size");
                        String colors = request.getParameter("color");
                        String productPrice = request.getParameter("product_price");
                        int bookedQuantity = 0;

                        try {
                            bookedQuantity = Integer.parseInt(request.getParameter("product_quantity"));
                        } catch (NumberFormatException e) {
                            error = "Invalid quantity!";
                            bookedQuantity = 0;
                        }

                        if (customerName != null && !customerName.isEmpty()) {
                            BigDecimal totalPrice = price.multiply(BigDecimal.valueOf(bookedQuantity));
                            try {
                                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                                String insertQuery = "exec add_customerbooking ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
                                pst = conn.prepareStatement(insertQuery);
                                pst.setString(1, customerName);
                                pst.setString(2, phone);
                                pst.setString(3, email);
                                pst.setString(4, address);
                                pst.setString(5, productName);
                                pst.setString(6, materialTypeValue);
                                pst.setString(7, bodySizeValue);
                                pst.setString(8, colors);
                                pst.setInt(9, bookedQuantity);
                                pst.setBigDecimal(10, totalPrice);

                                int rowsInserted = pst.executeUpdate();
                                if (rowsInserted > 0) {
                                    message = "Booking successful!";

                                    // Send confirmation email
                                    String subject = "Booking Confirmation";
                                    String content = "Dear " + customerName + ",\n\n" +
                                                     "Thank you for your booking! Here are your booking details:\n" +
                                                     "Product Name: " + productName + "\n" +
                                                     "Body Size: " + bodySizeValue +"\n" +
                                                     "Color: " + colors + "\n" +
                                                     "Quantity: " + bookedQuantity + "\n" +
                                                     "Total Price: " + totalPrice.toPlainString() + "\n\n" +
                                                     "Best regards,\nStar Tailor";
                                    EmailUtility.sendEmail(email, subject, content);

                                    // Redirect to payment page
                                    // response.sendRedirect("payment.jsp?product_id=" + productId + "&quantity=" + bookedQuantity + "&total_price=" + totalPrice.toPlainString());
                                } else {
                                    error = "Booking failed!";
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                error = "Error processing booking: " + e.getMessage();
                            } finally {
                                try {
                                    if (pst != null) pst.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        } else {
                            error = "Customer name is required!";
                        }
                    }

                %>

                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-success"><%= message %></div>
                <% } %>
                <% if (!error.isEmpty()) { %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>

                <form method="post" action="customerBooking.jsp">
                    <input type="hidden" name="product_id" value="<%= productId %>">
                    <div class="form-group">
                        <label for="customer_name">Customer Name:</label>
                        <input type="text" id="customer_name" name="customer_name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone:</label>
                        <input type="text" id="phone" name="phone" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Address:</label>
                        <textarea id="address" name="address" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="product_name">Product Name:</label>
                        <input type="text" id="product_name" name="product_name" class="form-control" value="<%= productName %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="product_price">Product Price:</label>
                        <input type="text" id="product_price" name="product_price" class="form-control" value="<%= price %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="product_quantity">Quantity:</label>
                        <input type="number" id="product_quantity" name="product_quantity" class="form-control" <%= productQuantity %>" required oninput="updatePrice()">
                    </div>
                    <div class="form-group">
                        <label for="total_price">Total Price:</label>
                        <input type="text" id="total_price" name="total_price" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label for="material_type">Material Type:</label>
                        <select id="material_type" name="material_type" class="form-control" required>
                            <option value="" disabled selected>Select Material Type</option>
                            <option value="Cotton">Cotton</option>
                            <option value="Wool">Wool</option>
                            <option value="Silk">Silk</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="body_size">Body Size:</label>
                        <select id="body_size" name="body_size" class="form-control" required>
                            <option value="" disabled selected>Select Body Size</option>
                            <option value="Small">Small</option>
                            <option value="Medium">Medium</option>
                            <option value="Large">Large</option>
                            <option value="Extra Large">Extra Large</option>
                            <option value="Extra Extra Large">Extra Extra Large</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="color">Color:</label>
                        <input type="text" id="color" name="color" class="form-control" value="<%= color %>" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Book Now</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
