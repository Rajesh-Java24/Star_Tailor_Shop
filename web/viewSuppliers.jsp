<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Suppliers</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
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
        .add-button {
            margin-top: 20px;
            margin-bottom: 20px;
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
            <li class="nav-item dropdown active">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button">
                    Supplier Details
                </a>
                <div class="dropdown-menu " aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="addSupplier.jsp">Add Supplier</a>
                    <a class="dropdown-item active" href="viewSuppliers.jsp">View Supplier List</a>
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
    <h1 class="my-4 text-center">View Suppliers</h1>

    <!-- Add Supplier Button -->
    <div class="text-right add-button">
        <a href="addSupplier.jsp" class="btn btn-primary">Add Supplier</a>
    </div>

    <!-- Display Suppliers Table -->
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>Supplier ID</th>
                <th>Supplier Name</th>
                <th>Company Name</th>
                <th>Contact Number</th>
                <th>Email</th>
                <th>Address</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
            try {
                // Establish database connection (replace with your actual database details)
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
                // Fetch all suppliers from the database
                String query = "exec view_supplier";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query);

                // Display suppliers in the table
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("supplier_id") %></td>
                <td><%= rs.getString("supplier_name") %></td>
                <td><%= rs.getString("company_name") %></td>
                <td><%= rs.getString("contact_number") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("address") %></td>
                <td>
                    <a href="editSupplier.jsp?supplier_id=<%= rs.getString("supplier_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <form method="post" action="viewSuppliers.jsp" style="display:inline;">
                        <input type="hidden" name="deleteSupplierId" value="<%= rs.getString("supplier_id") %>">
                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                    </form>
                </td>
            </tr>
            <% 
                }

                // Close ResultSet, Statement, and Connection
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("Error retrieving supplier: " + e.getMessage());
            }
            %>
        </tbody>
    </table>

    <% 
    // Handle deletion of supplier
    if (request.getParameter("deleteSupplierId") != null) {
        String deleteSupplierId = request.getParameter("deleteSupplierId");

        try {
            // Establish database connection (replace with your actual database details)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");
            
            // Delete supplier from the database
            String deleteQuery = "exec delete_supplier ?";
            PreparedStatement pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setString(1, deleteSupplierId);
            pstmt.executeUpdate();

            // Close PreparedStatement and Connection
            pstmt.close();
            conn.close();

            // Refresh the page to reflect the changes
            response.sendRedirect("viewSuppliers.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Error deleting supplier: " + e.getMessage());
        }
    }
    %>

</div>

</body>
</html>
