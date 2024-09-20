<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>

<html lang="en"> 

<head> 
    <meta charset="UTF-8"> 
    <title>Animated Login Form</title> 
    <link rel="stylesheet" href="./stylesheet.css"> 
</head> 

<body> 
    <section> 
        <!-- Background elements -->
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
        <span></span><span></span><span></span><span></span><span></span>
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
                    <div class="inputBox"> 
                        <input type="text" required> 
                        <i>Username</i> 
                    </div> 
                    <div class="inputBox"> 
                        <input type="password" required> 
                        <i>Password</i> 
                    </div> 
                    
                    <!-- Role Dropdown -->
                    <div class="inputBox">                       
                        <select class="form-control" id="role" name="role" required>
                            <option value="" disabled selected >Select Role</option>
                            <option value="Customer">Customer</option>
                            <option value="Employee">Employee</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>

                    <div class="links"> 
                        <a href="#">Forgot Password</a> 
                        <a href="#">Signup</a> 
                    </div> 
                    <div class="inputBox"> 
                        <input type="submit" value="Login"> 
                    </div> 
                </div> 
            </div> 
        </div> 
    </section> 
</body>

</html>
