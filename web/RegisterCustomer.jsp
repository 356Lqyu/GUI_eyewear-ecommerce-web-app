<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <title>Four Eyes Collective - Customer Registration</title>
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
                overflow-x: hidden;
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
                flex-direction: row;
                align-items: flex-start;
                justify-content: space-between;
            }

            .header {
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding-right: 2rem;
                width: 30%;
                margin-top: 200px;
            }

            .logo-space {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 50%;
                width: 280px;
                height: 280px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto;
            }

            .form-container {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                width: 65%;
                padding: 2rem;
                position: relative;
                overflow: hidden;
                margin-left: 0;
                margin-right: -50px;
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
                font-size: 1.8rem;
                margin-bottom: 1.8rem;
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
                bottom: -12px;
                left: 50%;
                transform: translateX(-50%);
            }

            .section-title {
                font-size: 1.2rem;
                margin: 1.5rem 0 0.8rem;
                color: var(--primary);
                border-bottom: 2px solid var(--gray);
                padding-bottom: 0.5rem;
                display: flex;
                align-items: center;
            }

            .section-title i {
                margin-right: 10px;
                color: var(--secondary);
            }

            .input-group {
                display: flex;
                gap: 15px;
                margin-bottom: 0.8rem;
                flex-wrap: wrap;
            }

            .input-field {
                flex: 1;
                min-width: 200px;
                position: relative;
                margin-bottom: 0.8rem;
            }

            .input-field label {
                display: block;
                font-weight: 500;
                margin-bottom: 5px;
                color: var(--text-dark);
                font-size: 0.85rem;
            }

            .input-field input {
                width: 100%;
                padding: 10px 15px 10px 35px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 0.9rem;
                transition: all 0.3s;
                background-color: #f8f9fa;
            }

            .input-field input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(60, 0, 160, 0.1);
                outline: none;
                background-color: white;
            }

            .input-field i {
                position: absolute;
                left: 12px;
                top: 33px;
                color: var(--gray);
                transition: all 0.3s;
            }

            .input-field input:focus + i {
                color: var(--primary);
            }

            #registerBtn {
                width: 100%;
                padding: 12px;
                border: none;
                border-radius: 8px;
                background: linear-gradient(to right, var(--primary), var(--secondary));
                color: white;
                font-size: 0.95rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(60, 0, 160, 0.3);
                margin-top: 1.5rem;
            }

            #registerBtn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(60, 0, 160, 0.4);
            }

            .login-link {
                text-align: center;
                margin-top: 1.5rem;
                color: var(--text-light);
                font-size: 0.9rem;
            }

            .login-link a {
                color: var(--dark);
                font-weight: 600;
                text-decoration: none;
                transition: color 0.3s;
            }

            .login-link a:hover {
                color: var(--primary);
                text-decoration: underline;
            }

            .error-message {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
                display: none;
            }

            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 5px;
                margin: 25px auto;
                max-width: 1000px;
                border: 1px solid #c3e6cb;
            }

            .error-message-container {
                background-color: #f8d7da;
                color: #721c24;
                padding: 10px;
                border-radius: 5px;
                margin: 25px auto;
                max-width: 1000px;
                border: 1px solid #f5c6cb;
            }

            @media (max-width: 900px) {
                .main-content {
                    flex-direction: column;
                    align-items: center;
                }

                .header {
                    width: 100%;
                    padding-right: 0;
                    margin-bottom: 2rem;
                    margin-top: 0;
                }

                .form-container {
                    width: 100%;
                    margin-right: 0;
                }
            }

        </style>
    </head>
    <body>
        <main class="main-content">
            <div class="header">
                <a href="#" class="logo-space">
                    <img src="Images/LOGO3.png" alt="Four Eyes Collective Logo" style="height: 220px; width: 220px; ">
                </a>
            </div>

            <div class="form-container">
                <div class="form-box">
                    <h1>Create Account</h1>

                    <!-- show error message (details validation of username ,ic , phone number and gmail) -->
                    <% if(session.getAttribute("errorMessage") != null) { %>
                    <div class="error-message-container">
                        <div class="error-icon">
                            &#10060;
                            <%= session.getAttribute("errorMessage") %>
                        </div>
                    </div>
                    <% 
                       // Remove the error message after display
                       session.removeAttribute("errorMessage");
                    } %>

                    <!-- after successful registration, success message will be displayed -->
                    <% if(session.getAttribute("successMessage") != null) { %>
                    <div class="success-message">
                        <div class="success-icon">
                            ✓ <%= session.getAttribute("successMessage") %>
                        </div>
                    </div>
                    <% 
                       // Remove the success message after display
                       session.removeAttribute("successMessage");
                    } %>

                    <!-- Registration form -->
                    <form action="RegisterCustomerServlet" method="POST" onsubmit="return confirm('Sure to register with username ' + document.getElementById('username').value + '?')">
                        <!-- Personal Information -->
                        <h3 class="section-title"><i class="fas fa-user"></i> Personal Information</h3>
                        <div class="input-group">
                            <div class="input-field">
                                <label for="username">Username</label>
                                <input name="username" id="username" type="text" placeholder="Enter username" required />
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="input-field">
                                <label for="ic">IC Number</label>
                                <input name="ic" id="ic" type="text" placeholder="Enter IC number (YYMMDD-XX-XXXX)" required />
                                <i class="fas fa-id-card"></i>
                            </div>
                        </div>

                        <!-- Contact Information -->
                        <h3 class="section-title"><i class="fas fa-phone"></i> Contact Information</h3>
                        <div class="input-group">
                            <div class="input-field">
                                <label for="email">Email Address</label>
                                <input name="email" id="email" type="email" placeholder="Enter email (@gmail.com)" required />
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="input-field">
                                <label for="contactNumber">Contact Number</label>
                                <input name="contactNumber" id="contactNumber" type="text" placeholder="Enter phone number (0XX-XXXXXXX)" required />
                                <i class="fas fa-phone"></i>
                            </div>
                        </div>

                        <!-- Security Information -->
                        <h3 class="section-title"><i class="fas fa-shield-alt"></i> Security Question</h3>
                        <div class="input-group">
                            <div class="input-field">
                                <label for="password">Password</label>
                                <input name="password" id="password" type="password" placeholder="Enter password (min 6 characters)" required />
                                <i class="fas fa-lock"></i>
                            </div>
                            <div class="input-field">
                                <label for="securityQuestion">Security Question</label>
                                <input name="securityQuestion" id="securityQuestion" type="text" placeholder="Enter security question" required />
                                <i class="fas fa-question-circle"></i>
                            </div>
                            <div class="input-field">
                                <label for="securityAnswer">Security Answer</label>
                                <input name="securityAnswer" id="securityAnswer" type="text" placeholder="Enter security answer" required />
                                <i class="fas fa-key"></i>
                            </div>
                        </div>

                        <button type="submit" id="registerBtn">REGISTER</button>

                        <div class="login-link">
                            Already have an account? <a href="CustomerLogin.jsp">Login here</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </body>
</html>