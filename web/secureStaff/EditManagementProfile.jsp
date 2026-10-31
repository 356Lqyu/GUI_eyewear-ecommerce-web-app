<%@ page import="model.*, java.text.SimpleDateFormat" %>
<%@ page import="javax.naming.InitialContext, javax.naming.Context" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <title>Edit Profile</title>
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
                text-decoration: none;
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

            textarea {
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 0.95rem;
                transition: all 0.3s;
                font-family: 'Segoe UI', sans-serif;
                width: 100%;
                resize: vertical;
                min-height: 100px;
            }

            textarea:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(51, 51, 51, 0.2);
                outline: none;
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
        <script>
            function confirmUpdate() {
                return confirm('Sure to update your profile?');
            }
        </script>
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
                    </a>
                    <a href="../secureStaff/ManagementProfile.jsp" class="header-icon" title="User Profile">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="../Logout.jsp" class="header-icon" title="Logout">
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

            <div class="form-container">
                <h2 class="form-title">EDIT PROFILE</h2>
                <form action="../UpdateProfileServlet" method="post" onsubmit="return confirmUpdate()">

                    <!-- Hidden field for role -->
                    <input type="hidden" name="role" value="<%= role %>">
                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">

                    <!-- Personal Info -->
                    <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="userId">User ID</label>
                            <input id="userId" type="text" value="<%= user.getUserId() %>" readonly />
                        </div>
                        <div class="input-field">
                            <label for="username">Username</label>
                            <input id="username" name="username" type="text" value="<%= user.getUsername() %>" readonly />
                        </div>
                        <div class="input-field">
                            <label for="ic">IC Number</label>
                            <input id="ic" name="ic" type="text" value="<%= user.getIc() %>" placeholder="Enter IC number" required />
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <h3 class="section-title"><i class="fas fa-phone"></i> Contact Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="email">Email Address</label>
                            <input id="email" name="email" type="email" value="<%= user.getEmail() %>" placeholder="Enter email" required />
                        </div>
                        <div class="input-field">
                            <label for="contactNumber">Contact Number</label>
                            <input id="contactNumber" name="contactNumber" type="text" value="<%= user.getContactNumber() != null ? user.getContactNumber() : "" %>" placeholder="Enter phone number" />
                        </div>
                    </div>

                    <!-- Security Info -->
                    <h3 class="section-title"><i class="fas fa-shield-alt"></i> Security Question</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="securityQuestion">Security Question</label>
                            <input id="securityQuestion" name="securityQuestion" type="text" value="<%= user.getSecurityQuestion() != null ? user.getSecurityQuestion() : "" %>" placeholder="Enter security question" required />
                        </div>
                        <div class="input-field">
                            <label for="securityAnswer">Security Answer</label>
                            <input id="securityAnswer" name="securityAnswer" type="text" value="<%= user.getSecurityAnswer() != null ? user.getSecurityAnswer() : "" %>" placeholder="Enter answer" required />
                        </div>
                    </div>

                    <!-- Role-specific fields -->
                    <% if ("staff".equals(role) && staffDetails != null) { 
                        String hiredDateStr = staffDetails != null ? new SimpleDateFormat("yyyy-MM-dd").format(staffDetails.getHiredDate()) : "";
                    %>
                    <h3 class="section-title"><i class="fas fa-calendar-alt"></i> Employment Information</h3>
                    <div class="input-group">
                        <div class="input-field">
                            <label for="hiredDate">Hired Date</label>
                            <input id="hiredDate" name="hiredDate" type="date" value="<%= hiredDateStr %>" readonly />
                        </div>
                        <div class="input-field">
                            <label for="salary">Salary</label>
                            <input id="salary" name="salary" type="text" value="<%= staffDetails.getSalary() != null ? staffDetails.getSalary() : "" %>" readonly />
                        </div>
                    </div>
                    <% } %>
                    <div class="btn-container">
                        <a href="ManagementProfile.jsp" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit">Update Profile</button>
                    </div>
                </form>
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