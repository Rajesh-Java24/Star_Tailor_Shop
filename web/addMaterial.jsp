<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
                <li class="nav-item dropdown active">
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
                <li class="nav-item dropdown">
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
        <h1 class="my-4 text-center">Add Material</h1>
        <div class="card">
            <div class="card-body">
                <%
                    if (request.getParameter("submit") != null) {
                        String productType = request.getParameter("productType");
                        String materialName = request.getParameter("materialName");
                        int quantity = Integer.parseInt(request.getParameter("quantity"));
                        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                        String purchaseDate = request.getParameter("purchaseDate");

                        try {
                            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                            String query = "exec add_Material ?, ?, ?, ?, ?";
                            PreparedStatement pstmt = conn.prepareStatement(query);
                            pstmt.setString(1, productType);
                            pstmt.setString(2, materialName);
                            pstmt.setInt(3, quantity);
                            pstmt.setInt(4, supplierId);
                            pstmt.setDate(5, java.sql.Date.valueOf(purchaseDate));
                            pstmt.executeUpdate();
                            conn.close();
                            out.println("<div class='alert alert-success'>Material added successfully!</div>");
                        } catch (Exception e) {
                            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                        }
                    }
                %>
                <form method="post" action="addMaterial.jsp">
                    <div class="form-group">
                        <label for="productType">Product Type:</label>
                        <input type="text" class="form-control" id="productType" name="productType" required>
                    </div>
                    <div class="form-group">
                        <label for="materialName">Material Name:</label>
                        <input type="text" class="form-control" id="materialName" name="materialName" required>
                    </div>
                    <div class="form-group">
                        <label for="quantity">Quantity:</label>
                        <input type="number" class="form-control" id="quantity" name="quantity" required>
                    </div>
                    <div class="form-group">
                        <label for="supplierId">Supplier Name:</label>
                        <select class="form-control" id="supplierId" name="supplierId" required>
                            <option value="" disabled selected>Select Supplier</option>

                            <%
                                try {
                                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                                    Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                                    String query = "exec edit_supplierName";
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery(query);
                                    while (rs.next()) {
                                        out.println("<option value='" + rs.getInt("supplier_id") + "'>" + rs.getString("supplier_name") + "</option>");
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="purchaseDate">Purchase Date:</label>
                        <input type="date" class="form-control" id="purchaseDate" name="purchaseDate" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="submit">Add Material</button>
                </form>
                
            </div>
        </div>
    </div><br><br>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
