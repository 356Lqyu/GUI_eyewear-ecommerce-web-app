<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.List, controller.*, javax.naming.InitialContext, javax.naming.Context , jakarta.persistence.*" %>

<%
    // Get user from session
    Users user = (Users) session.getAttribute("user");
    
    // User is not in session but is authenticated, then load them so able to use for profile
    if (user == null && request.getUserPrincipal() != null) {
        try {
            Context ctx = new InitialContext();
            UserService userService = (UserService) ctx.lookup("java:global/FourEyesCollective/UserService");
            
            String username = request.getUserPrincipal().getName();
            user = userService.findUserByUsername(username);
            
            if (user != null) {
                // Load manager details
                if ("staff".equals(user.getRole())) {
                    user.setStaff(userService.findStaffById(user.getUserId()));
                    session.setAttribute("user", user);
                } 
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading user data: " + e.getMessage());
        }
    }
    
    // Redirect to login if no user in session or not a staff
    if (user == null || !"staff".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/ManagementLogin.jsp");
        return;
    }
    
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../menu.css" />
                <link rel="stylesheet" href="../managementMenu.css" />

        <style>

            .welcome-section {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: white;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .welcome-section h1 {
                margin: 0;
                font-size: 2rem;
            }

            .welcome-section p {
                margin: 10px 0 0;
                opacity: 0.9;
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2> </h2>
            <ul class="sidebar-menu">
                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-tags"></i>
                        <span>Categories</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureStaff/AddCategory.jsp"><i class="fas fa-plus-circle"></i> Add Category</a></li>
                        <li><a href="../secureStaff/ManageCategory.jsp"><i class="fas fa-tag"></i> Manage Categories</a></li>
                    </ul>
                </li>

                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-boxes"></i>
                        <span>Products</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureStaff/AddProduct.jsp"><i class="fas fa-plus-circle"></i> Add Product</a></li>
                        <li><a href="../secureStaff/ManageProduct.jsp"><i class="fas fa-box-open"></i> Manage Products</a></li>
                    </ul>
                </li>
                
                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-star"></i>
                        <span>Customer Feedback</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureStaff/ManageRating.jsp"><i class="fas fa-comments"></i> Manage Reviews</a></li>
                    </ul>
                </li>
                
                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-percentage"></i>
                        <span>Promotion</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureStaff/UploadPromotion.jsp"><i class="fas fa-plus-circle"></i> Upload Promotion</a></li>
                    </ul>
                </li>
                
                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-chart-pie"></i>
                        <span>Reports</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureStaff/OrderList.jsp"><i class="fas fa-database"></i> Customer Records</a></li>
                    </ul>
                </li>
            </ul>
        </div>

        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="../Images/LOGO3.png" alt="Logo" style="height: 110px;">
                </a>
                <div class="header-title">
                    <div class="company-name">${companyName}</div>
                    <div class="dashboard-title">Staff Dashboard</div>
                </div>
                <div class="header-icons">
                    <a href="../secureStaff/ManagementProfile.jsp" class="header-icon" title="User Profile">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="../Logout.jsp" class="header-icon" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
            <!-- Welcome message  -->
            <div class="dashboard-content">
                <div class="welcome-section">
                    <h1>Welcome, Staff Member <%= user.getUsername()%> </h1>
                    <p>This is your control panel. You can manage category, products, and customer records from here.</p>
                </div>
            </div>

            <!-- Footer -->
            <footer style="padding: 15px;
                    padding-left: 250px;
                    text-align: center;
                    position: fixed;
                    bottom: 0;
                    left: 0;
                    right: 0;">
                ${copyright}
            </footer>
        </main>
    </body>
</html>