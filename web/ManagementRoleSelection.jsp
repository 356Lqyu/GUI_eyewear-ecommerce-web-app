<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
   // Invalidate existing session
    HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
                oldSession.invalidate();
        } 
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="login.css" />
        <title>Four Eyes Collective - Management Role Selection</title>
        <style>
            .role-link {
                text-decoration: none;
                color: inherit;
            }
        </style>
    </head>
    <body>
        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="Images/LOGO3.png" alt="Four Eyes Collective Logo" style="height: 120px;">
                </a>
            </div>
            <!-- Select management personnel to login (Staff & Manager) -->
            <div class="form-container">
                <div class="form-box">
                    <h1>Select Your Role</h1>
                    <div class="role-options">
                        <a href="secureStaff/StaffDashboard.jsp" class="role-link">
                            <div class="role-option">
                                <i class="fas fa-user"></i>
                                <div class="role-info">
                                    <h3>Staff</h3>
                                </div>
                            </div>
                        </a>

                        <a href="secureManager/ManagerDashboard.jsp" class="role-link">
                            <div class="role-option">
                                <i class="fas fa-user-tie"></i>
                                <div class="role-info">
                                    <h3>Manager</h3>
                                </div>
                            </div>
                        </a>
                    </div>

                    <!-- Back to Login Role Selection -->
                    <div class="back-link-container">
                        <a href="LoginRoleSelection.html" class="back-link">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>