<%@ page import="model.*,java.util.List, jakarta.persistence.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // promotion page will be displayed in home (guests) and customer dashboard
    // so need to retrieve user object for session ( guests or customer)
    Users user = (Users) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "guest";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Current Promotions</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="home.css" />
        <link rel="stylesheet" href="customerMenu.css" />

        <style>
            /* Promotion section design */
            .no-promotions {
                text-align: center;
                padding: 50px;
                color: var(--secondary-color);
                font-size: 1.2rem;
                min-height: 300px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }

            .promo-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .promo-header h2 {
                color: var(--primary-color);
                font-size: 2rem;
                margin-bottom: 10px;
                font-variant: small-caps;
            }

            .promo-header h3 {
                color: var(--secondary-color);
                font-weight: normal;
            }

            .promo-container-wrapper {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                gap: 20px;
                margin: 20px auto;
            }

            .promo-container {
                width: 30%;
                max-width: 300px;
                background-color: #f5efed;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px antiquewhite;
                text-align: center;
            }

            .promo-image {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
            }

            .promo-text {
                font-size: 17px;
                margin-top: 15px;
                color: black;
            }

            .promo-container:hover .promo-image {
                transform: scale(1.01);
            }

            .btn-go {
                display: block;
                margin: 20px auto;
                padding: 10px 25px;
                background-color: var(--primary-color);
                color: white;
                text-decoration: none;
                border-radius: 25px;
                text-align: center;
                transition: background-color 0.3s;
            }

            .btn-go:hover {
                background-color: var(--secondary-color);
            }
        </style>
        <script>
            function validateSearch() {
                const searchInput = document.getElementById('searchInput');
                if (searchInput.value.trim() === '') {
                    alert('Please enter product ID or name to search');
                    return false;
                }
                return true;
            }
            document.getElementById('searchInput').addEventListener('input', function () {
            });
        </script>
    </head>
    <body>
        <div class="content-wrapper">
            <!-- Navbar for customer dashboard(if customer login) -->
            <% if(role.equals("customer")) { %>
            <div class="navbar">
                <div class="navbar-left">
                    <img src="Images/LOGO2.png" alt="Logo" />
                    <a href="secureCustomer/CustomerDashboard.jsp">Home</a>
                    <a href="Promotion.jsp">Promotion</a>
                    <a href="Product.jsp">Product</a>
                    <a href="about_contact.jsp">About Us</a>
                    <a href="#">Rating</a>
                </div>

                <div class="header-title">
                    <div class="company-name">${companyName}</div>
                    <div class="dashboard-title">Customer Dashboard</div>
                </div>

                <div class="navbar-right">
                    <!-- Search bar -->
                    <div class="search-container">
                        <form action="Product.jsp" method="get" onsubmit="return validateSearch()">
                            <input type="text" id="searchInput" name="search" placeholder="Search products id or name..." />
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
                        <form action="Product.jsp" method="get" onsubmit="return validateSearch()">
                            <input type="text" id="searchInput" name="search" placeholder="Search products id or name..." />
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

            <!-- Promotion section -->
            <main class="main-content">
                <div class="promo-header">
                    <h2>Special Promotions</h2>
                    <h3>Exclusive Offers Just For You</h3>
                </div>

                <div class="promo-container-wrapper">
                    <!-- query promotions from the database -->
                    <%
                        EntityManagerFactory emf = null;
                        EntityManager em = null;
                        try {
                            emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
                            em = emf.createEntityManager();

                            List<Promotion> promos = em.createQuery("SELECT p FROM Promotion p ORDER BY p.promoId", Promotion.class)
                                                      .getResultList();
                                                      
                            // If not promotion exists
                            if (promos.isEmpty()) {
                    %>
                    <div class="no-promotions">
                        <i class="fas fa-tag" style="font-size: 3rem; margin-bottom: 15px;"></i>
                        <p>No promotions available right now.</p>
                        <p>Check back soon for exciting offers!</p>
                    </div>
                    <%
                            } else {
                                // If promotion exists (retrieve promotion details)
                                for (Promotion promo : promos) {
                                    if (promo.getImageName() != null && !promo.getImageName().isEmpty()) {
                    %>
                    <div class="promo-container">
                        <img src="Promotion/<%= promo.getImageName() %>?ts=<%= System.currentTimeMillis() %>" class="promo-image"/>
                        <div class="promo-text"><%= promo.getPromoText().replaceAll("\n", "<br>") %></div>
                        <a href="Product.jsp" class="btn-go">Shop Now</a>
                    </div>
                    <%
                                    }
                                }
                            }
                        } catch (Exception e) {
                    %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p>Error loading promotions: <%= e.getMessage() %></p>
                    </div>
                    <%
                        } finally {
                            if (em != null) em.close();
                            if (emf != null) emf.close();
                        }
                    %>
                </div>
            </main>
        </div>
        <!-- Footer -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>
    </body>
</html>