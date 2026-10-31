<%@ page import="model.*, java.util.List, controller.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get customer data from request 
    Users customerToModify = (Users) request.getAttribute("customerToModify");
    
    // If customerToModify is null , redirect to the list
    if (customerToModify == null) {
        response.sendRedirect("ListCustomerServlet");
        return;
    }
    
    Customer customerDetails = customerToModify.getCustomer();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Modify Customer</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../menu.css" />
        <link rel="stylesheet" href="../form.css" />
        <link rel="stylesheet" href="../managementMenu.css" />
        <style>
            .btn-container {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }

            .btn-cancel {
                background: linear-gradient(135deg, #6c757d, #495057);
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .btn-cancel:hover {
                background: linear-gradient(135deg, #5a6268, #343a40);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .btn-submit {
                background: linear-gradient(135deg, #28a745, #218838);
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .btn-submit:hover {
                background: linear-gradient(135deg, #218838, #1e7e34);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .error-icon {
                font-size: 20px;
            }

            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .success-icon {
                font-size: 20px;
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
                    <div class="menu-section-title">
                        <i class="fas fa-users"></i>
                        <span>Customers</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureManager/AddCustomer.jsp"><i class="fas fa-user-plus"></i> Add Customer</a></li>
                        <li><a href="../secureManager/ManageCustomer.jsp" class="active"><i class="fas fa-address-book"></i> Manage Customer</a></li>
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
                    <a href="../secureManager/ManagerDashboard.jsp" class="header-icon" title="Dashboard">
                        <i class="fas fa-home"></i>
                    </a>
                    <a href="../secureStaff/ManagementProfile.jsp" class="header-icon" title="User Profile">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="../Logout" class="header-icon" title="Logout">
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

            <!-- Customer modification form -->
            <div class="form-container">
                <h2 class="form-title">MODIFY CUSTOMER</h2>
                <form action="<%= request.getContextPath() %>/ModifyUserServlet" method="post" onsubmit="return confirm('Sure to modify customer [' + document.getElementById('username').value + '] ?')">

                    <!-- Personal Info -->
                    <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="userId">User ID</label>
                            <input id="userId" name="userId" type="text" value="<%= customerToModify.getUserId() %>" readonly required />
                        </div>
                        <div class="input-field">
                            <label for="username">Username</label>
                            <input id="username" name="username" type="text" value="<%= customerToModify.getUsername() %>" placeholder="Enter username" required />
                        </div>
                    </div>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="password">Password</label>
                            <input id="password" name="password" type="password" value="<%= customerToModify.getPassword() %>" placeholder="Enter password" required />
                        </div>
                        <div class="input-field">
                            <label for="ic">IC Number</label>
                            <input id="ic" name="ic" type="text" value="<%= customerToModify.getIc() %>" placeholder="Enter IC number" required />
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <h3 class="section-title"><i class="fas fa-phone"></i> Contact Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="email">Email Address</label>
                            <input id="email" name="email" type="email" value="<%= customerToModify.getEmail() %>" placeholder="Enter email" required />
                        </div>
                        <div class="input-field">
                            <label for="contactNumber">Contact Number</label>
                            <input id="contactNumber" name="contactNumber" type="text" value="<%= customerToModify.getContactNumber() != null ? customerToModify.getContactNumber() : "" %>" placeholder="Enter phone number" />
                        </div>
                    </div>

                    <!-- Security Info -->
                    <h3 class="section-title"><i class="fas fa-shield-alt"></i> Security Question</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="securityQuestion">Security Question</label>
                            <input id="securityQuestion" name="securityQuestion" type="text" value="<%= customerToModify.getSecurityQuestion() != null ? customerToModify.getSecurityQuestion() : "" %>" placeholder="Enter security question" required />
                        </div>
                        <div class="input-field">
                            <label for="securityAnswer">Security Answer</label>
                            <input id="securityAnswer" name="securityAnswer" type="text" value="<%= customerToModify.getSecurityAnswer() != null ? customerToModify.getSecurityAnswer() : "" %>" placeholder="Enter answer" required />
                        </div>
                    </div>

                    <input type="hidden" name="role" value="customer">

                    <div class="btn-container">
                        <a href="ManageCustomer.jsp" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit">Update Customer</button>
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