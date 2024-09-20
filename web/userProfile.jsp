<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if no user is logged in
        return;
    }

    String name = "";
    String email = "";
    String role = "";
    String message = "";
    String messageType = "alert-info"; // Default message type

    String oldPassword = "";
    String newPassword = "";
    String verifyPassword = "";
    String passwordMessage = "";
    String passwordMessageType = "alert-info"; // Default message type for password change

    // Handle profile update
    if (request.getMethod().equalsIgnoreCase("post")) {
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            name = request.getParameter("name");
            email = request.getParameter("email");
            role = request.getParameter("role");

            // Validation: Ensure email is not empty or null
            if (email == null || email.trim().isEmpty()) {
                message = "Email cannot be empty!";
                messageType = "alert-danger";
            } else {
                Connection conn = null;
                PreparedStatement stmt = null;

                try {
                    // Database connection setup
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    // Prepare and execute the SQL update
                    String sql = "UPDATE users SET name = ?, email = ?, role = ? WHERE username = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, name);
                    stmt.setString(2, email);
                    stmt.setString(3, role);
                    stmt.setString(4, username);

                    int rowsAffected = stmt.executeUpdate();

                    if (rowsAffected > 0) {
                        message = "Profile updated successfully!";
                        messageType = "alert-success";
                    } else {
                        message = "Profile update failed. No rows were affected.";
                        messageType = "alert-danger";
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    message = "An error occurred while updating the profile: " + e.getMessage();
                    messageType = "alert-danger";
                } finally {
                    // Close resources
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        } else if ("changePassword".equals(action)) {
            oldPassword = request.getParameter("oldPassword");
            newPassword = request.getParameter("newPassword");
            verifyPassword = request.getParameter("verifyPassword");

            // Debugging: Print request parameters
//            out.println("Received oldPassword: " + oldPassword);
//            out.println("Received newPassword: " + newPassword);
//            out.println("Received verifyPassword: " + verifyPassword);

            // Validation: Ensure passwords are not empty and match
            if (oldPassword == null || oldPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                verifyPassword == null || verifyPassword.trim().isEmpty()) {
                passwordMessage = "All password fields are required!";
                passwordMessageType = "alert-danger";
            } else if (!newPassword.equals(verifyPassword)) {
                passwordMessage = "New password and verification do not match!";
                passwordMessageType = "alert-danger";
            } else {
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    // Database connection setup
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                    // Check old password
                    String checkSql = "SELECT password FROM users WHERE username = ?";
                    stmt = conn.prepareStatement(checkSql);
                    stmt.setString(1, username);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String currentPassword = rs.getString("password");

                        if (currentPassword.equals(oldPassword)) {
                            // Update password
                            String updateSql = "UPDATE users SET password = ? WHERE username = ?";
                            stmt = conn.prepareStatement(updateSql);
                            stmt.setString(1, newPassword);
                            stmt.setString(2, username);

                            int rowsAffected = stmt.executeUpdate();

                            if (rowsAffected > 0) {
                                passwordMessage = "Password changed successfully!";
                                passwordMessageType = "alert-success";
                            } else {
                                passwordMessage = "Password change failed. No rows were affected.";
                                passwordMessageType = "alert-danger";
                            }
                        } else {
                            passwordMessage = "Old password is incorrect!";
                            passwordMessageType = "alert-danger";
                        }
                    } else {
                        passwordMessage = "User not found!";
                        passwordMessageType = "alert-danger";
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    passwordMessage = "An error occurred while changing the password: " + e.getMessage();
                    passwordMessageType = "alert-danger";
                } finally {
                    // Close resources
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        }
    } else {
        // Fetch user details from database
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Database connection setup
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

            // Prepare and execute the SQL select
            String sql = "SELECT name, email, role FROM users WHERE username = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                role = rs.getString("role");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "An error occurred while fetching the profile details: " + e.getMessage();
            messageType = "alert-danger";
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile and Change Password</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .profile-header {
            text-align: center;
            margin: 20px 0;
           
        }
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .form-group label {
            width: 130px;
            font-weight: bold;
            text-align: right;
            margin-right: 15px;
        }
        .form-group label::after {
            content: ":";
            margin-left: 5px;
        }
        .form-group input {
            flex: 1;
        }
        .btn-center {
            display: flex;
            justify-content: center;
        }
        .alert {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-dark">
        <a class="navbar-brand" href="customer_dashboard.jsp" style="color: white;">Star Tailor</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="home1.jsp" style="color: white;">Home</a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <!-- Profile Update Form -->
        <div class="profile-header">
            <h1><%= name %></h1>  
            <hr>
        </div>
        <h4 class="text-center">User Profile</h4>
        <% if (!message.isEmpty()) { %>
            <div class="alert <%= messageType %>" role="alert">
                <%= message %>
            </div>
        <% } %>
        <div class="form-container">
            <form action="userProfile.jsp" method="post">
                <input type="hidden" name="action" value="updateProfile">
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" class="form-control" id="name" name="name" value="<%= name %>" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
                </div>
                <div class="form-group">
                    <label for="role">Role</label>
                    <input type="text" class="form-control" id="role" name="role" value="<%= role %>" readonly>
                </div>
                <div class="btn-center">
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </div>
            </form>
        </div><br>

        <!-- Password Change Form -->
        
            <h4 class="text-center">Change Password</h4>
        
        <% if (!passwordMessage.isEmpty()) { %>
            <div class="alert <%= passwordMessageType %>" role="alert">
                <%= passwordMessage %>
            </div>
        <% } %>
        <div class="form-container">
            <form action="userProfile.jsp" method="post">
                <input type="hidden" name="action" value="changePassword">
                <div class="form-group">
                    <label for="oldPassword">Old Password</label>
                    <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                </div>
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label for="verifyPassword">Verify Password</label>
                    <input type="password" class="form-control" id="verifyPassword" name="verifyPassword" required>
                </div>
                <div class="btn-center">
                    <button type="submit" class="btn btn-primary">Change Password</button>
                </div>
            </form>
        </div>
    </div><br><br>

    <!-- Bootstrap JS and dependencies (jQuery and Popper.js) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
