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
    
    
    // Get product list from request
    List<Product> productList = (List<Product>) request.getAttribute("productList");

    // If productList is null, redirect to the servlet
    if (productList == null) {
        response.sendRedirect(request.getContextPath() + "/ListProductServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Product</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/menu.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/managementMenu.css" />

        <style>
            /* same style as your ManageStaff.jsp */
            .user-table-container {
                margin-top: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                flex: 1;
                height: calc(100vh - 400px);
                display: flex;
                flex-direction: column;
                overflow: hidden;
                animation: fadeIn 1s ease-out
            }

            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
                border: 3px solid darkgrey;
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            thead {
                display: table;
                width: 100%;
                table-layout: fixed;
                background-color: var(--primary-color);
                color: white;
            }

            tbody {
                display: block;
                overflow-y: auto;
                max-height: 500px;
                width: 100%;
            }

            tr {
                display: table;
                width: 100%;
                table-layout: fixed;
            }

            th, td {
                padding: 10px;
                text-align: left;
                border-bottom: 3px dashed #ddd;
            }

            td {
                font-style: italic;
                font-weight: bold;
                font-size: 13px;
                overflow: hidden;
            }

            tbody tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            tbody tr:hover {
                background-color: whitesmoke;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
                justify-content: center;
            }

            .action-btn {
                width: 40px;
                height: 40px;
                border: none;
                border-radius: 50%;
                cursor: pointer;
                transition: all 0.2s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .action-btn i {
                font-size: 1.1rem;
            }

            .edit-btn {
                background: linear-gradient(135deg, #28a745, #218838);
                color: white;
            }

            .edit-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
            }

            .delete-btn {
                background: linear-gradient(135deg, #dc3545, #c82333);
                color: white;
            }

            .delete-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
            }

            .success-message, .error-message {
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
            }

            .success-message {
                background-color: #d4edda;
                color: #155724;
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
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
                        <li><a href="${pageContext.request.contextPath}/secureManager/AddStaff.jsp"><i class="fas fa-user-plus"></i> Add Staff</a></li>
                        <li><a href="${pageContext.request.contextPath}/secureManager/ManageStaff.jsp"><i class="fas fa-users-cog"></i> Manage Staff</a></li>
                    </ul>
                </li>

                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-users"></i>
                        <span>Customers</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="${pageContext.request.contextPath}/secureManager/AddCustomer.jsp"><i class="fas fa-user-plus"></i> Add Customer</a></li>
                        <li><a href="${pageContext.request.contextPath}/secureManager/ManageCustomer.jsp"><i class="fas fa-address-book"></i> Manage Customer</a></li>
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
                        <li><a href="${pageContext.request.contextPath}/secureStaff/AddCategory.jsp"><i class="fas fa-plus-circle"></i> Add Category</a></li>
                        <li><a href="${pageContext.request.contextPath}/secureStaff/ManageCategory.jsp"><i class="fas fa-tag"></i> Manage Categories</a></li>
                    </ul>
                </li>

                <li class="active">
                    <div class="menu-section-title">
                        <i class="fas fa-boxes"></i>
                        <span>Products</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="${pageContext.request.contextPath}/secureStaff/AddProduct.jsp"><i class="fas fa-plus-circle"></i> Add Product</a></li>
                        <li><a href="${pageContext.request.contextPath}/secureStaff/ManageProduct.jsp" class="active"><i class="fas fa-box-open"></i> Manage Products</a></li>
                    </ul>
                </li>

                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-star"></i>
                        <span>Customer Feedback</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="${pageContext.request.contextPath}/secureStaff/ManageRating.jsp"><i class="fas fa-comments"></i> Manage Reviews</a></li>
                    </ul>
                </li>

                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-percentage"></i>
                        <span>Promotion</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="${pageContext.request.contextPath}/secureStaff/UploadPromotion.jsp"><i class="fas fa-plus-circle"></i> Upload Promotion</a></li>
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
                        <li><a href="${pageContext.request.contextPath}/secureManager/selectMonth.jsp"><i class="fas fa-shopping-cart"></i> Monthly Report</a></li>
                        <li><a href="${pageContext.request.contextPath}/secureManager/ProductReport.jsp"><i class="fas fa-boxes"></i> Product Report</a></li>
                            <% } %>
                        <li><a href="${pageContext.request.contextPath}/secureStaff/OrderList.jsp"><i class="fas fa-database"></i> Customer Records</a></li>

                    </ul>
                </li>

            </ul>
        </div>

        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="${pageContext.request.contextPath}/Images/LOGO3.png" alt="Logo" style="height: 110px;">
                </a>
                <% if ("manager".equals(user.getRole())) { %>
                <div class="header-title">
                    <div class="company-name">${companyName}</div>
                    <div class="dashboard-title">Manager Dashboard</div>
                </div>
                <div class="header-icons">
                    <a href="${pageContext.request.contextPath}/secureManager/ManagerDashboard.jsp" class="header-icon" title="Dashboard">
                        <% } else if ("staff".equals(user.getRole())) { %>
                        <div class="header-title">
                            <div class="company-name">${companyName}</div>
                            <div class="dashboard-title">Staff Dashboard</div>
                        </div>
                        <div class="header-icons">

                            <a href="${pageContext.request.contextPath}/secureStaff/StaffDashboard.jsp" class="header-icon" title="Dashboard">
                                <% } %>

                                <i class="fas fa-home"></i>
                            </a>
                    </a>
                    <a href="${pageContext.request.contextPath}/secureStaff/ManagementProfile.jsp" class="header-icon" title="User Profile">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/Logout.jsp" class="header-icon" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>

            <div class="content">
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

                <h1 style="text-align: center; font-style: italic; font-weight: lighter; margin: 20px 0; color: var(--primary-color); font-size: 1.8rem;">PRODUCT LIST</h1>

                <div class="user-table-container">
                    <table>
                        <thead>
                            <tr>
                                <th style="text-align:center">ACTIONS</th>
                                <th>PRODUCT ID</th>
                                <th>PRODUCT NAME</th>
                                <th>DESCRIPTION</th>
                                <th style="padding-left:47px;">QUANTITY</th>
                                <th style="padding-left:58px;">PRICE</th>
                                <th>CATEGORY ID</th>
                                <th>CATEGORY NAME</th>
                                <th style="padding-left:47px;">IMAGE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (productList != null && !productList.isEmpty()) {
                                for (Product product : productList) {
                                    if (product != null && product.getCategoryId() != null) {
                            %>
                            <tr>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<%= request.getContextPath() %>/secureStaff/ViewProductServlet?productId=<%= product.getProductId() %>"
                                           class="action-btn edit-btn" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <% if ("manager".equals(user.getRole())) { %>
                                        <a href="DeleteProductServlet?id=<%= product.getProductId() %>" 
                                           class="action-btn delete-btn" title="Delete"
                                           onclick="return confirm('Sure to delete this product?');">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                        <% } %>
                                    </div>
                                </td>
                                <td style="padding-left:30px;"><%= product.getProductId() %></td>
                                <td><%= product.getProductName() %></td>
                                <td><%= product.getProductDescription() %></td>
                                <td style="text-align:center"><%= product.getQuantity() %></td>
                                <td style="text-align:center">RM <%= String.format("%.2f", product.getPrice()) %></td>
                                <td style="padding-left:47px;"><%= product.getCategoryId().getCategoryId() %></td>
                                <td style="padding-left:47px;"><%= product.getCategoryId().getCategoryName() %></td>
                                <td style="text-align: center;">
                                    <img src="<%= request.getContextPath() %>/GetProductImageServlet?productId=<%= product.getProductId() %>" 
                                         alt="Product Image" width="60" height="60" style="object-fit: cover; border-radius: 5px;" />
                                </td>

                            </tr>
                            <%
                                    }
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="8" style="text-align: center;">No products found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
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
