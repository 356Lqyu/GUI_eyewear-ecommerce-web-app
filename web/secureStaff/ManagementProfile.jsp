<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.text.SimpleDateFormat, javax.naming.InitialContext, javax.naming.Context" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Users user = (Users) session.getAttribute("user");
    
    // After login manager & staff , load user (so can show their profile)
    if (user == null && request.getUserPrincipal() != null) {
        try {
            Context ctx = new InitialContext();
            UserService userService = (UserService) ctx.lookup("java:global/FourEyesCollective/UserService");
            
            String username = request.getUserPrincipal().getName();
            user = userService.findUserByUsername(username);
            
            if (user != null) {
                String role = user.getRole();
                if ("manager".equals(role)) {
                    user.setManager(userService.findManagerById(user.getUserId()));
                } else if ("staff".equals(role)) {
                    user.setStaff(userService.findStaffById(user.getUserId()));
                }
                session.setAttribute("user", user);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading user profile: " + e.getMessage());
        }
    }

    // Check if whether user is found 
    if (user == null) {
        if (request.getUserPrincipal() != null) {
            // If cannot load their profile , so error
            session.setAttribute("errorMessage", "Could not load your profile. Please try again.");
        }
        response.sendRedirect(request.getContextPath() + "/LoginRoleSelection.html");
        return;
    }
    
    // Get role-specific details to make sure the user login is manager or staff
    String role = user.getRole();
    Staff staffDetails = user.getStaff();
    Manager managerDetails = user.getManager();
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>User Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../menu.css" />
        <link rel="stylesheet" href="../managementMenu.css" />


        <style>
            .profile-section {
                background: white;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                    animation: fadeIn 1s ease-out

            }

            .profile-section h1 {
                color: var(--dark-color);
                margin-top: 0;
                font-size: 1.8rem;
                border-bottom: 2px solid var(--light-color);
                padding-bottom: 15px;
            }

            .profile-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .info-card {
                background-color: #f9f9f9;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }

            .info-card h3 {
                margin-top: 0;
                color: var(--primary-color);
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }

            .info-item {
                margin: 15px 0;
            }

            .info-label {
                font-weight: bold;
                color: var(--secondary-color);
                display: block;
                margin-bottom: 5px;
            }

            .info-value {
                color: var(--dark-color);
                font-style: italic;
            }

            .action-buttons {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-submit {
                background-color: var(--primary-color);
                color: white;
            }

            .btn-submit:hover {
                background-color: var(--secondary-color);
            }

            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
                border: 1px solid #c3e6cb;
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <h2> </h2>
            <ul class="sidebar-menu">
                <% if ("manager".equals(user.getRole())) { %>
                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-user-tie"></i>
                        <span>Staff</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureManager/AddStaff.jsp"><i class="fas fa-user-plus"></i> Add Staff</a></li>
                        <li><a href="../secureManager/ManageStaff.jsp"><i class="fas fa-users-cog"></i> Manage Staff</a></li>
                    </ul>
                </li>

                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-users"></i>
                        <span>Customers</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureManager/AddCustomer.jsp"><i class="fas fa-user-plus"></i> Add Customer</a></li>
                        <li><a href="../secureManager/ManageCustomer.jsp"><i class="fas fa-address-book"></i> Manage Customer</a></li>
                    </ul>
                </li>
                <% } %>

                <% if ("manager".equals(user.getRole()) || "staff".equals(user.getRole())) { %>
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
                <% } %>


                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-chart-pie"></i>
                        <span>Reports</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <% if ("manager".equals(user.getRole())) { %>
                        <li><a href="../secureManager/selectMonth.jsp"><i class="fas fa-shopping-cart"></i> Monthly Report</a></li>
                        <li><a href="../secureManager/ProductReport.jsp"><i class="fas fa-boxes"></i> Product Report</a></li>
                            <% } %>
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
                <% if ("manager".equals(user.getRole())) { %>
                <div class="header-title">
                    <div class="company-name">${companyName}</div>
                    <div class="dashboard-title">Manager Dashboard</div>
                </div>
                <div class="header-icons">
                    <a href="../secureManager/ManagerDashboard.jsp" class="header-icon" title="Dashboard">
                        <% } else if ("staff".equals(user.getRole())) { %>
                        <div class="header-title">
                            <div class="company-name">${companyName}</div>
                            <div class="dashboard-title">Staff Dashboard</div>
                        </div>
                        <div class="header-icons">
                            <a href="../secureStaff/StaffDashboard.jsp" class="header-icon" title="Dashboard">
                                <% } %>

                                <i class="fas fa-home"></i>
                            </a>
                            <a href="../Logout.jsp" class="header-icon" title="Logout">
                                <i class="fas fa-sign-out-alt"></i>
                            </a>
                        </div>
                </div>

                <% if (session.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    <%= session.getAttribute("successMessage") %>
                    <% session.removeAttribute("successMessage"); %>
                </div>
                <% } %>

                <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= session.getAttribute("errorMessage") %>
                    <% session.removeAttribute("errorMessage"); %>
                </div>
                <% } %>

                <div class="profile-section">
                    <h1>My Profile</h1>

                    <div class="profile-info">
                        <div class="info-card">
                            <h3>Personal Information</h3>
                            <div class="info-item">
                                <span class="info-label">User ID</span>
                                <span class="info-value"><%= user.getUserId() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Username</span>
                                <span class="info-value"><%= user.getUsername() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">MyKad Number</span>
                                <span class="info-value"><%= user.getIc() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Role</span>
                                <span class="info-value"><%= user.getRole() %></span>
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
                                <span class="info-value"><%= user.getContactNumber() != null ? user.getContactNumber() : "Not provided" %></span>
                            </div>
                        </div>

                        <div class="info-card">
                            <h3>Security Information</h3>
                            <div class="info-item">
                                <span class="info-label">Password</span>
                                <span class="info-value">********</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Security Question</span>
                                <span class="info-value"><%= user.getSecurityQuestion() != null ? user.getSecurityQuestion() : "Not set" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Security Answer</span>
                                <span class="info-value">********</span>
                            </div>
                        </div>

                        <% if ("staff".equals(role) && staffDetails != null) { %>
                        <div class="info-card">
                            <h3>Job Details</h3>
                            <div class="info-item">
                                <span class="info-label">Hired Date</span>
                                <span class="info-value"><%= dateFormat.format(staffDetails.getHiredDate()) %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Salary</span>
                                <span class="info-value">RM <%= String.format("%.2f", staffDetails.getSalary()) %></span>
                            </div>
                        </div>
                        <% } %>


                    </div>

                    <div class="action-buttons">
                        <a href="EditManagementProfile.jsp" class="btn btn-submit">Edit Profile</a>
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