<%@ page import="model.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get the user from session 
    Users user = (Users) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect("../CustomerLogin.html");
        return;
    }
    
    // To get customer details 
    Customer customerDetails = user.getCustomer();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Reset Password</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../home.css" />
        <link rel="stylesheet" href="../form.css" />
        <link rel="stylesheet" href="../customerMenu.css" />

        <style>
            .input-group {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 0;
            }

            .input-field {
                display: flex;
                flex-direction: column;
                margin-bottom: 15px;
            }

            .input-field label {
                margin-bottom: 8px;
                font-weight: 600;
                color: #666;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .input-field input {
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 0.95rem;
                transition: all 0.3s;
                font-family: 'Segoe UI', sans-serif;
            }

            .input-field input:focus {
                border-color: #4a4a4a;
                box-shadow: 0 0 0 2px rgba(74, 74, 74, 0.2);
                outline: none;
            }

            .btn-container {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                gap: 12px;
            }


            .btn-cancel {
                background-color: #f1f1f1;
                color: #333;
                flex: 1;
                max-width: 200px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.05);
            }

            .btn-cancel:hover {
                background-color: #e1e1e1;
                box-shadow: 0 5px 12px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }

            .btn-submit {
                background-color: #4a4a4a;
                color: white;
                flex: 1;
                max-width: 200px;
                box-shadow: 0 3px 8px rgba(74, 74, 74, 0.2);
            }

            .btn-submit:hover {
                background-color: #333;
                box-shadow: 0 5px 12px rgba(74, 74, 74, 0.3);
                transform: translateY(-2px);
            }

            .error-text {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
                display: none;
            }

            .password-mismatch {
                border-color: #dc3545 !important;
            }

            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 5px;
                margin: 25px auto;
                max-width: 1000px;
                border: 1px solid #c3e6cb;
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 10px;
                border-radius: 5px;
                margin: 25px auto;
                max-width: 1000px;
                border: 1px solid #f5c6cb;
            }

            @media (max-width: 768px) {
                .input-group {
                    grid-template-columns: 1fr;
                }

                .btn-container {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    max-width: none;
                    margin-bottom: 8px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <div class="navbar">
            <div class="navbar-left">
                <img src="../Images/LOGO2.png" alt="Logo" />
                <a href="../secureCustomer/CustomerDashboard.jsp">Home</a>
                <a href="../Promotion.jsp">Promotion</a>
                <a href="../Product.jsp">Product</a>
                <a href="../about_contact.jsp">About Us</a>
                <a href="#">Rating</a>
            </div>

            <!-- Global parameter (company name) -->
            <div class="header-title">
                <div class="company-name">${companyName}</div>
                <div class="dashboard-title">Customer Dashboard</div>
            </div>

            <div class="navbar-right">
                <div class="search-container">
                    <form action="../Product.jsp" method="get" onsubmit="return validateSearch()">
                        <input type="text" id="searchInput" name="search" placeholder="Search products id or name..." />
                    </form>
                </div>

                <!-- Cart Icon -->
                <a href="Cart.jsp" class="icon" title="Cart">                
                    <i class="fas fa-shopping-cart"></i>
                </a>

                <!-- User profile icon -->
                <a href="UserProfile.jsp" class="icon" title="User Profile">
                    <i class="fas fa-user"></i>
                </a>

                <!-- Logout icon -->
                <a href="../Logout.jsp" class="icon" title="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>
        <main style="flex: 1;">
            <!-- Success & error message -->
            <% if (session.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                <div class="success-icon">
                    <i class="fas fa-check" style="border-color: white;"></i>
                </div>
                <div>
                    <%= session.getAttribute("successMessage") %>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </div>
            <% } %>

            <% if (session.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <div class="error-icon">
                    <i class="fas fa-times"></i>
                </div>
                <div>
                    <%= session.getAttribute("errorMessage") %>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            </div>
            <% } %>

            <!-- Reset Password Section -->
            <div class="profile-section" style="margin-top: 50px;">
                <h1>Reset Password</h1>
                <form action="../ResetPasswordServlet" method="post" onsubmit="return confirm('Sure to reset your password?')">
                    <!-- Password Reset (new password and confirm password) -->
                    <div class="info-card">
                        <h3><i class="fas fa-key"></i> Password Reset</h3>
                        <div class="input-group">
                            <div class="input-field">
                                <label for="newPassword">New Password</label>
                                <input id="newPassword" name="newPassword" type="password" 
                                       placeholder="Enter new password (min 8 characters)" 
                                       required onkeyup="validatePasswords()" />
                            </div>
                            <div class="input-field">
                                <label for="confirmPassword">Confirm Password</label>
                                <input id="confirmPassword" name="confirmPassword" type="password" 
                                       placeholder="Confirm new password" 
                                       required onkeyup="validatePasswords()" />
                                <span id="passwordError" class="error-text">Passwords do not match!</span>
                            </div>
                        </div>
                    </div>

                    <!-- Button to back & reset -->
                    <div class="btn-container">
                        <a href="UserProfile.jsp" class="btn btn-cancel">Cancel</a>
                        <button type="submit" id="submitButton" class="btn btn-submit">Reset Password</button>
                    </div>
                </form>
            </div>
        </main>
        <!-- Footer (Global parameter -->
        <footer style="
                margin-top: 224px;
                text-align: center;
                bottom: 0;
                left: 0;
                right: 0;">
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>

        </footer>
    </body>
</html>