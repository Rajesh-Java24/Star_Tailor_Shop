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
            margin-top: 20px;
            margin-left: 10px;
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
        
        
        
        .navbar-nav .nav-link:hover {
            background-color: rgb(255, 165, 0);
            color: #000;
        }
        .navbar-nav .nav-link:active {
            background-color: #007bff;
            color: white !important;
        }
        .navbar {
            background-color: #343a40;
        }
        .navbar-brand, .navbar-text {
            color: #ffffff;
        }
        .form-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .footer {
            text-align: center;
            padding: 10px;
            background-color: #343a40;
            color: #ffffff;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        
        
        
    </style>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<!-- Navigation bar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <a class="navbar-brand" href="#">Star Tailor</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="home1.jsp">Home</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="customerVisibleHome.jsp">Available Products</a>
            </li>
            <li class="nav-item ">
                <a class="nav-link" href="login.jsp">Login</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="register.jsp">Register</a>
            </li>
            
        </ul>
    </div>
</nav>

<div class="main-content">
    <h2 class="text-center mt-4">Available Products</h2>
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
