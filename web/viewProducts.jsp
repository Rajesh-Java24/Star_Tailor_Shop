<%@ page import="java.sql.*, java.math.BigDecimal, java.io.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Products</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #007bff; /* Updated background color */
            color: white; /* Text color */
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
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="#">Star Tailor</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="employee_dashboard.jsp">Home</a>
            </li>
            <li class="nav-item dropdown ">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Supplier Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="addSupplier.jsp">Add Supplier</a>
                    <a class="dropdown-item" href="viewSuppliers.jsp">View Supplier List</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown2" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Material Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown2">
                    <a class="dropdown-item" href="addMaterial.jsp">Add Materials</a>
                    <a class="dropdown-item" href="viewMaterials.jsp">View Material List</a>
                </div>
            </li>
            <li class="nav-item dropdown active">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown3" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Product Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown3">
                    <a class="dropdown-item" href="product.jsp">Add Products</a>
                    <a class="dropdown-item active" href="viewProducts.jsp">View Product List</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown4" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Booking Details
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown4">
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

<div class="container mt-4">
    <h2 class="my-4 text-center">View Products</h2>

    <% 
        // Check if a delete request was made
        if (request.getParameter("delete_product_id") != null) {
            int deleteProductId = Integer.parseInt(request.getParameter("delete_product_id"));
            Connection conn = null;
            PreparedStatement pst = null;

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                String deleteQuery = "DELETE FROM Product2 WHERE product_id = ?";
                pst = conn.prepareStatement(deleteQuery);
                pst.setInt(1, deleteProductId);
                int rowsAffected = pst.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<script>alert('Product deleted successfully!');</script>");
                } else {
                    out.println("<script>alert('Failed to delete the product. Please try again.');</script>");
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (pst != null) pst.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>

    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th scope="col">Product ID</th>
                <th scope="col">Supplier Name</th>
                <th scope="col">Product Name</th>
                <th scope="col">Material Name</th>
                <th scope="col">Product Color</th>
                <th scope="col">Body Size</th>
                <th scope="col">Quantity</th>
                <th scope="col">Price</th>
                <th scope="col">Photo</th>
                <th scope="col">Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
                Connection conn = null;
                PreparedStatement pst = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    String query = "exec GetProductDetails";
                    pst = conn.prepareStatement(query);
                    rs = pst.executeQuery();

                    while (rs.next()) {
                        int productId = rs.getInt("product_id");
                        String supplierName = rs.getString("supplier_name");
                        String productName = rs.getString("product_name");
                        String materialName = rs.getString("material_name");
                        String color = rs.getString("color");
                        String bodySize = rs.getString("body_size");
                        int productQuantity = rs.getInt("product_quantity");
                        BigDecimal productPrice = rs.getBigDecimal("product_price");
                        String photo = rs.getString("photo");
            %>
            <tr>
                <td><%= productId %></td>
                <td><%= supplierName %></td>
                <td><%= productName %></td>
                <td><%= materialName %></td>
                <td><%= color %></td>
                <td><%= bodySize %></td>
                <td><%= productQuantity %></td>
                <td><%= productPrice %></td>
                <td>
                    <% if (photo != null && !photo.isEmpty()) { %>
                    <img src="photo/<%= photo %>" alt="Product Image" style="width: 100px; height: 100px;">
                    <% } else { %>
                    No Image
                    <% } %>
                </td>
                <td>
                    <div class="btn-group" role="group">
                        <form action="editProduct.jsp" method="get" class="d-inline">
                            <input type="hidden" name="product_id" value="<%= productId %>">
                            <button type="submit" class="btn btn-warning btn-sm mr-2">Edit</button>
                        </form>
                        <form action="viewProducts.jsp" method="post" class="d-inline">
                            <input type="hidden" name="delete_product_id" value="<%= productId %>">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this product?');">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
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
        </tbody>
    </table>
</div>
        <br><br>
<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
