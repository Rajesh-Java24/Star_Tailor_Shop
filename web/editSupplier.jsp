<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String supplierId = request.getParameter("supplier_id");
    String supplierName = "";
    String companyName = "";
    String contactNumber = "";
    String email = "";
    String address = "";

    if (supplierId != null) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
            String query = "exec edit_supplier ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, supplierId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                supplierName = rs.getString("supplier_name");
                companyName = rs.getString("company_name");
                contactNumber = rs.getString("contact_number");
                email = rs.getString("email");
                address = rs.getString("address");
            }

            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        supplierId = request.getParameter("supplier_id");
        supplierName = request.getParameter("supplier_name");
        companyName = request.getParameter("company_name");
        contactNumber = request.getParameter("contact_number");
        email = request.getParameter("email");
        address = request.getParameter("address");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
            String updateQuery = "exec update_supplier ?,?,?,?,?,?";
            PreparedStatement pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, supplierName);
            pstmt.setString(2, companyName);
            pstmt.setString(3, contactNumber);
            pstmt.setString(4, email);
            pstmt.setString(5, address);
            pstmt.setString(6, supplierId);
            pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            response.sendRedirect("viewSuppliers.jsp");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Supplier</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .message {
            margin: 20px 0;
            padding: 10px;
            color: white;
            font-size: 16px;
        }
        .message-success {
            background-color: green;
        }
        .message-error {
            background-color: red;
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
        .card{
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            background-color: #f9f9f9;
            
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
            <li class="nav-item ">
                <a class="nav-link" href="employee_dashboard.jsp">Home</a>
            </li>
            <li class="nav-item dropdown active">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Supplier Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item active" href="addSupplier.jsp">Add Supplier</a>
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
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Booking Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="viewCustomerBooking.jsp">View Booking List</a>
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
    <h1 class="my-4 text-center">Edit Supplier</h1>
    <div class="row justify-content-center">
    <div class="col-md-6">
            <div class="card">
                <div class="card-body">
    <form action="editSupplier.jsp" method="post">
        <div class="form-group">
            <label for="supplier_id">Supplier ID</label>
            <input type="text" class="form-control" id="supplier_id" name="supplier_id" value="<%= supplierId %>" readonly>
        </div>
        <div class="form-group">
            <label for="supplier_name">Supplier Name</label>
            <input type="text" class="form-control" id="supplier_name" name="supplier_name" value="<%= supplierName %>">
        </div>
        <div class="form-group">
            <label for="contact_person">Company Name</label>
            <input type="text" class="form-control" id="company_name" name="company_name" value="<%= companyName %>">
        </div>
        <div class="form-group">
            <label for="contact_number">Contact Number</label>
            <input type="text" class="form-control" id="contact_number" name="contact_number" value="<%= contactNumber %>">
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" value="<%= email %>">
        </div>
        <div class="form-group">
            <label for="address">Address</label>
            <input type="text" class="form-control" id="address" name="address" value="<%= address %>">
        </div>
        <button type="submit" class="btn btn-primary">Update Supplier</button>
    </form>
</div>
    </div>
    </div>
</div>
</div>

</body>
</html>
