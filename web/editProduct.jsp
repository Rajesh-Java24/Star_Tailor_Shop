<%@page import="java.util.Enumeration"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.*"%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
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
                <li class="nav-item dropdown active">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Product Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="product.jsp">Add Products</a>
                        <a class="dropdown-item" href="viewProducts.jsp">View Product List</a>
                    </div>
                </li>
                <li class="nav-item dropdown ">
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
        <h2 class="my-4 text-center">Edit Product</h2>
        <div class="card">
            <div class="card-body">
                <%!
                    private Connection getConnection() throws ClassNotFoundException, SQLException {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        return DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                    }
                %>
                <%
                    String message = null;
                    String messageType = "alert-danger";
                    String productId = request.getParameter("product_id");

                    String supplierName = "";
                    String productName = "";
                    String materialName = "";
                    String color = "";
                    String bodySize = "";
                    int productQuantity = 0;
                    BigDecimal productPrice = null;
                    String filename = "";

                    Connection conn = null;
                    PreparedStatement pst = null;

                    try {
                        conn = getConnection();
                        String query = "SELECT p.*, s.supplier_name FROM Product2 p JOIN Supplier s ON p.supplier_id = s.supplier_id WHERE p.product_id = ?";
                        pst = conn.prepareStatement(query);
                        pst.setInt(1, Integer.parseInt(productId));
                        ResultSet rs = pst.executeQuery();

                        if (rs.next()) {
                            supplierName = rs.getString("supplier_name");
                            productName = rs.getString("product_name");
                            materialName = rs.getString("material_name");
                            color = rs.getString("color");
                            bodySize = rs.getString("body_size");
                            productQuantity = rs.getInt("product_quantity");
                            productPrice = rs.getBigDecimal("product_price");
                            filename = rs.getString("photo");
                        } else {
                            message = "Product not found!";
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        message = "Error: " + ex.getMessage();
                    } finally {
                        try {
                            if (pst != null) pst.close();
                            if (conn != null) conn.close();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                    }

                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String uploadPath = getServletContext().getRealPath("/photo");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        try {
                            MultipartRequest m = new MultipartRequest(request, uploadPath, 8 * 1024 * 1024);
                            Enumeration files = m.getFileNames();
                            File file = null;

                            while (files.hasMoreElements()) {
                                String name1 = (String) files.nextElement();
                                filename = m.getFilesystemName(name1);
                                file = m.getFile(name1);
                            }

                            supplierName = m.getParameter("supplier_name");
                            productName = m.getParameter("product_name");
                            materialName = m.getParameter("material_name");
                            color = m.getParameter("color");
                            bodySize = m.getParameter("body_size");
                            productQuantity = Integer.parseInt(m.getParameter("product_quantity"));
                            productPrice = new BigDecimal(m.getParameter("product_price"));

                            conn = getConnection();

                            String query = "UPDATE Product2 SET supplier_id = (SELECT supplier_id FROM Supplier WHERE supplier_name = ?), product_name = ?, material_name = ?, color=?, body_size = ?, product_quantity = ?, product_price = ?" +
                                            (filename != null && !filename.isEmpty() ? ", photo = ?" : "") + " WHERE product_id = ?";
                            pst = conn.prepareStatement(query);
                            pst.setString(1, supplierName);
                            pst.setString(2, productName);
                            pst.setString(3, materialName);
                            pst.setString(4, color);
                            pst.setString(5, bodySize);
                            pst.setInt(6, productQuantity);
                            pst.setBigDecimal(7, productPrice);
                            if (filename != null && !filename.isEmpty()) {
                                pst.setString(8, filename);
                                pst.setInt(8, Integer.parseInt(productId));
                            } else {
                                pst.setInt(8, Integer.parseInt(productId));
                            }

                            int row = pst.executeUpdate();
                            if (row > 0) {
                                session.setAttribute("message", "Product updated successfully!");
                                response.sendRedirect("viewProducts.jsp");
                                return;
                            } else {
                                message = "Failed to update product!";
                            }
                        } catch (ClassNotFoundException ex) {
                            ex.printStackTrace();
                            message = "Failed to load SQLServerDriver: " + ex.getMessage();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                            message = "Failed to update product: " + ex.getMessage();
                        } catch (NumberFormatException ex) {
                            ex.printStackTrace();
                            message = "Invalid number format: " + ex.getMessage();
                        } catch (IOException ex) {
                            ex.printStackTrace();
                            message = "File upload failed: " + ex.getMessage();
                        } finally {
                            try {
                                if (pst != null) pst.close();
                                if (conn != null) conn.close();
                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            }
                        }
                    }
                %>
                <form action="editProduct.jsp?product_id=<%= productId %>" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="supplier_name">Supplier Name:</label>
                        <select class="form-control" id="supplier_name" name="supplier_name">
                            <% 
                                try {
                                    conn = getConnection();
                                    String query = "SELECT supplier_name FROM Supplier";
                                    pst = conn.prepareStatement(query);
                                    ResultSet rs = pst.executeQuery();
                                    while (rs.next()) {
                                        String supplierNameOption = rs.getString("supplier_name");
                                        if (supplierNameOption.equals(supplierName)) {
                                            out.print("<option value=\"" + supplierNameOption + "\" selected>" + supplierNameOption + "</option>");
                                        } else {
                                            out.print("<option value=\"" + supplierNameOption + "\">" + supplierNameOption + "</option>");
                                        }
                                    }
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                } finally {
                                    try {
                                        if (pst != null) pst.close();
                                        if (conn != null) conn.close();
                                    } catch (SQLException ex) {
                                        ex.printStackTrace();
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="product_name">Product Name:</label>
                        <select class="form-control" id="product_name" name="product_name">
                            <% 
                                Connection connProduct = null;
                                PreparedStatement pstProduct = null;
                                ResultSet rsProduct = null;
                                try {
                                    connProduct = getConnection();

                                    // Query to fetch distinct product names from the Product2 table
                                    String queryProduct = "SELECT DISTINCT product_type FROM Material";

                                    pstProduct = connProduct.prepareStatement(queryProduct);
                                    rsProduct = pstProduct.executeQuery();
                                    while (rsProduct.next()) {
                                        String productNameOption = rsProduct.getString("product_type");
                                        if (productNameOption.equals(productName)) {
                                            out.print("<option value='" + productNameOption + "' selected>" + productNameOption + "</option>");
                                        } else {
                                            out.print("<option value='" + productNameOption + "'>" + productNameOption + "</option>");
                                        }
                                    }
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                } finally {
                                    try {
                                        if (rsProduct != null) rsProduct.close();
                                        if (pstProduct != null) pstProduct.close();
                                        if (connProduct != null) connProduct.close();
                                    } catch (SQLException ex) {
                                        ex.printStackTrace();
                                    }
                                }
                            %>
                        </select>
                    </div>



                    <div class="form-group">
                        <label for="material_name">Material Name:</label>
                        <select class="form-control" id="material_name" name="material_name">
                            <% 
                                Connection connMaterial = null;
                                PreparedStatement pstMaterial = null;
                                ResultSet rsMaterial = null;
                                try {
                                    connMaterial = getConnection();

                                    // Query to fetch distinct material names from the Material table
                                    String queryMaterial = "SELECT DISTINCT material_name FROM Material";

                                    pstMaterial = connMaterial.prepareStatement(queryMaterial);
                                    rsMaterial = pstMaterial.executeQuery();
                                    while (rsMaterial.next()) {
                                        String materialNameOption = rsMaterial.getString("material_name");
                                        if (materialNameOption.equals(materialName)) {
                                            out.print("<option value='" + materialNameOption + "' selected>" + materialNameOption + "</option>");
                                        } else {
                                            out.print("<option value='" + materialNameOption + "'>" + materialNameOption + "</option>");
                                        }
                                    }
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                } finally {
                                    try {
                                        if (rsMaterial != null) rsMaterial.close();
                                        if (pstMaterial != null) pstMaterial.close();
                                        if (connMaterial != null) connMaterial.close();
                                    } catch (SQLException ex) {
                                        ex.printStackTrace();
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="color">Product color:</label>
                        <input type="text" class="form-control" id="color" name="color" value="<%= color %>" required>
                    </div>
                    <div class="form-group">
                        <label for="body_size">Body Size:</label>
                        <select class="form-control" id="body_size" name="body_size" required>
                            
                            <% 
                                // Define fixed body sizes
                                String[] fixedSizes = {"Available All Size", "Small", "Medium", "Large", "Extra Large", "Extra Extra Large"};

                                // Create a list to track already added sizes
                                java.util.List<String> addedSizes = new java.util.ArrayList<String>(java.util.Arrays.asList(fixedSizes));

                                // Add fixed sizes to dropdown
                                for (String size : fixedSizes) {
                                    boolean isSelected = size.equals(bodySize);
                                    out.print("<option value='" + size + "'" + (isSelected ? " selected" : "") + ">" + size + "</option>");
                                }

                                // Fetch additional sizes from the database
                                
                                ResultSet rs = null;
                                try {
                                    conn = getConnection();
                                    String query = "SELECT DISTINCT body_size FROM Product2 WHERE body_size IS NOT NULL AND body_size <> ''";
                                    pst = conn.prepareStatement(query);
                                    rs = pst.executeQuery();

                                    // Add sizes fetched from database to dropdown if they are not already added
                                    while (rs.next()) {
                                        String bodySizeOption = rs.getString("body_size");
                                        if (!addedSizes.contains(bodySizeOption)) {
                                            boolean isSelected = bodySizeOption.equals(bodySize);
                                            out.print("<option value='" + bodySizeOption + "'" + (isSelected ? " selected" : "") + ">" + bodySizeOption + "</option>");
                                        }
                                    }
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                } finally {
                                    try {
                                        if (rs != null) rs.close();
                                        if (pst != null) pst.close();
                                        if (conn != null) conn.close();
                                    } catch (SQLException ex) {
                                        ex.printStackTrace();
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="product_quantity">Product Quantity:</label>
                        <input type="number" class="form-control" id="product_quantity" name="product_quantity" value="<%= productQuantity %>" required>
                    </div>
                    <div class="form-group">
                        <label for="product_price">Product Price:</label>
                        <input type="text" class="form-control" id="product_price" name="product_price" value="<%= productPrice %>" required>
                    </div>
                    <div class="form-group">
                        <label for="photo">Product Image:</label>
                        <input type="file" class="form-control-file" id="photo" name="photo">
                        <% if (filename != null && !filename.isEmpty()) { %>
                            <img src="photo/<%= filename %>?<%= System.currentTimeMillis() %>" alt="Product Image" style="max-width: 200px; max-height: 200px; margin-top: 10px;">
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Product</button>
                    <% if (message != null) { %>
                        <div class="alert <%= messageType %>" role="alert">
                            <%= message %>
                        </div>
                    <% } %>
                </form>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
