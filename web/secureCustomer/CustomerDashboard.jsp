<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Users" %>
<%
    // Get user object(customer) else return to login page
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("../LoginRoleSelection.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Customer Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../home.css" />
        <link rel="stylesheet" href="../customerMenu.css" />
        <style>
            .dashboard-container {
                max-width: 1200px;
                margin: 20px auto;
                padding: 20px;
            }

            .welcome-banner {
                background: linear-gradient(135deg, #4a4a4a, #7d7d7d);
                color: white;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                height:150px;
            }

            .welcome-banner h1 {
                margin-top: 0;
                font-size: 2rem;
            }

            .dashboard-cards {
                display: flex;
                gap: 20px;
                flex-wrap: wrap;
                justify-content: space-between;
            }

            .dashboard-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s;
                height: 250px;
                flex: 1 1 45%;
                min-width: 530px;
                max-width: 48%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-align: center;
            }

            .dashboard-card:hover {
                transform: translateY(-5px);
            }

            .dashboard-card i.card-icon {
                font-size: 3rem;
                color: #4a4a4a;
                margin-bottom: 15px;
            }

            .dashboard-card h3 {
                font-size: 1.4rem;
                margin-bottom: 10px;
                color: #333;
            }

            .dashboard-card p {
                font-size: 1rem;
                color: #666;
                margin-bottom: 15px;
            }

            .dashboard-card .btn-primary {
                display: inline-block;
                padding: 8px 16px;
                background: linear-gradient(135deg, #4a4a4a, #7d7d7d);
                color: white;
                border: none;
                border-radius: 25px;
                text-decoration: none;
                transition: all 0.3s;
            }

            .dashboard-card .btn-primary:hover {
                background: linear-gradient(135deg, #5a5a5a, #8d8d8d);
                transform: translateY(-2px);
            }


            .card-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .card-header i {
                font-size: 1.5rem;
                margin-right: 15px;
                color: #4a4a4a;
            }

            .card-header h3 {
                margin: 0;
                color: #4a4a4a;
            }

            .card-content {
                display: flex;
                align-items: center;
                height: 100%;
            }

            .card-icon-large {
                font-size: 3.5rem;
                color: #4a4a4a;
                margin-right: 25px;
                flex-shrink: 0;
            }

            .card-icon-large i {
                background: linear-gradient(135deg, #4a4a4a, #7d7d7d);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                font-size: 4rem;
                margin-right: 25px;
            }

            .card-text {
                flex-grow: 1;
            }

            .card-text h3 {
                font-size: 1.5rem;
                margin-bottom: 8px;
                color: #333;
                font-weight: 600;
            }

            .card-text p {
                color: #666;
                margin-bottom: 20px;
                font-size: 0.95rem;
            }

            .dashboard-card-link {
                text-decoration: none;
                color: inherit;
                display: block;
                flex: 1 1 45%;
                min-width: 300px;
                max-width: 48%;
            }

            .dashboard-card-link:hover .dashboard-card {
                transform: translateY(-5px);
            }

            .btn-view {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                background: linear-gradient(135deg, #4a4a4a, #7d7d7d);
                color: white;
                text-decoration: none;
                border-radius: 30px;
                transition: all 0.3s;
                font-weight: 500;
                border: none;
                cursor: pointer;
            }

            .btn-view:hover {
                background: linear-gradient(135deg, #5a5a5a, #8d8d8d);
                transform: translateX(5px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <!-- Navbar with Logo and Links (same as home.jsp) -->
        <div class="navbar">
            <div class="navbar-left">
                <img src="../Images/LOGO2.png" alt="Logo" />
                <a href="../secureCustomer/CustomerDashboard.jsp">Home</a>
                <a href="../Promotion.jsp">Promotion</a>
                <a href="../Product.jsp">Product</a>
                <a href="../about_contact.jsp">About Us</a>
                <a href="#">Rating</a>
            </div>

            <div class="header-title">
                <div class="company-name">${companyName}</div>
                <div class="dashboard-title">Customer Dashboard</div>
            </div>

            <div class="navbar-right">
                <div class="search-container">
                    <form action="../Product.jsp" method="get" onsubmit="return validateSearch()">
                        <input type="text" id="searchInput" name="search" placeholder="Search products id or name..." />
                    </form>
                </div>

                <!-- Cart Icon -->
                <a href="Cart.jsp" class="icon" title="My Cart">                
                    <i class="fas fa-shopping-cart"></i>
                </a>

                <!-- User Icon -->
                <a href="UserProfile.jsp" class="icon" title="My Profile">
                    <i class="fas fa-user"></i>
                </a>

                <!-- Logout Icon -->
                <a href="../Logout.jsp" class="icon" title="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>

        <main style="flex: 1;">
            <div class="dashboard-container">
                <!-- Welcome Banner -->
                <div class="welcome-banner">
                    <h1>Welcome back, <%= user.getUsername() %>!</h1>
                    <p>Enjoy your shopping experience.</p>
                </div>

                <div class="dashboard-cards">
                    <a href="Cart.jsp" class="dashboard-card-link">
                        <div class="dashboard-card">
                            <i class="fas fa-shopping-cart card-icon"></i>
                            <h3>My Cart</h3>
                            <p>Place an order with your cart</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/OrderHistoryServlet" class="dashboard-card-link">
                        <div class="dashboard-card">
                            <i class="fas fa-history card-icon"></i>
                            <h3>Order History</h3>
                            <p>Review your past purchases and receipts</p>
                        </div>
                    </a>
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