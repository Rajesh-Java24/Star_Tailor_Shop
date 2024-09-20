<%@ page session="true" %>
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
        .navbar-nav .nav-link:hover {
            background-color: rgb(255, 165, 0);
            color: #000;
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
                <a class="nav-link" href="customerVisibleHome.jsp">Available Products</a>
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
<div class="container text-center ">
	<h1>WELCOME TO STAR TAILOR</h1>
        <h6>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet, rem consectetur exercitationem libero nihil, eos nostrum voluptatibus aperiam in maiores minus quia, quasi nesciunt culpa! Fuga exercitationem incidunt officia voluptas!.Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet, rem consectetur exercitationem libero nihil, eos nostrum voluptatibus aperiam in maiores minus quia, quasi nesciunt culpa! Fuga exercitationem incidunt officia voluptas!.Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet, rem consectetur exercitationem libero nihil, eos nostrum voluptatibus aperiam in maiores minus quia, quasi nesciunt culpa! Fuga exercitationem incidunt officia voluptas!.Lorem ipsum, dolor sit amet consectetur adipisicing elit. Eveniet, rem consectetur exercitationem libero nihil, eos nostrum voluptatibus aperiam in maiores minus quia, quasi nesciunt culpa! Fuga exercitationem incidunt officia voluptas!.</h6><br><br>
        <img src="./images/Tailorshop.jpg" width="30%" higth="30%">
        
</div>
</body>
</html>