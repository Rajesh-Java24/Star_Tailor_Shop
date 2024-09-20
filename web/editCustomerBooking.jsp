<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
    }

    String message = "";
    int bookingId = 0;

    try {
        bookingId = Integer.parseInt(request.getParameter("booking_id"));
    } catch (NumberFormatException e) {
        // Handle invalid booking ID gracefully
        out.println("Invalid booking ID.");
        return; // Stop processing further if booking ID is invalid
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && bookingId > 0) {
        String customerName = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String materialType = request.getParameter("material_type");
        String bodySize = request.getParameter("body_size");
        String color = request.getParameter("color");
        int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));

        if (customerName != null && !customerName.isEmpty()) {
            Connection conn = null;
            PreparedStatement pst = null;

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                String updateQuery = "UPDATE customerbooking SET customer_name = ?, phone = ?, email = ?, address = ?, material_type = ?, body_size = ?, color=?, product_quantity = ? WHERE booking_id = ?";
                pst = conn.prepareStatement(updateQuery);
                pst.setString(1, customerName);
                pst.setString(2, phone);
                pst.setString(3, email);
                pst.setString(4, address);
                pst.setString(5, materialType);
                pst.setString(6, bodySize);
                pst.setString(7,color);
                pst.setInt(8, productQuantity);
                pst.setInt(9, bookingId);

                int rowsUpdated = pst.executeUpdate();
                if (rowsUpdated > 0) {
                    message = "Booking updated successfully!";
                    response.sendRedirect("orderhistory.jsp"); // Redirect after successful update
                } else {
                    message = "Failed to update booking!";
                }
            } catch (Exception e) {
                message = "Error updating booking: " + e.getMessage();
            } finally {
                try {
                    if (pst != null) pst.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            message = "Customer name is required!";
        }
    }

    // Fetch booking details
    String customerName = "";
    String phone = "";
    String email = "";
    String address = "";
    String productName = "";
    String materialType = "";
    String bodySize = "";
    String color = "";
    int productQuantity = 0;

    if (bookingId > 0) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

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
                productName = rs.getString("product_name"); // Assuming product name is fetched elsewhere
                materialType = rs.getString("material_type");
                bodySize = rs.getString("body_size");
                color = rs.getString("color");
                productQuantity = rs.getInt("product_quantity");
            } else {
                message = "Booking not found!";
            }
        } catch (Exception e) {
            message = "Error fetching booking details: " + e.getMessage();
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
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Booking</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome CSS (for icons) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .container {
            width: 40%;
            margin-top: 30px;
            margin-left: 510px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            
            background-color: #f9f9f9;
        }
        .container h2 {
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        .form-group input[readonly] {
            background-color: #f9f9f9;
        }
        .form-group button {
            background-color: #007bff; /* Changed button color to blue */
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            display: block;
            width: 100%;
        }
        .form-group button:hover {
            background-color: #0056b3; /* Darker blue on hover */
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
</head>
<body>
    <!-- Sidebar -->
<div class="sidebar">
    <a href="#home">*STAR TAILOR*</a><br><br>
    <div class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNVDiqtBCIKFXeL9pBcRr5P--loPgYsfE5hqt9TwvBScfdnaPFexChVvUkucG3r6tbjdA&usqp=CAU" alt="User Profile Picture" class="rounded-circle" width="30" height="30">
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
        <h2>Edit Booking</h2>
        <%
            if (!message.isEmpty()) {
        %>
        <div class="message"><%= message %></div>
        <% } %>
        <form method="post" action="editCustomerBooking.jsp?booking_id=<%= bookingId %>">
            <div class="form-group">
                <label for="customer_name">Customer Name:</label>
                <input type="text" id="customer_name" name="customer_name" value="<%= customerName %>" required>
            </div>
            <div class="form-group">
                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone" value="<%= phone %>" readonly>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= email %>" readonly>
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <textarea id="address" name="address" required><%= address %></textarea>
            </div>
            <div class="form-group">
                <label for="product_name">Product Name:</label>
                <input type="text" id="product_name" name="product_name" value="<%= productName %>" readonly>
            </div>
            <div class="form-group">
                <label for="material_type">Material Type:</label>
                <select id="material_type" name="material_type" required>
                    <option value="">Select material type</option>
                    <option value="Cotton" <%= materialType.equals("Cotton") ? "selected" : "" %>>Cotton</option>
                    <option value="Polyester" <%= materialType.equals("Polyester") ? "selected" : "" %>>Polyester</option>
                    <option value="Nylon" <%= materialType.equals("Nylon") ? "selected" : "" %>>Nylon</option>
                </select>
            </div>
            <div class="form-group">
                <label for="body_size">Body Size:</label>
                <select id="body_size" name="body_size" required>
                    <option value="" disabled selected>Select body size</option>
                    <option value="Small" <%= bodySize.equals("Small") ? "selected" : "" %>>Small</option>
                    <option value="Medium" <%= bodySize.equals("Medium") ? "selected" : "" %>>Medium</option>
                    <option value="Large" <%= bodySize.equals("Large") ? "selected" : "" %>>Large</option>
                    <option value="Extra Large" <%= bodySize.equals("Extra Large") ? "selected" : "" %>>Extra Large</option>
                    <option value="Extra Extra Large" <%= bodySize.equals("Extra Extra Large") ? "selected" : "" %>>Extra Extra Large</option>
                </select>
            </div>
                <div class="form-group">
                <label for="color">Product Color:</label>
                <input type="text" id="color" name="color" value="<%= color %>" required>
            </div>
            <div class="form-group">
                <label for="product_quantity">Quantity:</label>
                <input type="number" id="product_quantity" name="product_quantity" value="<%= productQuantity %>" required>
            </div>
            <div class="form-group">
                <button type="submit">Update Booking</button>
            </div>
        </form>
    </div>
            <!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
