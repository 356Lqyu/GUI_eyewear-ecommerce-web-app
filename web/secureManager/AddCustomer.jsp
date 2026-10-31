<%@ page import="model.*, java.util.List, controller.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="userService" class="model.UserService" scope="request" />
<%
    String newUserId = "CU" + String.format("%04d", (int)(Math.random() * 9000) + 1000);
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear the messages from session after displaying
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
        <title>Add Customer</title>
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

                <li class="active">
                    <div class="menu-section-title active">
                        <i class="fas fa-users"></i>
                        <span>Customers</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureManager/AddCustomer.jsp" class="active"><i class="fas fa-user-plus"></i> Add Customer</a></li>
                        <li><a href="../secureManager/ManageCustomer.jsp"><i class="fas fa-address-book"></i> Manage Customer</a></li>
                    </ul>
                </li>

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
                        <li><a href="../secureManager/selectMonth.jsp"><i class="fas fa-shopping-cart"></i> Monthly Report</a></li>
                        <li><a href="../secureManager/ProductReport.jsp"><i class="fas fa-boxes"></i> Product Report</a></li>
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
                    <div class="dashboard-title">Manager Dashboard</div>
                </div>
                <div class="header-icons">
                    <a href="ManagerDashboard.jsp" class="header-icon" title="Dashboard">
                        <i class="fas fa-home"></i>
                    </a>
                    <a href="../secureStaff/ManagementProfile.jsp" class="header-icon" title="User Profile">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="../Logout.jsp" class="header-icon" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>

            <!-- Show success and error message -->
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

            <!-- Add customer form -->
            <div class="form-container">
                <h2 class="form-title">ADD NEW CUSTOMER</h2>
                <form action="${pageContext.request.contextPath}/AddUserServlet" method="post" onsubmit="return confirm('Sure to add customer [' + document.getElementById('username').value + '] ?') >
                            <!-- Personal Info -->
<h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="userId">User ID</label>
                            <input id="userId" name="userId" type="text" value="<%= newUserId %>" readonly required />
                        </div>
                        <div class="input-field">
                            <label for="username">Username</label>
                            <input id="username" name="username" type="text" placeholder="Enter username (unique)" required />
                        </div>
                    </div>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="password">Password</label>
                            <input id="password" name="password" type="password" placeholder="Enter password" required />
                        </div>
                        <div class="input-field">
                            <label for="ic">IC Number</label>
                            <input id="ic" name="ic" type="text" placeholder="Enter Ic (YYMMDD-XX-XXXX)" required />
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <h3 class="section-title"><i class="fas fa-phone"></i> Contact Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="email">Email Address</label>
                            <input id="email" name="email" type="email" placeholder="Enter email (XXX@gmail.com)" required />
                        </div>
                        <div class="input-field">
                            <label for="contactNumber">Contact Number</label>
                            <input id="contactNumber" name="contactNumber" type="text" placeholder="Enter contact number (0XX-XXXXXXX)" required />
                        </div>
                    </div>

                    <!-- Security Info -->
                    <h3 class="section-title"><i class="fas fa-shield-alt"></i> Security Question</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="securityQuestion">Security Question</label>
                            <input id="securityQuestion" name="securityQuestion" type="text" placeholder="Enter security question" required />
                        </div>
                        <div class="input-field">
                            <label for="securityAnswer">Security Answer</label>
                            <input id="securityAnswer" name="securityAnswer" type="text" placeholder="Enter answer" required />
                        </div>
                    </div>

                    <input type="hidden" name="role" value="customer">

                    <div class="btn-container">
                        <button type="submit" class="btn-submit">Add</button>
                    </div>
                </form>
            </div>

            <!-- Footer -->
            <footer style="
                    margin-left: 16%;
                    text-align: center;
                    bottom: 0;
                    left: 0;
                    width: 70%;
                    right: 0;">
                ${copyright}
            </footer>
        </main>
            
    </body>
</html>