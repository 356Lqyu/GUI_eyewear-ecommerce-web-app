<%@ page import="model.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Users user = (Users) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect("../CustomerLogin.html");
        return;
    }
    
    // To get customer details 
    Customer customerDetails = user.getCustomer();
 
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="../home.css" />
        <link rel="stylesheet" href="../form.css" />
        <link rel="stylesheet" href="../customerMenu.css" />

        <style>
            body {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            
            .profile-section {
                background: linear-gradient(to bottom right, #fff, #f5f5f5);
                padding: 25px;
                border-radius: 15px;
                margin: 25px auto;
                max-width: 1000px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.06);
                position: relative;
                
            }

            .profile-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: linear-gradient(to right, #4a4a4a, #7d7d7d);
            }

            .profile-section h1 {
                color: #333;
                margin-top: 5px;
                font-size: 1.8rem;
                border-bottom: none;
                padding-bottom: 10px;
                position: relative;
                display: inline-block;
                font-weight: 600;
            }

            .profile-section h1::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 40px;
                height: 3px;
                background-color: #4a4a4a;
            }

            .info-card {
                background-color: #fff;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.03);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: 1px solid #f0f0f0;
            }

            .info-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(0,0,0,0.06);
            }

            .info-card h3 {
                margin-top: 0;
                color: #333;
                border-bottom: 1px solid #eee;
                padding-bottom: 12px;
                font-size: 1.2rem;
                position: relative;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .info-card h3::before {
                content: '';
                position: absolute;
                left: 0;
                bottom: -1px;
                width: 25px;
                height: 3px;
                background-color: #4a4a4a;
            }

            .info-card h3 i {
                color: #4a4a4a;
            }

            .input-group {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 0;
            }

            .input-field {
                display: flex;
                flex-direction: column;
                margin-bottom: 15px;
            }

            .input-field label {
                margin-bottom: 8px;
                font-weight: 600;
                color: #666;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .input-field input,
            .input-field select,
            .input-field textarea {
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 0.95rem;
                transition: all 0.3s;
                font-family: 'Segoe UI', sans-serif;
            }

            .input-field input:focus,
            .input-field select:focus,
            .input-field textarea:focus {
                border-color: #4a4a4a;
                box-shadow: 0 0 0 2px rgba(74, 74, 74, 0.2);
                outline: none;
            }

            .input-field input[readonly] {
                background-color: #f9f9f9;
                color: #777;
            }

            textarea {
                width: 100%;
                resize: vertical;
                min-height: 100px;
            }

            .btn-container {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                gap: 12px;
            }

            .btn {
                padding: 12px 25px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s;
                font-size: 0.95rem;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
            }

            .btn-cancel {
                background-color: #f1f1f1;
                color: #333;
                flex: 1;
                max-width: 200px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.05);
            }

            .btn-cancel:hover {
                background-color: #e1e1e1;
                box-shadow: 0 5px 12px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }

            .btn-submit {
                background-color: #4a4a4a;
                color: white;
                flex: 1;
                max-width: 200px;
                box-shadow: 0 3px 8px rgba(74, 74, 74, 0.2);
            }

            .btn-submit:hover {
                background-color: #333;
                box-shadow: 0 5px 12px rgba(74, 74, 74, 0.3);
                transform: translateY(-2px);
            }


            @media (max-width: 768px) {
                .input-group {
                    grid-template-columns: 1fr;
                }

                .btn-container {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    max-width: none;
                    margin-bottom: 8px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <div class="navbar">
            <div class="navbar-left">
                <img src="../Images/LOGO2.png" alt="Logo" />
                <a href="../secureCustomer/CustomerDashboard.jsp">Home</a>
                <a href="../Promotion.jsp">Promotion</a>
                <a href="../Product.jsp">Product</a>
                <a href="../about_contact.jsp">About Us</a>
                <a href="#">Rating</a>
            </div>

            <!-- Global parameter (company name) -->
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
                <a href="Cart.jsp" class="icon" title="Cart">                
                    <i class="fas fa-shopping-cart"></i>
                </a>

                <!-- User profile icon -->
                <a href="UserProfile.jsp" class="icon" title="User Profile">
                    <i class="fas fa-user"></i>
                </a>
                
                <!-- Logout icon -->
                 <a href="../Logout.jsp" class="icon" title="Logout">
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

        <!-- Edit Profile -->
        <div class="profile-section">
            <h1>Edit Profile</h1>

            <form action="../UpdateProfileServlet" method="post" onsubmit="return confirm('Sure to update your profile?')">
                <!-- Hidden field for role -->
                <input type="hidden" name="role" value="<%= user.getRole() %>">
                <input type="hidden" name="userId" value="<%= user.getUserId() %>">

                <!-- Personal Info -->
                <div class="info-card">
                    <h3><i class="fas fa-user"></i> Personal Information</h3>
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
                </div>

                <!-- Contact Info -->
                <div class="info-card">
                    <h3><i class="fas fa-phone"></i> Contact Information</h3>
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
                </div>

                <!-- Security Info -->
                <div class="info-card">
                    <h3><i class="fas fa-shield-alt"></i> Security Information</h3>
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
                </div>

                <!-- Button to update -->
                <div class="btn-container">
                    <a href="UserProfile.jsp" class="btn btn-cancel">Cancel</a>
                    <button type="submit" class="btn btn-submit">Update Profile</button>
                </div>
            </form>
        </div>

        <!-- Footer (Global parameter -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}
        </footer>
    </body>
</html>