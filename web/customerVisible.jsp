<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Visible Products</title>
    <style>
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .card {
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            width: 300px;
            padding: 16px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
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
            <span><%= username != null ? username : "Guest" %></span>
        </a>
        <div class="dropdown-menu">
            <% if (username != null) { %>
                <a href="#" class="dropdown-item disabled"><%= session.getAttribute("role") %></a>
                <div class="dropdown-divider"></div>
                <a href="userProfile.jsp" class="dropdown-item">Profile</a>
                <a href="logout.jsp" class="dropdown-item">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="dropdown-item">Login</a>
            <% } %>
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

<div class="main-content">
    <h2 class="text-center">Available Products</h2>
    <div class="card-container">
        <% 
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                String query = "SELECT product_id, product_name, body_size, product_price, photo FROM Product2";
                pst = conn.prepareStatement(query);
                rs = pst.executeQuery();

                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    String productName = rs.getString("product_name");
                    String bodySize = rs.getString("body_size");
                    int product_price = rs.getInt("product_price");
                    String photo = rs.getString("photo");
        %>
        <div class="card">
            <img src="photo/<%= photo %>" alt="Product Photo">
            
            <h3><%= productName %></h3>
            <p>Body Size: <%= bodySize %></p>
            <p style="font-weight: bold;">Product Price: <%= product_price %></p>
            <%
                if (session.getAttribute("username") == null) {
                    // User is not logged in, store product details in session
                    session.setAttribute("product_id", productId);
                    session.setAttribute("product_price", product_price);
                }
            %>
            <form action="<%= (session.getAttribute("username") != null) ? "customerBooking.jsp" : "login.jsp" %>" method="post">
                <input type="hidden" name="product_id" value="<%= productId %>">
                <input type="hidden" name="product_price" value="<%= product_price %>">
                <button type="submit">Book Now</button>
            </form>
        </div>
        <% 
                }
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
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
        %>
    </div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
