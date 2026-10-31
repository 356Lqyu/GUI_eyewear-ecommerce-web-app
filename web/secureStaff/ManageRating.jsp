<%@ page import="javax.naming.Context, javax.naming.InitialContext" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, jakarta.persistence.*, model.*"%>
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
    
    // Set no-cache headers
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Manager - Product Ratings</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/menu.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/managementMenu.css" />

        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f5f5f5;
            }

            .container {
                max-width: 1200px;
                margin: 20px auto;
                padding: 20px;
                background-color: white;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 5px;
            }

            h1 {
                color: #333;
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
            }

            .ratings-table-container {
                margin-top: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                height: 280px; 
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .ratings-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
                border: 3px solid darkgrey;
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .ratings-table thead {
                display: table;
                width: 100%;
                table-layout: fixed;
                background-color: var(--primary-color);
                color: white;
            }

            .ratings-table tbody {
                display: block;
                overflow-y: auto;
                width: 100%;
                flex: 1;
            }

            .ratings-table tr {
                display: table;
                width: 100%;
                table-layout: fixed;
            }

            .ratings-table th, .ratings-table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }


            .ratings-table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #495057;
            }

            .ratings-table tr:hover {
                background-color: #f8f9fa;
            }




            .star-filled {
                color: #ffc107;
            }

            .star-empty {
                color: #e9ecef;
            }

            .rating-value {
                font-weight: bold;
                color: #333;
            }

            .no-ratings {
                text-align: center;
                padding: 20px;
                color: #6c757d;
            }

            .search-filter {
                margin-bottom: 20px;
                display: flex;
                gap: 10px;
            }

            .search-filter input, .search-filter select {
                padding: 8px 12px;
                border: 1px solid #ced4da;
                border-radius: 4px;
            }

            .search-filter button {
                padding: 8px 15px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .search-filter button:hover {
                background-color: #0069d9;
            }

            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
                gap: 5px;
            }

            .pagination a, .pagination span {
                padding: 8px 12px;
                border: 1px solid #dee2e6;
                text-decoration: none;
                color: #007bff;
            }

            .pagination a:hover {
                background-color: #e9ecef;
            }

            .pagination .current {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .delete-btn {
                background: linear-gradient(135deg, #dc3545, #c82333);
                color: white;
            }

            .delete-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
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

            .alert {
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid transparent;
                border-radius: 4px;
            }

            .alert-success {
                color: #3c763d;
                background-color: #dff0d8;
                border-color: #d6e9c6;
            }

            .alert-danger {
                color: #a94442;
                background-color: #f2dede;
                border-color: #ebccd1;
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

                <li>
                    <div class="menu-section-title">
                        <i class="fas fa-boxes"></i>
                        <span>Products</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="${pageContext.request.contextPath}/secureStaff/AddProduct.jsp"><i class="fas fa-plus-circle"></i> Add Product</a></li>
                        <li><a href="${pageContext.request.contextPath}/secureStaff/ManageProduct.jsp"><i class="fas fa-box-open"></i> Manage Products</a></li>
                    </ul>
                </li>

                <li class="active">
                    <div class="menu-section-title">
                        <i class="fas fa-star"></i>
                        <span>Customer Feedback</span>
                    </div>
                    <ul class="sidebar-submenu">
                        <li><a href="${pageContext.request.contextPath}/secureStaff/ManageRating.jsp" class="active"><i class="fas fa-comments"></i> Manage Reviews</a></li>
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

            <%-- Display success/error messages --%>
            <% if (session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success" style="padding: 15px; margin-bottom: 20px; border: 1px solid #d6e9c6; border-radius: 4px; color: #3c763d; background-color: #dff0d8;">
                <i class="fas fa-check-circle"></i> <%= session.getAttribute("successMessage") %>
                <% session.removeAttribute("successMessage"); %>
            </div>
            <% } %>

            <% if (session.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" style="padding: 15px; margin-bottom: 20px; border: 1px solid #ebccd1; border-radius: 4px; color: #a94442; background-color: #f2dede;">
                <i class="fas fa-exclamation-circle"></i> <%= session.getAttribute("errorMessage") %>
                <% session.removeAttribute("errorMessage"); %>
            </div>
            <% } %>
            <h1 style="text-align: center; font-style: italic; font-weight: lighter; margin: 20px 0; color: var(--primary-color); font-size: 1.8rem;">Product Ratings Management</h1>
            <div class="container">
                <div class="search-filter">
                    <form method="get" action="ManageRating.jsp">
                        <input type="text" name="search" placeholder="Search products or reviews..."
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <select name="minRating">
                            <option value="">All Ratings</option>
                            <option value="5" <%= "5".equals(request.getParameter("minRating")) ? "selected" : "" %>>5 Stars</option>
                            <option value="4" <%= "4".equals(request.getParameter("minRating")) ? "selected" : "" %>>4+ Stars</option>
                            <option value="3" <%= "3".equals(request.getParameter("minRating")) ? "selected" : "" %>>3+ Stars</option>
                            <option value="2" <%= "2".equals(request.getParameter("minRating")) ? "selected" : "" %>>2+ Stars</option>
                            <option value="1" <%= "1".equals(request.getParameter("minRating")) ? "selected" : "" %>>1+ Stars</option>
                        </select>
                        <button type="submit"><i class="fas fa-search"></i> Filter</button>
                        <!-- Add hidden timestamp to prevent caching -->
                        <input type="hidden" name="ts" value="<%= System.currentTimeMillis() %>">
                    </form>
                </div>

                <%
                    EntityManagerFactory emf = null;
                    EntityManager em = null;

                    try {
                        // Create a new EntityManagerFactory for each request
                        emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
                        em = emf.createEntityManager();
            
                        // Clear entity manager to ensure fresh data
                        em.clear();
            
                        // Try to evict all entities from cache if cache exists
                        try {
                            if (emf.getCache() != null) {
                                emf.getCache().evictAll();
                            }
                        } catch (Exception ex) {
                            // Just log and continue if cache eviction fails
                            System.out.println("Cache eviction warning: " + ex.getMessage());
                        }

                        String searchTerm = request.getParameter("search");
                        String minRating = request.getParameter("minRating");

                        String queryStr = "SELECT r FROM Rating r JOIN FETCH r.product p JOIN FETCH r.user u";
                        String whereClause = "";

                        if (searchTerm != null && !searchTerm.isEmpty()) {
                            whereClause += " WHERE (LOWER(p.productName) LIKE LOWER(:searchTerm) OR LOWER(r.comment) LIKE LOWER(:searchTerm))";
                        }

                        if (minRating != null && !minRating.isEmpty()) {
                            if (!whereClause.isEmpty()) {
                                whereClause += " AND ";
                            } else {
                                whereClause += " WHERE ";
                            }
                            whereClause += "r.ratingValue >= :minRating";
                        }

                        queryStr += whereClause + " ORDER BY r.ratingDate DESC";

                        TypedQuery<Rating> ratingQuery = em.createQuery(queryStr, Rating.class);

                        if (searchTerm != null && !searchTerm.isEmpty()) {
                            ratingQuery.setParameter("searchTerm", "%" + searchTerm + "%");
                        }
                        if (minRating != null && !minRating.isEmpty()) {
                            ratingQuery.setParameter("minRating", Integer.parseInt(minRating));
                        }

                        int currentPage = 1;
                        int recordsPerPage = 10;
                        if (request.getParameter("page") != null) {
                            currentPage = Integer.parseInt(request.getParameter("page"));
                        }

                        // Add JPA hints to ensure fresh data
                        try {
                            ratingQuery.setHint("jakarta.persistence.cache.storeMode", "REFRESH");
                        } catch (Exception ex) {
                            // Just log and continue if hint setting fails
                            System.out.println("Warning setting query hint: " + ex.getMessage());
                        }
            
                        List<Rating> ratings = ratingQuery
                                .setFirstResult((currentPage - 1) * recordsPerPage)
                                .setMaxResults(recordsPerPage)
                                .getResultList();

                        String countQueryStr = "SELECT COUNT(r) FROM Rating r JOIN r.product p";
                        countQueryStr += whereClause;
                        TypedQuery<Long> countQuery = em.createQuery(countQueryStr, Long.class);

                        if (searchTerm != null && !searchTerm.isEmpty()) {
                            countQuery.setParameter("searchTerm", "%" + searchTerm + "%");
                        }
                        if (minRating != null && !minRating.isEmpty()) {
                            countQuery.setParameter("minRating", Integer.parseInt(minRating));
                        }

                        // Add hint for count query too
                        try {
                            countQuery.setHint("jakarta.persistence.cache.storeMode", "REFRESH");
                        } catch (Exception ex) {
                            // Just log and continue if hint setting fails
                            System.out.println("Warning setting count query hint: " + ex.getMessage());
                        }
            
                        long noOfRecords = countQuery.getSingleResult();
                        int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

                        if (ratings.isEmpty()) {
                %>
                <div class="no-ratings">
                    <i class="far fa-frown" style="font-size: 2em;"></i>
                    <p>No ratings found matching your criteria.</p>
                </div>
                <%
                        } else {
                %>
                <div class="ratings-table-container">

                    <table class="ratings-table">
                        <thead>
                            <tr>
                                <th>Actions</th>
                                <th>Rating ID</th>
                                <th>Product</th>
                                <th>Rating</th>
                                <th>Comment</th>
                                <th>User</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Rating rating : ratings) { %>
                            <tr>
                                <td>
                                    <a href="DeleteRatingServlet?ratingId=<%= rating.getRatingId() %>&ts=<%= System.currentTimeMillis() %>" 
                                       class="action-btn delete-btn" onclick="return confirm('Are you sure you want to delete this rating?');">
                                        <i class="fas fa-trash-alt delete-btn"></i>
                                    </a>
                                </td>
                                <td><%= rating.getRatingId() %></td>
                                <td>
                                    <a href="productDetails.jsp?id=<%= rating.getProduct().getProductId() %>">
                                        <%= rating.getProduct().getProductName() %>
                                    </a>
                                </td>
                                <td>
                                    <div class="rating-value">
                                        <% int stars = rating.getRatingValue(); %>
                                        <% for (int i = 1; i <= 5; i++) { %>
                                        <i class="fas fa-star <%= i <= stars ? "star-filled" : "star-empty" %>"></i>
                                        <% } %>
                                        (<%= stars %>/5)
                                    </div>
                                </td>
                                <td><%= rating.getComment() != null ? rating.getComment() : "No Comment" %></td>
                                <td><%= rating.getUser().getUsername() %></td>
                                <td><%= rating.getRatingDate() %></td>

                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="ManageRating.jsp?page=<%= currentPage - 1 %><%= searchTerm != null ? "&search=" + searchTerm : "" %><%= minRating != null ? "&minRating=" + minRating : "" %>&ts=<%= System.currentTimeMillis() %>">&laquo; Previous</a>
                    <% } %>

                    <% for (int i = 1; i <= noOfPages; i++) { %>
                    <% if (i == currentPage) { %>
                    <span class="current"><%= i %></span>
                    <% } else { %>
                    <a href="ManageRating.jsp?page=<%= i %><%= searchTerm != null ? "&search=" + searchTerm : "" %><%= minRating != null ? "&minRating=" + minRating : "" %>&ts=<%= System.currentTimeMillis() %>"><%= i %></a>
                    <% } %>
                    <% } %>

                    <% if (currentPage < noOfPages) { %>
                    <a href="ManageRating.jsp?page=<%= currentPage + 1 %><%= searchTerm != null ? "&search=" + searchTerm : "" %><%= minRating != null ? "&minRating=" + minRating : "" %>&ts=<%= System.currentTimeMillis() %>">Next &raquo;</a>
                    <% } %>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <div class="alert alert-danger">
                    An error occurred while loading ratings: <%= e.getMessage() %>
                </div>
                <%
                    } finally {
                        if (em != null) {
                            try {
                                em.close();
                            } catch (Exception ex) {
                                // Handle potential errors when closing the EntityManager
                                System.out.println("Error closing EntityManager: " + ex.getMessage());
                            }
                        }
                        if (emf != null) {
                            try {
                                emf.close();
                            } catch (Exception ex) {
                                // Handle potential errors when closing the EntityManagerFactory
                                System.out.println("Error closing EntityManagerFactory: " + ex.getMessage());
                            }
                        }
                    }
                %>

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