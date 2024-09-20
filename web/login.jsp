<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="./stylesheet.css">

    <style>
        /* Navbar styling */
        .navbar {
            background-color: #343a40;
            overflow: hidden;
            padding: 10px 20px;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .navbar a {
            float: left;
            color: #ffffff;
            text-align: center;
            padding: 12px 16px;
            text-decoration: none;
            font-size: 17px;
        }
        

        .navbar a:hover {
            background-color: orange;
            color: black;
        }

        .navbar .brand {
            font-size: 20px;
            font-weight: bold;
        }

        .navbar .right {
            float: right;
        }

        /* Adjust content for fixed navbar */
        body {
            padding-top: 60px; /* Adjust this padding to match the navbar height */
        }

        /* Background elements styling */
        span {
            position: absolute;
            display: block;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            animation: animate 25s linear infinite;
            bottom: -150px;
        }

        @keyframes animate {
            0% {
                transform: translateY(0) rotate(0);
                opacity: 1;
            }

            100% {
                transform: translateY(-800px) rotate(720deg);
                opacity: 0;
            }
        }

        span:nth-child(1) {
            width: 80px;
            height: 80px;
            left: 20%;
            animation-delay: 0s;
        }

        span:nth-child(2) {
            width: 60px;
            height: 60px;
            left: 40%;
            animation-delay: 2s;
        }

        span:nth-child(3) {
            width: 40px;
            height: 40px;
            left: 60%;
            animation-delay: 4s;
        }

        span:nth-child(4) {
            width: 50px;
            height: 50px;
            left: 80%;
            animation-delay: 0s;
        }

        span:nth-child(5) {
            width: 90px;
            height: 90px;
            left: 30%;
            animation-delay: 0s;
        }

        span:nth-child(6) {
            width: 120px;
            height: 120px;
            left: 70%;
            animation-delay: 3s;
        }

        span:nth-child(7) {
            width: 100px;
            height: 100px;
            left: 90%;
            animation-delay: 2s;
        }

        .signin {
            position: absolute;
            margin-top:  50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 50px;
            width: 350px;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            text-align: center;
        }

        .signin h2 {
            color: #fff;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .signin .form {
            margin-top: 30px;
        }

        .signin .form .inputBox {
            position: relative;
            margin-bottom: 30px;
        }

        .signin .form .inputBox input {
            width: 100%;
            padding: 10px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            outline: none;
            color: #fff;
            font-size: 14px;
            border-radius: 4px;
            letter-spacing: 1px;
        }

        .signin .form .inputBox i {
            position: absolute;
            top: 50%;
            left: 10px;
            transform: translateY(-50%);
            font-size: 14px;
            color: #fff;
            pointer-events: none;
            transition: 0.5s;
        }

        .signin .form .inputBox input:focus~i,
        .signin .form .inputBox input:valid~i {
            top: -10px;
            font-size: 12px;
        }

        .signin .form .links {
            display: flex;
            justify-content: space-between;
        }

        .signin .form .links a {
            color: #fff;
            font-size: 14px;
            text-decoration: none;
        }

        .signin .form .links a:hover {
            text-decoration: underline;
        }

        .signin .form .inputBox input[type="submit"] {
            background: orange;
            color: black;
            cursor: pointer;
            font-size: 16px;
            text-transform: uppercase;
            letter-spacing: 2px;
            transition: 0.5s;
        }

        .signin .form .inputBox input[type="submit"]:hover {
            background: #333;
            color: orange;
        }
    </style>
</head>

<body>

    <!-- Navigation bar at the top of the page -->
    <div class="navbar">
        <a class="brand" href="#">Star Tailor</a>
        <div class="right">
            <a href="home1.jsp">Home</a>
            <a href="customerVisibleHome.jsp">Available Products</a>
            <a href="login.jsp" class="active">Login</a>
            <a href="register.jsp">Register</a>
        </div>
    </div>

    <%
        // Handle form submission
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String inputUsername = request.getParameter("username");
            String password = request.getParameter("password");
            String inputRole = request.getParameter("role");

            try {
                // Establish database connection
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-QBNMT1Q;databaseName=Star_Tailor;TrustServerCertificate=True;user=Rajesh;password=Rajesh");

                // Prepare SQL query to validate user
                String query = "exec login_user ?,?,?";
                PreparedStatement pst = conn.prepareStatement(query);
                pst.setString(1, inputUsername);
                pst.setString(2, password);
                pst.setString(3, inputRole);

                // Execute query
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    // Set session attributes upon successful login
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("username", inputUsername);
                    session.setAttribute("role", inputRole);

                    // Redirect to appropriate dashboard based on role
                    if ("Admin".equals(inputRole)) {
                        response.sendRedirect("admin_dashboard.jsp");
                    } else if ("Employee".equals(inputRole)) {
                        response.sendRedirect("employee_dashboard.jsp");
                    } else if ("Customer".equals(inputRole)) {
                        response.sendRedirect("customer_dashboard.jsp");
                    } else {
                        response.sendRedirect("home.jsp");
                    }
                } else {
                    out.println("<div class='alert alert-danger mt-4' role='alert'>Invalid username, password, or role.</div>");
                }

                // Clean up resources
                rs.close();
                pst.close();
                conn.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger mt-4' role='alert'>Error occurred during login. Please try again.</div>");
                e.printStackTrace();
            }
        }
    %>

    <section>
        <!-- Background elements -->
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>

        <div class="signin">
            <div class="content">
                <h2>Sign In</h2>
                <div class="form">
                    <form method="post" action="login.jsp">
                        <div class="inputBox">
                            <input type="text" class="form-control" id="username" name="username" required>
                            <i>Username</i>
                        </div>
                        <div class="inputBox">
                            <input type="password" class="form-control" id="password" name="password" required>
                            <i>Password</i>
                        </div>

                        <!-- Role Dropdown -->
                        <div class="inputBox">
                            <select class="form-control" id="role" name="role" required>
                                <option value="" disabled selected>Select Role</option>
                                <option value="Customer">Customer</option>
                                <option value="Employee">Employee</option>
                                <option value="Admin">Admin</option>
                            </select>
                        </div>

                        <div class="links">
                            <a href="sendAndVerifyCode.jsp">Forgot Password</a>
                            <a href="register.jsp">Signup</a>
                        </div>
                        <div class="inputBox">
                            <input type="submit" value="Login">
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <br><br>
    </section>
    <br><br>
</body>

</html>







<!-- Main content -->
<!--<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="form-container">
                <h2 class="text-center mb-4">User Login</h2>
                <form method="post" action="login.jsp">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="role">Role:</label>
                        <select class="form-control" id="role" name="role" required>
                            <option value="" disabled selected>Select Role</option>
                            <option value="Customer">Customer</option>
                            <option value="Employee">Employee</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                    <a href="register.jsp">New User?</a><br>
                    <a href="sendAndVerifyCode.jsp">Forgot Password?</a><br><br>
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                </form>
            </div>
        </div>
    </div>
</div>

 Bootstrap JS and dependencies 
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>-->
