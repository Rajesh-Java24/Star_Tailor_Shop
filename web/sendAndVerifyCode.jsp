<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Star Tailor - Home</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles -->
    <style>
        .navbar {
            background-color: #343a40;
        }
        .navbar-brand, .navbar-text {
            color: #ffffff;
        }
        .form-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .footer {
            text-align: center;
            padding: 10px;
            background-color: #343a40;
            color: #ffffff;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>
    
<!--    <form action="logout.jsp" method="post">
        <input type="submit" value="Logout">
    </form>-->

<!-- Navigation bar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <a class="navbar-brand" href="#">Star Tailor</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item active">
                <a class="nav-link" href="home1.jsp">Home</a>
            </li>
            <li class="nav-item ">
                <a class="nav-link" href="login.jsp">Login</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="register.jsp">Register</a>
            </li>
            
        </ul>
    </div>
</nav>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 mt-4">
                <div class="card custom-card">
                    <div class="card-body">
                        <h1 class="card-title text-center">Reset Password</h1>
                        <br/>
                        <span><h3>${param.result}</h3></span>
                        <form action="ResetPasswordController" method="post">
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" required/>
                            </div>
                            <div class="form-group" id="codeSection" style="display:none;">
                                <label for="code">Reset Code</label>
                                <input type="text" class="form-control" id="code" name="code"/>
                            </div>
                            <div class="form-group" id="newPasswordSection" style="display:none;">
                                <label for="newPassword">New Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword"/>
                                    <div class="input-group-append">
                                        <span class="input-group-text visibility-toggle" onclick="togglePasswordVisibility('newPassword', 'passwordIcon')">
                                            <i class="fas fa-eye" id="passwordIcon"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="confirmPasswordSection" style="display:none;">
                                <label for="confirmPassword">Confirm Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"/>
                                    <div class="input-group-append">
                                        <span class="input-group-text visibility-toggle" onclick="togglePasswordVisibility('confirmPassword', 'confirmPasswordIcon')">
                                            <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" id="action" name="action" value="sendCode"/>
                            <button type="submit" class="btn btn-primary btn-block" id="submitButton">Send Code</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script>
        const result = "${param.result}";
        const codeSection = document.getElementById('codeSection');
        const newPasswordSection = document.getElementById('newPasswordSection');
        const confirmPasswordSection = document.getElementById('confirmPasswordSection');
        const submitButton = document.getElementById('submitButton');
        const actionInput = document.getElementById('action');

        if (result === "verifyCode") {
            codeSection.style.display = 'block';
            submitButton.textContent = 'Verify Code';
            actionInput.value = 'verifyCode';
        } else if (result === "setNewPassword") {
            newPasswordSection.style.display = 'block';
            confirmPasswordSection.style.display = 'block';
            submitButton.textContent = 'Set New Password';
            actionInput.value = 'setNewPassword';
        }

        function togglePasswordVisibility(fieldId, iconId) {
            const passwordField = document.getElementById(fieldId);
            const passwordIcon = document.getElementById(iconId);
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                passwordIcon.classList.remove('fa-eye');
                passwordIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                passwordIcon.classList.remove('fa-eye-slash');
                passwordIcon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>
