<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Material List</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
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
        .top-right-btn {
            float: right;
        }
    </style>
    <script>
        function deleteMaterial(materialId) {
            if (confirm('Are you sure you want to delete this material?')) {
                document.getElementById('deleteMaterialId').value = materialId;
                document.getElementById('deleteMaterialForm').submit();
            }
        }
    </script>
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
                        <a class="dropdown-item active" href="viewMaterials.jsp">View Material List</a>
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
        <h1 class="my-4 text-center">Material List</h1>
        <div class="text-right add-button">
            <a href="addMaterial.jsp" class="btn btn-primary">Add New Material</a>
        </div>
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Material ID</th>
                    <th>Product Type</th>
                    <th>Material Name</th>
                    <th>Quantity</th>
                    <th>Supplier Name</th>
                    <th>Purchase Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("deleteMaterialId") != null) {
                        int deleteMaterialId = Integer.parseInt(request.getParameter("deleteMaterialId"));
                        try {
                            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                            String deleteQuery = "DELETE FROM material WHERE material_id = ?";
                            PreparedStatement pstmt = conn.prepareStatement(deleteQuery);
                            pstmt.setInt(1, deleteMaterialId);
                            pstmt.executeUpdate();
                            pstmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    }

                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                        String query = "SELECT m.material_id, m.product_type, m.material_name, m.quantity, s.supplier_name, m.purchase_date FROM material m JOIN supplier s ON m.supplier_id = s.supplier_id";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(query);

                        while (rs.next()) {
                            int materialId = rs.getInt("material_id");
                            String productType = rs.getString("product_type");
                            String materialName = rs.getString("material_name");
                            int quantity = rs.getInt("quantity");
                            String supplierName = rs.getString("supplier_name");
                            Date purchaseDate = rs.getDate("purchase_date");

                            out.println("<tr id='material-" + materialId + "'>");
                            out.println("<td>" + materialId + "</td>");
                            out.println("<td>" + productType + "</td>");
                            out.println("<td>" + materialName + "</td>");
                            out.println("<td>" + quantity + "</td>");
                            out.println("<td>" + supplierName + "</td>");
                            out.println("<td>" + purchaseDate + "</td>");
                            out.println("<td>");
                            out.println("<a href='editMaterial.jsp?material_id=" + materialId + "' class='btn btn-warning btn-sm'>Edit</a> ");
                            out.println("<button onclick='deleteMaterial(" + materialId + ")' class='btn btn-danger btn-sm'>Delete</button>");
                            out.println("</td>");
                            out.println("</tr>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    <form id="deleteMaterialForm" method="POST" style="display:none;">
        <input type="hidden" id="deleteMaterialId" name="deleteMaterialId">
    </form>
</body>
</html>
