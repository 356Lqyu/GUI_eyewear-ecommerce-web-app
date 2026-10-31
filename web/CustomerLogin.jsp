<%@ page import="model.*, javax.naming.InitialContext, javax.naming.Context" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="login.css" />
        <title>Four Eyes Collective - Customer Login</title>
    </head>
    <body>
        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="Images/LOGO3.png" alt="Four Eyes Collective Logo" style="height: 120px;">
                </a>
            </div>

            <!-- Login form to enter username and password -->
            <div class="form-container">
                <div class="form-box">
                    <h1>Welcome Back</h1>
                    <!-- Link to ProcessLogin servlet -->
                    <form action="ProcessLogin" method="POST">
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input name="username" id="usernameBox" type="text" placeholder="Username" required />
                        </div>

                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input name="password" id="passwordBox" type="password" placeholder="Password" required />
                        </div>
                        <!-- Show login error message -->
                        <% 
                            String error = (String) request.getAttribute("error");
                            if (error != null) { 
                        %>
                        <div class="error-message" style="color: red; margin-bottom: 1rem;">
                            <%= error %>
                        </div>
                        <% } %>

                        <!-- Go back login role selection or password recovery -->
                        <div class="link-container">
                            <a href="LoginRoleSelection.html" class="back-link">Back</a>
                            <a href="ForgotPassword.jsp" class="forgot-link">Forgot password?</a>
                        </div>

                        <button type="submit" id="runBtn" name="submit">SIGN IN</button>

                        <!-- Customer registration button -->
                        <div class="run-link">
                            Don't have an account? <a href="RegisterCustomer.jsp">Register here</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </body>
</html>