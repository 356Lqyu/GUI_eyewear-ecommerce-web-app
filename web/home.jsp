<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.ServletContext , model.*, java.util.*" %>
<%
    Users user = (Users) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "guest";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Home - ${companyName}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <script src="scripts/searchBar.js"></script>
        <link rel="stylesheet" href="home.css" />
        <style>
            /* Show featured product */
            #productList {
                display: flex;
                flex-wrap: wrap;
                padding: 20px;
                gap: 20px;
                justify-content: center;
            }

            .product {
                border: 1px solid #ddd;
                padding: 20px;
                width: 200px;
                border-radius: 8px;
                background: white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                transition: transform 0.3s;
            }

            .product:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            /* Hello Banner */
            .hello-banner {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: white;
                padding: 80px 20px;
                text-align: center;
                animation: fadeIn 1s ease-out;
            }

            .hello-banner h1 {
                font-size: 2.5rem;
                margin-bottom: 20px;
            }

            .hello-banner p {
                font-size: 1.2rem;
                max-width: 600px;
                margin: 0 auto 30px;
            }

            .btn-go {
                display: inline-block;
                background-color: white;
                color: var(--primary-color);
                padding: 12px 30px;
                text-decoration: none;
                border-radius: 30px;
                font-weight: bold;
                transition: all 0.3s;
            }

            .btn-go:hover {
                background-color: var(--accent-color);
                color: white;
                transform: translateY(-2px);
            }

            .section {
                padding: 50px 20px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .section h2{
                font-variant: small-caps;
            }

            .section-title {
                text-align: center;
                margin-bottom: 30px;
                color: var(--primary-color);
            }

            .promotion-section {
                background-color: var(--light-color);
                padding: 40px 20px;
                text-align: center;
                border-top: 1px solid #ddd;
                border-bottom: 1px solid #ddd;
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
        <!-- Navbar with Logo and Links -->
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

            <!-- Search bar -->
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




                <!-- Login Icon -->
                <a href="LoginRoleSelection.html" class="icon" title="User Login">
                    <i class="fas fa-user"></i>
                </a>


            </div>
        </div>

        <!-- Hello Banner -->
        <div class="hello-banner">
            <!-- Global parameter - Company name -->
            <h1>Welcome to ${companyName}</h1>
            <p>
                Stylish and affordable eyewear for every moment in life. Shop glasses, sunglasses, contact lenses and more!
            </p>
            <br>
            <a href="products.jsp" class="btn-go">Shop Now</a>
        </div>

        <!-- Featured Products Section -->
        <section class="section">
            <h2 class="section-title">Featured Products</h2>
            <div id="productList">
                <div id="productList">
                    <div class="product" data-name="SunGlasses" data-id="P001">
                        <i class="fas fa-sun" style="font-size: 2rem; color: #888888; margin-bottom: 15px;"></i>
                        <h3>Sunglasses</h3>
                        <p>Premium UV protection with style</p>
                        <span>P001</span>
                    </div>
                    <div class="product" data-name="Glasses" data-id="P002">
                        <i class="fas fa-glasses" style="font-size: 2rem; color: #888888; margin-bottom: 15px;"></i>
                        <h3>Glasses</h3>
                        <p>Crystal clear vision with comfort</p>
                        <span>P002</span>
                    </div>
                    <div class="product" data-name="Contact Lenses" data-id="P003">
                        <i class="fas fa-eye" style="font-size: 2rem; color: #888888; margin-bottom: 15px;"></i>
                        <h3>Contact Lenses</h3>
                        <p>Invisible perfection for your eyes</p>
                        <span>P003</span>
                    </div>
                    <div class="product" data-name="Blue Light Glasses" data-id="P004">
                        <i class="fas fa-laptop" style="font-size: 2rem; color: #888888; margin-bottom: 15px;"></i>
                        <h3>Blue Light Glasses</h3>
                        <p>Digital eye protection for modern life</p>
                        <span>P004</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Promotions Banner -->
        <section class="promotion-section">
            <h2 style="font-variant: small-caps;">🎉 Special Offer 🎉</h2>
            <p>Enjoy <strong>10% off</strong> on your birthday month! 🎂</p>
            <p>Free shipping for orders over RM1000!</p>
            <div style="margin-top: 30px;">
                <a href="Promotion.jsp" class="btn-go">View All Promotions</a>
            </div>
        </section>

        <!-- About Short Section -->
        <section class="section">
            <h2 class="section-title">About ${companyName}</h2>
            <p style="text-align: center; max-width: 800px; margin: 0 auto;">
                We're four girls who wear glasses and created a brand to bring style and clarity to your vision. 
                Whether it's reading, driving, or chilling under the sun, we have the perfect eye gear for you!
            </p>
        </section>

        <!-- Footer -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>
    </body>
</html>