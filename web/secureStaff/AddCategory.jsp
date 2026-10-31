<%@ page import="javax.naming.Context, javax.naming.InitialContext" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.*, java.util.*, controller.* , jakarta.persistence.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    
    String newCategoryId = "CA" + String.format("%04d", (int)(Math.random() * 9000) + 1000);
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add Category</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../menu.css" />
        <link rel="stylesheet" href="../form.css" />
        <link rel="stylesheet" href="../managementMenu.css" />
        <style>
            .error-message {
                background-color: #ffebee;
                color: #c62828;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .success-message {
                background-color: #e8f5e9;
                color: #2e7d32;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .message-container i {
                margin-right: 8px;
                font-size: 18px;
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
                <li class="active">
                    <div class="menu-section-title">
                        <i class="fas fa-tags"></i>
                        <span>Categories</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureStaff/AddCategory.jsp" class="active"><i class="fas fa-plus-circle"></i> Add Category</a></li>
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
                    </a>
                    <a href="../secureStaff/ManagementProfile.jsp" class="header-icon" title="User Profile">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="../Logout.jsp" class="header-icon" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>

            <!-- Success message -->
            <% if (successMessage != null) { %>
            <div class="message-container success-message">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>
            <% } %>
            <% if (errorMessage != null) { %>
            <div class="message-container error-message">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
            <% } %>

            <div class="form-container">
                <h2 class="form-title">ADD NEW CATEGORY</h2>
                <form action="${pageContext.request.contextPath}/AddCategoryServlet" method="post" onsubmit="return confirm('Sure to add category [' + document.getElementById('categoryName').value + '] ?')">
                    <h3 class="section-title"><i class="fas fa-folder"></i> Category Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="categoryId">Category ID</label>
                            <input id="categoryId" name="categoryId" type="text" value="<%= newCategoryId %>" readonly required />
                        </div>
                        <div class="input-field">
                            <label for="categoryName">Category Name</label>
                            <input id="categoryName" name="categoryName" type="text" placeholder="Enter category name" required />
                        </div>
                    </div>

                    <div class="btn-container" style="padding-top:50px;">
                        <button type="submit" class="btn-submit">Add Category</button>
                    </div>
                </form>
            </div>

            <!-- Footer -->
            <footer style="position: absolute;
                    bottom: 0;
                    left: 0px; 
                    right: 0;
                    text-align: center;
                    padding: 20px 0;
                    margin-top: 30px;
                    background-color: var(--light-color);
                    border-top: 1px solid #ddd;">
                ${copyright}
            </footer>
        </main>
    </body>
</html>
