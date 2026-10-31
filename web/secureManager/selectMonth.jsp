<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.*, controller.* , jakarta.persistence.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Select Month for Report</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../menu.css" />
        <link rel="stylesheet" href="../form.css" />
        <link rel="stylesheet" href="../managementMenu.css" />
        <style>
            /* Additional styles for footer positioning */
            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding-bottom: 60px;
            }

            .footer {
                color: black;
                text-align: center;
                padding: 15px 0;
                margin-top: auto;
                width: calc(100% - 240px);
                margin-left: 240px;
            }

            .form-container {
                margin-bottom: 30px;
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

                <li class="active">
                    <div class="menu-section-title">
                        <i class="fas fa-chart-pie"></i>
                        <span>Reports</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="../secureManager/selectMonth.jsp" class="active"><i class="fas fa-shopping-cart"></i> Monthly Report</a></li>
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

            <!-- Month Selection Form -->
            <div class="form-container">
                <h2 class="form-title">MONTHLY REPORT</h2>
                <form action="../MonthlyReportServlet" method="get">
                    <h3 class="section-title"><i class="fas fa-calendar-alt"></i> Select Month</h3>

                    <div class="input-group">
                        <div class="input-field">
                            <label for="month">Choose Month:</label>
                            <input type="month" id="month" name="month" required>
                        </div>
                    </div>

                    <div class="btn-container">
                        <button type="submit" class="btn-submit">Generate Report</button>
                    </div>
                </form>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            ${copyright}
        </footer>
        
    </body>
</html>