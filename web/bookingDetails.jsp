<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        Product Details
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="product.jsp">Add Products</a>
                        <a class="dropdown-item" href="viewProducts.jsp">View Product List</a>
                    </div>
                </li>
                <li class="nav-item dropdown active">
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
    <div class="container mt-4">
        <h2 class="text-center">Booking Details</h2>
        <%
            String message = (String) session.getAttribute("message");
            if (message != null) {
        %>
            <div class="alert alert-success"><%= message %></div>
        <%
                session.removeAttribute("message");
            }
            String error = (String) session.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert alert-danger"><%= error %></div>
        <%
                session.removeAttribute("error");
            }
        %>
        <%
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
            BigDecimal totalPrice = BigDecimal.ZERO;
            String customerName = "";
            String productName = "";
            String materialType = "";
            String bodySize = "";
            String color = "";

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                String query = "SELECT cb.customer_name, cb.product_name, cb.material_type, cb.body_size,cb.color, p.product_price " +
                               "FROM customerbooking cb " +
                               "JOIN Product2 p ON cb.product_name = p.product_name " +
                               "WHERE cb.booking_id = ?";
                pst = conn.prepareStatement(query);
                pst.setInt(1, bookingId);
                rs = pst.executeQuery();

                if (rs.next()) {
                    customerName = rs.getString("customer_name");
                    productName = rs.getString("product_name");
                    materialType = rs.getString("material_type");
                    bodySize = rs.getString("body_size");
                    color = rs.getString("color");
                    BigDecimal pricePerUnit = rs.getBigDecimal("product_price");
                    totalPrice = pricePerUnit.multiply(new BigDecimal(productQuantity));
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='error'>Error fetching booking details: " + e.getMessage() + "</div>");
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
        <div class="card mt-4">
            <div class="card-body">
                <form>
                    <div class="form-group">
                        <label>Customer Name</label>
                        <input type="text" class="form-control" name="customerName" value="<%= customerName %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Product Name</label>
                        <input type="text" class="form-control" name="productName" value="<%= productName %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Material Type</label>
                        <input type="text" class="form-control" name="materialType" value="<%= materialType %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Body Size</label>
                        <input type="text" class="form-control" name="bodySize" value="<%= bodySize %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Product Color</label>
                        <input type="text" class="form-control" name="color" value="<%= color %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" class="form-control" name="productQuantity" value="<%= productQuantity %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Total Price</label>
                        <input type="text" class="form-control" name="totalPrice" value="<%= totalPrice %>" readonly>
                    </div>
                </form>
            </div>
        </div>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String customerNamePost = request.getParameter("customerName");
                String productNamePost = request.getParameter("productName");
                String materialTypePost = request.getParameter("materialType");
                String bodySizePost = request.getParameter("bodySize");
                String colors = request.getParameter("color");
                int productQuantityPost = Integer.parseInt(request.getParameter("productQuantity"));
                BigDecimal totalPricePost = new BigDecimal(request.getParameter("totalPrice"));
                int bookingIdPost = Integer.parseInt(request.getParameter("booking_id"));

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    String insertQuery = "INSERT INTO Sales (customer_name, product_name, body_size, product_quantity, total_amount, sale_date) VALUES (?, ?, ?, ?, ?, GETDATE())";
                    pst = conn.prepareStatement(insertQuery);
                    pst.setString(1, customerNamePost);
                    pst.setString(2, productNamePost);
                    pst.setString(3, bodySizePost);
                    pst.setInt(4, productQuantityPost);
                    pst.setBigDecimal(5, totalPricePost);

                    int rows = pst.executeUpdate();
                    if (rows > 0) {
                        session.setAttribute("message", "Data successfully stored in sales table.");
                    } else {
                        session.setAttribute("error", "Failed to store data in sales table.");
                    }
                    response.sendRedirect("bookingDetails.jsp?booking_id=" + bookingIdPost + "&product_quantity=" + productQuantityPost);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("error", "Error storing data in sales table: " + e.getMessage());
                    response.sendRedirect("bookingDetails.jsp?booking_id=" + bookingIdPost + "&product_quantity=" + productQuantityPost);
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
        <div class="mt-4">
    <div class="row justify-content-center">
        <div class="form-inline">
            <!-- Fetch Button -->
            <form action="bookingDetails.jsp?booking_id=<%= bookingId %>&product_quantity=<%= productQuantity %>" method="post" class="mr-2">
                <input type="hidden" name="customerName" value="<%= customerName %>">
                <input type="hidden" name="productName" value="<%= productName %>">
                <input type="hidden" name="materialType" value="<%= materialType %>">
                <input type="hidden" name="bodySize" value="<%= bodySize %>">
                <input type="hidden" name="productQuantity" value="<%= productQuantity %>">
                <input type="hidden" name="totalPrice" value="<%= totalPrice %>">
                <input type="hidden" name="booking_id" value="<%= bookingId %>">
                <button type="submit" class="btn btn-primary">Fetch</button>
            </form>

            <!-- Generate Receipt Button -->
            <form action="generateReceipt.jsp" method="post" class="mr-2">
                <input type="hidden" name="customerName" value="<%= customerName %>">
                <input type="hidden" name="productName" value="<%= productName %>">
                <input type="hidden" name="materialType" value="<%= materialType %>">
                <input type="hidden" name="bodySize" value="<%= bodySize %>">
                <input type="hidden" name="color" value="<%= color %>">
                <input type="hidden" name="productQuantity" value="<%= productQuantity %>">
                <input type="hidden" name="totalPrice" value="<%= totalPrice %>">
                <input type="hidden" name="booking_id" value="<%= bookingId %>">
                <button type="submit" class="btn btn-success">Generate Receipt</button>
            </form>

            <!-- Back to Bookings Button -->
            <a href="viewCustomerBooking.jsp" class="btn btn-secondary">Back to Bookings</a>
        </div>
    </div>
</div>

    </div>
    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
