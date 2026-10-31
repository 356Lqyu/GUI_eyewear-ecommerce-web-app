<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.text.SimpleDateFormat, javax.naming.*" %>
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
        <title>Customer Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../home.css" />
        <link rel="stylesheet" href="../customerMenu.css" />
        <style>
            body {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .profile-container {
                display: flex;
                margin-top: 20px;
                gap: 30px;
                width: 1000px;
                min-height: 600px;
            }

            .profile-icon {
                flex: 0 0 200px;
                height: 480px;
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 20px 15px;
                border-radius: 100px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.03);
                border: 1px dashed lightgray;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .profile-icon:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(0,0,0,0.06);
            }

            .user-icon {
                width: 150px;
                height: 150px;
                background-color: #f1f1f1;
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 15px;
                border: 4px solid #f5f5f5;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                overflow: hidden;
            }

            .user-icon i {
                font-size: 80px;
                color: #7d7d7d;
            }

            .user-role {
                background-color: #4a4a4a;
                color: white;
                padding: 6px 16px;
                border-radius: 16px;
                font-size: 0.85rem;
                text-transform: capitalize;
                letter-spacing: 0.5px;
                margin-top: 8px;
            }

            .user-name {
                font-size: 1.2rem;
                font-weight: 600;
                margin-top: 12px;
                color: #333;
                text-align: center;
            }

            .profile-details {
                flex: 1;
            }

            .profile-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
            }

            .info-item {
                margin: 15px 0;
                position: relative;
                padding-left: 3px;
            }

            .info-label {
                font-weight: 600;
                color: #666;
                display: block;
                margin-bottom: 6px;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .info-value {
                color: #333;
                font-size: 1rem;
                word-break: break-word;
                font-style: italic;
            }

            .action-buttons {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 30px;
            }

            .btn-primary {
                background-color: #4a4a4a;
                color: white;
                box-shadow: 0 3px 8px rgba(74, 74, 74, 0.2);
            }

            .btn-primary:hover {
                background-color: #333;
                box-shadow: 0 5px 12px rgba(74, 74, 74, 0.3);
                transform: translateY(-2px);
            }

            .btn-secondary {
                background-color: #f44336;
                color: white;
                box-shadow: 0 3px 8px rgba(244, 67, 54, 0.2);
            }

            .btn-secondary:hover {
                background-color: #d32f2f;
                box-shadow: 0 5px 12px rgba(244, 67, 54, 0.3);
                transform: translateY(-2px);
            }

            @media (max-width: 992px) {
                .profile-container {
                    flex-direction: column;
                }

                .profile-icon {
                    flex: initial;
                    width: 100%;
                    max-width: 250px;
                    margin: 0 auto;
                }
            }

            @media (max-width: 768px) {
                .profile-section {
                    padding: 20px;
                    margin: 15px auto;
                }

                .profile-info {
                    grid-template-columns: 1fr;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    justify-content: center;
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

        <!-- My profile section -->
        <div class="profile-section">
            <h1>My Profile</h1>

            <div class="profile-container">
                <div class="profile-icon">
                    <div class="user-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-name"><%= user.getUsername() %></div>
                    <div class="user-role"><%= user.getRole() %></div>
                </div>

                <!-- Customer details -->
                <div class="profile-details">
                    <div class="profile-info">
                        <div class="info-card">
                            <h3>Personal Information</h3>
                            <div class="info-item">
                                <span class="info-label">User ID</span>
                                <span class="info-value"><%= user.getUserId() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Ic Number</span>
                                <span class="info-value"><%= user.getIc() %></span>
                            </div>
                        </div>

                        <div class="info-card">
                            <h3>Contact Information</h3>
                            <div class="info-item">
                                <span class="info-label">Email</span>
                                <span class="info-value"><%= user.getEmail() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Contact Number</span>
                                <span class="info-value"><%= user.getContactNumber() %></span>
                            </div>
                        </div>

                        <div class="info-card" style="width:700px;">
                            <h3>Security Information</h3>
                            <div class="info-item">
                                <span class="info-label">Password</span>
                                <span class="info-value">********</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Security Question</span>
                                <span class="info-value"><%= user.getSecurityQuestion() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Security Answer</span>
                                <span class="info-value">********</span>
                            </div>
                        </div>
                    </div>

                    <!-- button to edit profile and reset password -->
                    <div class="action-buttons">
                        <a href="EditProfile.jsp" class="btn btn-primary">Edit Profile</a>
                        <a href="ResetPassword.jsp" class="btn btn-secondary">Change Password</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer (Global parameter -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}
        </footer>
    </body>
</html>