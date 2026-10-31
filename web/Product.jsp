<%@ page import="jakarta.persistence.*, model.*, java.util.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Users user = (Users) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "guest";
    String searchTerm = request.getParameter("search");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Four Eyes Collective - Products</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="home.css" />
        <link rel="stylesheet" href="Product.css" />
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                width: 100%;
                overflow: hidden;
            }

            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: var(--light-color);
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
        </style>
    </head>
    <body>
        <% if(role.equals("customer")) { %>
        <div class="navbar">
            <div class="navbar-left">
                <img src="Images/LOGO2.png" alt="Logo" />
                <a href="secureCustomer/CustomerDashboard.jsp">Home</a>
                <a href="Promotion.jsp">Promotion</a>
                <a href="Product.jsp">Product</a>
                <a href="about_contact.jsp">About Us</a>
                <a href="rating.jsp">Rating</a>
            </div>

            <div class="header-title">
                <div class="company-name">${companyName}</div>
                <div class="dashboard-title">Customer Dashboard</div>
            </div>

            <div class="navbar-right">
                <!-- Search bar -->
                <div class="search-container">
                    <form action="Product.jsp" method="get">
                        <input type="text" name="search" value="<%= searchTerm != null ? searchTerm : "" %>" placeholder="Search products id or name..." />
                    </form>
                </div>

                <!-- Cart Icon -->
                <a href="secureCustomer/Cart.jsp" class="icon" title="Cart">                
                    <i class="fas fa-shopping-cart"></i>
                </a>

                <!-- User profile icon -->
                <a href="secureCustomer/UserProfile.jsp" class="icon" title="User Profile">
                    <i class="fas fa-user"></i>
                </a>

                <!-- Logout icon -->
                <a href="Logout.jsp" class="icon" title="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>

        <% } else { %>
        <!-- Navbar for guest (home) -->
        <div class="navbar">
            <div class="navbar-left">
                <img src="Images/LOGO2.png" alt="Logo" />
                <a href="home.jsp">Home</a>
                <a href="Promotion.jsp">Promotion</a>
                <a href="Product.jsp">Product</a>
                <a href="about_contact.jsp">About Us</a>
                <a href="#">Rating</a>
            </div>

            <div class="header-title">
                <div class="company-name">${companyName}</div>
            </div>

            <div class="navbar-right">
                <div class="search-container">
                    <form action="Product.jsp" method="get">
                        <input type="text" name="search" value="<%= searchTerm != null ? searchTerm : "" %>" placeholder="Search products..." />
                    </form>
                </div>

                <!-- Cart Icon -->
                <a href="secureCustomer/Cart.jsp" class="icon" title="Cart">                
                    <i class="fas fa-shopping-cart"></i>
                </a>

                <!-- User Icon -->
                <a href="LoginRoleSelection.html" class="icon" title="User Login">
                    <i class="fas fa-user"></i>
                </a>
            </div>
        </div>
        <% } %>

        <!-- Category side bar -->
        <div class="container">
            <aside class="sidebar" id="sidebar">
                <h2>Categories</h2>
                <ul>
                    <li><a href="Product.jsp" class="<%= request.getParameter("category") == null ? "active" : "" %>">All Products</a></li>
                        <%
                            EntityManagerFactory emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
                            EntityManager em = emf.createEntityManager();
                    
                            List<Category> categoryList = em.createQuery("SELECT c FROM Category c", Category.class).getResultList();
                            for (Category cat : categoryList) {
                                String activeClass = request.getParameter("category") != null && 
                                                    request.getParameter("category").equals(cat.getCategoryId()) ? "active" : "";
                        %>
                    <li><a href="Product.jsp?category=<%= cat.getCategoryId() %>" class="<%= activeClass %>">
                            <i class="fas fa-<%= cat.getCategoryName().toLowerCase().contains("sun") ? "sun" : 
                                              cat.getCategoryName().toLowerCase().contains("contact") ? "eye" : 
                                              "glasses" %>"></i> 
                            <%= cat.getCategoryName() %>
                        </a></li>
                        <%
                            }
                        %>
                </ul>
            </aside>

            <!-- Search section -->
            <main class="main-content" id="mainContent">
                <h1 style="color: var(--primary-color); font-variant: small-caps; margin-bottom: 20px;">
                    <% 
                        if (searchTerm != null && !searchTerm.isEmpty()) { 
                    %>
                    Search Results for "<%= searchTerm %>"
                    <% 
                        } else if (request.getParameter("category") != null) { 
                            Category currentCat = em.find(Category.class, request.getParameter("category"));
                    %>
                    <%= currentCat.getCategoryName() %>
                    <% } else { %>
                    All Products
                    <% } %>
                </h1>

                <div class="product-grid">
                    <%
                        String selectedCategory = request.getParameter("category");
                        List<Product> productList;

                        if (searchTerm != null && !searchTerm.isEmpty()) {
                            productList = em.createQuery("SELECT p FROM Product p WHERE LOWER(p.productName) LIKE LOWER(:search) OR LOWER(p.productId) LIKE LOWER(:search)", Product.class)
                                            .setParameter("search", "%" + searchTerm + "%")
                                            .getResultList();
                        } else if (selectedCategory != null && !selectedCategory.isEmpty()) {
                            productList = em.createQuery("SELECT p FROM Product p WHERE p.categoryId.categoryId = :categoryId", Product.class)
                                            .setParameter("categoryId", selectedCategory)
                                            .getResultList();
                        } else {
                            productList = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
                        }

                        if (productList.isEmpty()) {
                            out.println("<div style='grid-column: 1/-1; text-align: center; padding: 50px;'>");
                            out.println("<i class='fas fa-glasses' style='font-size: 3rem; color: var(--accent-color); margin-bottom: 20px;'></i>");
                            if (searchTerm != null && !searchTerm.isEmpty()) {
                                out.println("<h3>No products found for \"" + searchTerm + "\"</h3>");
                            } else {
                                out.println("<h3>No products found in this category</h3>");
                            }
                            out.println("</div>");
                        }

                        for (Product p : productList) {
                            Category productCat = em.find(Category.class, p.getCategoryId().getCategoryId());
                    %>
                    
                    <!-- Product section -->
                    <div class="product-card">
                        <span class="category-tag"><%= productCat.getCategoryName() %></span>
                        <a href="ProductDetails.jsp?id=<%= p.getProductId() %>">
                            <div class="product-image-wrapper">
                                <img src="<%= request.getContextPath() %>/GetProductDetails?id=<%= p.getProductId() %>" class="product-image" alt="<%= p.getProductName() %>"/>
                            </div>
                            <div class="product-info">
                                <div>
                                    <div class="product-name">
                                        <%= p.getProductName() %>
                                    </div>
                                    <div class="product-price">RM<%= String.format("%.2f", p.getPrice()) %></div>
                                </div>
                            </div>
                        </a>
                        <div style="padding: 0 20px 20px 20px; color: white; width: 300px; height: 70px;">
                            <% if (role.equals("customer")) { %>
                            <a href="secureCustomer/AddToCart.jsp?id=<%= p.getProductId() %>" class="add-btn">
                                <i class="fas fa-cart-plus"></i> Add to Cart
                            </a>
                            <% } else { %>
                            <a href="LoginRequest.jsp" class="add-btn">
                                <i class="fas fa-cart-plus"></i> Add To Cart
                            </a>
                            <% } %>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </main>
        </div>

        <%
            em.close();
            emf.close();
        %>

        <!-- Footer -->
        <footer style="padding: 15px;
                padding-left: 100px;
                text-align: center;
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;">
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>

        <script>
            // Scroll to search results if coming from search
            document.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                const searchTerm = urlParams.get('search');

                if (searchTerm) {
                    const mainContent = document.getElementById('mainContent');
                    if (mainContent) {
                        mainContent.scrollIntoView({behavior: 'smooth'});
                    }
                }
            });
        </script>
    </body>
</html>