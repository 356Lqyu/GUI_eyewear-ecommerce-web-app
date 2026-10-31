<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <title>Four Eyes Collective - Password Recovery</title>
        <link rel="stylesheet" href="login.css" />
        <style>
            .form-container {
                height:520px;
            }

            .error-message {
                color: red;
                margin-bottom: 1rem;
                text-align: center;
            }

            .success-message {
                color: green;
                margin-bottom: 1rem;
                text-align: center;
            }

            .security-question {
                margin-bottom: 0.5rem;
                color: var(--text-dark);
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="Images/LOGO3.png" alt="Four Eyes Collective Logo" style="height: 120px;">
                </a>
            </div>

            <div class="form-container">
                <div class="form-box">
                    <h1>Password Recovery</h1>
                    <!-- Enter username , if username exist , then security question will be displayed -->
                    <% 
                    String error = (String) request.getAttribute("error");
                    String username = (String) request.getAttribute("username");
                    String securityQuestion = (String) request.getAttribute("securityQuestion");
                    String password = (String) request.getAttribute("password");
                    
                    if (error != null) { 
                    %>
                    <!-- Show error message if username not exist / security answer invalid -->
                    <div class="error-message">
                        <%= error %>
                    </div>
                    <% } %>

                    <% if (password != null) { %>
                    <div class="success-message">
                        <i class="fas fa-lock-open" style="font-size: 70px; padding-top: 40px;"></i>
                        <p style="padding-top: 40px; font-style: oblique; font-size: 19px;">Your password is: <strong><%= password %></strong></p>
                    </div>
                    <div class="run-link" style="padding-top: 100px;">
                        <a href="<%= request.getContextPath() %>/LoginRoleSelection.html">Back to Login</a>
                    </div>
                    <% } else { %>
                    <form action="PasswordRecovery" method="POST">
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input name="username" type="text" placeholder="Username" required value="<%= username != null ? username : "" %>" 
                                   <%= securityQuestion != null ? "readonly" : "" %>/>
                        </div>
                       
                        <!-- Get sequrity question and display -->
                        <% if (securityQuestion != null) { %>
                        <div class="security-question">
                            Your Security Question:  <%= securityQuestion %>
                        </div>
                        <div class="input-group">
                            <i class="fas fa-question-circle"></i>
                            <input name="securityAnswer" type="text" placeholder="Enter your answer" required />
                        </div>
                        <% } %>

                        <!-- Show "recovery passwrod" for username; show "verigy answer" for security answer -->
                        <button type="submit" id="runBtn">
                            <%= securityQuestion != null ? "VERIFY ANSWER" : "RECOVER PASSWORD" %>
                        </button>

                        <div class="run-link">
                            Remember your password? <a href="<%= request.getContextPath() %>/LoginRoleSelection.html">Login here</a>
                        </div>
                    </form>
                    <% } %>
                </div>
            </div>
        </main>
    </body>
</html>