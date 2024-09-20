<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
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
                <li class="nav-item dropdown ">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                        Material Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="addMaterial.jsp">Add Materials</a>
                        <a class="dropdown-item" href="viewMaterials.jsp">View Material List</a>
                    </div>
                </li>
                <li class="nav-item dropdown active">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                        Product Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item active" href="product.jsp">Add Products</a>
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
        <h2 class="my-4 text-center">Add Product</h2>
        <div class="card">
            <div class="card-body">
                <%!
                    Connection conn = null;
                    PreparedStatement pst = null;
                    
                    // Method to get connection
                    private Connection getConnection() throws ClassNotFoundException, SQLException {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        return DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                    }
                %>
                <%
                    String message = (String) session.getAttribute("message");
                    //session.removeAttribute("message");
                    String messageType = (String) session.getAttribute("messageType");
                        if (message != null && messageType != null) {
                        %>
                        <div class="message <%= messageType %>"><%= message %></div>
                        <%
                            session.removeAttribute("message");
                        session.removeAttribute("messageType");
                    }

                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String uploadPath = "E:/Important DOcumants/JAVA PROJECT/Star_Tailor/Star_Tailor/web/photo";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        String supplierName = "";
                        String productName = "";
                        String materialName = "";
                        String bodySize = "";
                        String color="";
                        int productQuantity = 0;
                        BigDecimal productPrice = null;
                        String filename = "";

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
                            bodySize = m.getParameter("body_size");
                            color = m.getParameter("color");
                            productQuantity = Integer.parseInt(m.getParameter("product_quantity"));
                            productPrice = new BigDecimal(m.getParameter("product_price"));

                            conn = getConnection();

                            String query = "SELECT supplier_id FROM Supplier WHERE supplier_name = ?";
                            pst = conn.prepareStatement(query);
                            pst.setString(1, supplierName);
                            ResultSet rs = pst.executeQuery();
                            int supplierId = 0;
                            if (rs.next()) {
                                supplierId = rs.getInt("supplier_id");
                            }

                            // Debugging: Print the supplier ID
                            out.println("Debug: Supplier ID = " + supplierId + "<br>");

                            if (supplierId != 0) {
                                query = "INSERT INTO Product2 (supplier_id, product_name, material_name, color, body_size, product_quantity, product_price, photo) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                                pst = conn.prepareStatement(query);
                                pst.setInt(1, supplierId);
                                pst.setString(2, productName);
                                pst.setString(3, materialName);
                                pst.setString(4, color);
                                pst.setString(5, bodySize);
                                pst.setInt(6, productQuantity);
                                pst.setBigDecimal(7, productPrice);
                                pst.setString(8, filename);

                                // Debugging: Print parameter types
                                out.println("Debug: Parameters to add_product:<br>");
                                out.println("Supplier ID (int): " + supplierId + "<br>");
                                out.println("Product Name (nvarchar): " + productName + "<br>");
                                out.println("Material Name (nvarchar): " + materialName + "<br>");
                                out.println("color (nvarchar): " + color + "<br>");
                                out.println("Body Size (nvarchar): " + bodySize + "<br>");
                                out.println("Product Quantity (int): " + productQuantity + "<br>");
                                out.println("Product Price (decimal): " + productPrice + "<br>");
                                out.println("Filename (nvarchar): " + filename + "<br>");

                                int row = pst.executeUpdate();
                                if (row > 0) {
                                    session.setAttribute("message", "Product added successfully!");
                                    response.sendRedirect("product.jsp");
                                    return;
                                } else {
                                    message = "Failed to add product!";
                                }
                            } else {
                                message = "Invalid supplier selection.";
                            }
                        } catch (ClassNotFoundException ex) {
                            ex.printStackTrace();
                            message = "Failed to load SQLServerDriver: " + ex.getMessage();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                            message = "Failed to add product: " + ex.getMessage();
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
                <form action="product.jsp" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="supplier_name">Supplier Name:</label>
                        <select class="form-control" id="supplier_name" name="supplier_name">
                            <% 
                                try {
                                    conn = getConnection();
                                    String query = "exec select_supplierName";
                                    pst = conn.prepareStatement(query);
                                    ResultSet rs = pst.executeQuery();
                                    while (rs.next()) {
                                        String supplierNameOption = rs.getString("supplier_name");
                                        out.print("<option value=\"" + supplierNameOption + "\">" + supplierNameOption + "</option>");
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
                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                    String query = "exec select_productName";
                    pst = conn.prepareStatement(query);
                    ResultSet rs = pst.executeQuery();
                    while (rs.next()) {
                        String productType = rs.getString("product_type");
                        out.print("<option value='" + productType + "'>" + productType + "</option>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (pst != null) pst.close();
                    if (conn != null) conn.close();
                }
            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="material_name">Material Name:</label>
                        <select class="form-control" id="material_name" name="material_name">
                            <%
                                try {
                                    conn = getConnection();
                                    String query = "exec select_materialName";
                                    pst = conn.prepareStatement(query);
                                    ResultSet rs = pst.executeQuery();
                                    while (rs.next()) {
                                        String materialNameOption = rs.getString("material_name");
                                        out.print("<option value=\"" + materialNameOption + "\">" + materialNameOption + "</option>");
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
                        <label for="color">Product color</label>
                        <input type="text" class="form-control" id="color" name="color" required>
                    </div>
                    <div class="form-group">
                        <label for="body_size">Body Size:</label>
                        <select class="form-control" id="body_size" name="body_size" required>
                            <option value="" disabled selected>Select size</option>
                            <option value="Available All Size">Available All Size</option>
                            <option value="Small">Small</option>
                            <option value="Medium">Medium</option>
                            <option value="Large">Large</option>
                            <option value="Extra Large">Extra Large</option>
                            <option value="Extra Extra Large">Extra Extra Large</option>
                        </select>
                        
                    </div>
                    <div class="form-group">
                        <label for="product_quantity">Product Quantity:</label>
                        <input type="number" class="form-control" id="product_quantity" name="product_quantity" required>
                    </div>
                    <div class="form-group">
                        <label for="product_price">Product Price:</label>
                        <input type="text" class="form-control" id="product_price" name="product_price" required>
                    </div>
                    <div class="form-group">
                        <label for="photo">Product Photo:</label>
                        <input type="file" class="form-control-file" id="photo" name="photo" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </form>
                <% 
                    if (message != null && !message.isEmpty()) {
                        out.println("<div class=\"alert alert-sucess mt-3\" role=\"alert\">" + message + "</div>");
                    }
                %>
            </div>
        </div>
    </div>
            <br><br>
    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
