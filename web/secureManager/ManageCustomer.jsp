<%@ page import="model.*, java.util.List, controller.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get customer list from request 
    List<Users> customerList = (List<Users>) request.getAttribute("customerList");
    
    // If customerList is null , redirect to the servlet( to fetch customer list from database)
    if (customerList == null) {
    response.sendRedirect("ListUserServlet?type=customer");
    return;
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Customer</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="../menu.css" />
        <link rel="stylesheet" href="../managementMenu.css" />

        <style>
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
                width: 100%;
                flex: 1;
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
                box-sizing: border-box;
            }

            td{
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



            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
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
                    <a href="../Logout.jsp" class="header-icon" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>

            <div class="content">
                <!-- Show success and error message -->
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

                <!-- Customer List -->
                <h1 style="text-align: center;
                    font-style: italic;
                    font-weight: lighter;
                    margin: 20px 0;
                    color: var(--primary-color);
                    font-size: 1.8rem;">CUSTOMER LIST</h1>

                <div class="user-table-container">
                    <table>
                        <thead>
                            <tr>
                                <th style="text-align:center">ACTIONS</th>
                                <th>USER ID</th>
                                <th>USERNAME</th>
                                <th>PASSWORD</th>
                                <th>IC</th>
                                <th>EMAIL</th>
                                <th>CONTACT NUMBER</th>
                                <th>SECURITY QUESTION</th>
                                <th>SECURITY ANSWER</th>

                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (customerList != null && !customerList.isEmpty()) {
                                for (Users customer : customerList) { 
                                    if (customer != null && customer.getCustomer() != null) {
                            %>
                            <tr>
                                <td>
                                    <div class="action-buttons">
                                        <!-- Go to servlet to show specific user's details for modification-->
                                        <a href="<%= request.getContextPath() %>/secureManager/ViewCustomerServlet?userId=<%= customer.getUserId() %>"
                                           class="action-btn edit-btn" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <!-- show confirm message if want to delete customer -->
                                        <a href="DeleteUserServlet?id=<%= customer.getUserId() %>&type=customer" 
                                           class="action-btn delete-btn" title="Delete"
                                           onclick="return confirm('Sure to delete this customer?');">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </div>
                                </td>
                                <td style="padding-left:18px"><%= customer.getUserId() %></td>
                                <td><%= customer.getUsername() %></td>
                                <td><%= customer.getPassword() %></td>
                                <td><%= customer.getIc() %></td>
                                <td><%= customer.getEmail() %></td>
                                <td><%= customer.getContactNumber() %></td>
                                <td><%= customer.getSecurityQuestion() %></td>
                                <td><%= customer.getSecurityAnswer()%></td>


                            </tr>
                            <% 
                                    }
                                }
                            } else {
                            %>

                            <tr>
                                <td colspan="11" style="text-align: center;">No customers found</td>
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