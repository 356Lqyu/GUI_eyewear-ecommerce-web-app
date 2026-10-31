<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.*, javax.naming.InitialContext, javax.naming.Context" %>
<%
  // Checks if user is authenticated
  if (request.getUserPrincipal() != null) {
    try {
        // If yes , then will retrieve user details(from database) for manager's profile
        Context ctx = new InitialContext();
        UserService userService = (UserService) ctx.lookup("java:global/FourEyesCollective/UserService");
        
        String username = request.getUserPrincipal().getName();
        Users user = userService.findUserByUsername(username);
        
        if (user != null) {
            // Validate role before proceeding (go to corresponding dashboard based on role)
            // use when manager try to login staff dashboard
            if ("manager".equals(user.getRole())) {
                user.setManager(userService.findManagerById(user.getUserId()));
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/secureManager/ManagerDashboard.jsp");
                return;
            } else if ("staff".equals(user.getRole())) {
                user.setStaff(userService.findStaffById(user.getUserId()));
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/secureStaff/StaffDashboard.jsp");
                return;
            } 
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "Error loading user details: " + e.getMessage());
    }
}
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <title>Four Eyes Collective - Management Personnel Login</title>
        <style>
            :root {
                --primary: #4a4a4a;
                --secondary: #7d7d7d;
                --accent: #616161;
                --light: #ffffff;
                --dark: #2d2d2d;
                --gray: #e0e0e0;
                --text-light: #757575;
                --text-dark: #424242;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-attachment: fixed;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                overflow: hidden;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0.05;
                pointer-events: none;
            }

            .main-content {
                width: 100%;
                max-width: 1200px;
                padding: 2rem;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .header {
                margin-bottom: 2rem;
                text-align: center;
            }

            .logo-space {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 50%;
                width: 180px;
                height: 180px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                margin: 0 auto;
                transition: transform 0.3s ease;
            }

            .logo-space:hover {
                transform: scale(1.05);
            }

            .form-container {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 450px;
                padding: 3rem;
                position: relative;
                overflow: hidden;
            }

            .form-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 5px;
                height: 100%;
                background: linear-gradient(to bottom, var(--primary), var(--secondary));
            }

            .form-box h1 {
                font-size: 2.0rem;
                margin-bottom: 2.5rem;
                color: var(--primary);
                position: relative;
                text-align: center;
                font-weight: 700;
            }

            .form-box h1::after {
                content: '';
                width: 50px;
                height: 4px;
                border-radius: 3px;
                background: linear-gradient(to right, var(--primary), var(--secondary));
                position: absolute;
                bottom: -15px;
                left: 50%;
                transform: translateX(-50%);
            }

            .input-group {
                margin: 1.5rem 0;
                position: relative;
            }

            .input-group i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--gray);
                transition: all 0.3s;
            }

            .input-group input {
                width: 100%;
                padding: 15px 15px 15px 45px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 1rem;
                transition: all 0.3s;
                background-color: #f8f9fa;
            }

            .input-group input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(60, 0, 160, 0.1);
                outline: none;
                background-color: white;
            }

            .input-group input:focus + i {
                color: var(--primary);
            }


            #loginBtn {
                width: 100%;
                padding: 15px;
                border: none;
                border-radius: 8px;
                background: linear-gradient(to right, var(--primary), var(--secondary));
                color: white;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(60, 0, 160, 0.3);
            }

            #loginBtn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(60, 0, 160, 0.4);
            }

            @media (max-width: 768px) {
                .form-container {
                    padding: 2rem;
                }

                .logo-space {
                    width: 150px;
                    height: 150px;
                }
            }

            .link-container {
                display: flex;
                justify-content: space-between;
                margin: 1rem 0 2rem;
            }

            .link-container a {
                color: var(--text-dark);
                font-size: 0.9rem;
                transition: color 0.3s;
                text-decoration: none;
                font-weight: 500;
            }

            .link-container a:hover {
                color: var(--primary);
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="<%= request.getContextPath() %>/Images/LOGO3.png" alt="Four Eyes Collective Logo" style="height: 120px;">
                </a>
            </div>
            <!-- Form to enter username and password -->
            <div class="form-container">
                <div class="form-box">
                    <h1>Management Personnel Login</h1>
                    <form action="<%= request.getContextPath() %>/j_security_check" method="POST">
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input name="j_username" id="usernameBox" type="text" placeholder="Username" required />
                        </div>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input name="j_password" id="passwordBox" type="password" placeholder="Password" required />
                        </div>

                        <!-- Button to return management login role selection & password recovery -->
                        <div class="link-container">
                            <a href="<%= request.getContextPath() %>/ManagementRoleSelection.jsp">Back</a>
                            <a href="<%= request.getContextPath() %>/ForgotPassword.jsp">Forgot password?</a>
                        </div>
                        <button type="submit" id="loginBtn" name="submit">SIGN IN</button>
                    </form>
                </div>
            </div>
        </main>
    </body>
</html>