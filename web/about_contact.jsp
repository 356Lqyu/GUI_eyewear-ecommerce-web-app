<%@ page import="java.util.List , jakarta.persistence.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // about us page will be displayed in home (guests) and customer dashboard
    // so need to retrieve user object for session ( guests or customer)
    Users user = (Users) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "guest";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>About Us & Contact</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="home.css" />
        <link rel="stylesheet" href="customerMenu.css" />

        <style>
            /* About us */
            .about-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .about-header h2 {
                color: var(--primary-color);
                font-size: 2rem;
                margin-bottom: 10px;
                font-variant: small-caps;

            }

            .about-header h3 {
                color: var(--secondary-color);
                font-weight: normal;
                font-style: oblique;
            }

            .about-container {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                gap: 30px;
                margin: 0 auto;
            }

            .about-card {
                width: 100%;
                max-width: 800px;
                background-color: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                transition: transform 0.3s;
                padding: 30px;
                margin-bottom: 40px;
            }

            .about-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0,0,0,0.15);
            }

            .about-card h2 {
                color: var(--primary-color);
                margin-top: 0;
                border-bottom: 2px dashed var(--accent-color);
                padding-bottom: 10px;
                margin-bottom: 20px;
                font-variant: small-caps;
            }

            .about-card p {
                color: var(--dark-color);
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .contact-info {
                display: flex;
                flex-direction: column;
                gap: 15px;
                margin-top: 20px;
            }

            .contact-item {
                display: flex;
                align-items: center;
                gap: 10px;
                color: var(--dark-color);
            }

            .contact-item i {
                color: var(--primary-color);
                font-size: 1.2rem;
                width: 25px;
                text-align: center;
            }

            .about-container {
                display: flex;
                align-items: center;
                gap: 30px;
            }

            .about-text {
                flex: 1;
            }

            .about-logo {
                flex-shrink: 0;
                width: 250px;
                text-align: center;
            }

            .about-logo img {
                max-width: 100%;
                height: auto;
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
        <% if(role.equals("customer")) { %>
        <!-- Navbar for customer -->
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
        <!-- Navbar for guest -->
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

        <!-- About Us Content -->
        <main class="main-content">
            <div class="about-header">
                <h2>About Four Eyes Collective</h2>
                <h3>Our Vision for Your Vision</h3>
            </div>

            <div class="about-container">
                <div class="about-card">
                    <h2>Our Story</h2>
                    <div class="about-container">
                        <div class="about-text">
                            <p>
                                &nbsp;&nbsp;&nbsp;&nbsp;Welcome to <strong>${companyName}</strong> – a vision born from four girls who wear glasses and share a passion for everything eye-related.
                                We are more than just an online store; we are a lifestyle brand that celebrates clarity, confidence, and style.
                            </p>
                            <p>
                                &nbsp;&nbsp;&nbsp;&nbsp;At ${companyName}, we specialize in trendy and affordable <strong>eyeglasses, sunglasses, contact lenses</strong>, and other eye care accessories.
                                Our mission is to help you see better while looking great.
                                Whether you're reading your favorite book or catching rays on the beach, we've got the perfect pair for every occasion.
                            </p>
                            <p>
                                &nbsp;&nbsp;&nbsp;&nbsp;As four glasses girls, we understand how important it is to have options that feel both functional and fabulous — because your eyes deserve love too!
                            </p>
                        </div>
                        <div class="about-logo">
                            <img src="Images/LOGO3.png" alt="Four Eyes Collective Logo" style="color: grey;">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Us content -->
            <div class="about-header">
                <h2>Contact Us</h2>
                <h3>We'd love to hear from you</h3>
            </div>

            <div class="about-container">
                <div class="about-card">
                    <h2>Get In Touch</h2>
                    <p>Have questions about our products or need assistance with your order? Our team is here to help!</p>

                    <div class="contact-info">
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <span>012-3456789</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <a href="mailto:${companyEmail}">${companyEmail}</a>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>No 1220, Jalan Genting Kelang, Setapak, 53300 Kuala Lumpur</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-clock"></i>
                            <span>Monday - Friday: 9am - 4pm</span>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>
    </body>
</html>