<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.*, controller.* " %>
<%@ page session="true" %>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp");
        return;
    }
    String paymentMethod = request.getParameter("paymentMethod");
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment Details</title>
        <style>
            :root {
                --primary: #000000;
                --secondary: #f5f5f5;
                --accent: #5c5554;
                --light-gray: #e0e0e0;
                --white: #ffffff;
                --text: #333333;
                --warning-bg: #fff0f0;
                --success-bg: #e0ffe0;
                --birthday-bg: #ffeb3b;
            }

            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: var(--secondary);
                color: var(--text);
                line-height: 1.6;
                overscroll-behavior: none;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                animation: fadeIn 1s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .container {
                width: 85%;
                max-width: 600px;
                margin: 30px auto;
                padding: 30px;
                background-color: var(--white);
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                flex: 1;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 20px;

            }

            h1, h2, h3 {
                margin: 0;
                color: var(--primary);
                font-weight: 700;
            }

            h2 {
                font-size: 24px;
                text-align: center;
                padding-bottom: 15px;
                border-bottom: 1px solid var(--light-gray);
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                font-weight: 600;
                display: block;
                margin-bottom: 8px;
                font-size: 0.95rem;
                color: var(--text);
            }

            input[type="text"],
            input[type="tel"],
            textarea,
            select {
                width: 95%;
                padding: 12px 15px;
                border: 1px solid var(--light-gray);
                border-radius: 8px;
                background-color: var(--white);
                font-size: 1rem;
                color: var(--text);
                transition: border 0.3s;
            }

            input[type="month"] {
                width: 90%;
                padding: 12px 15px;
                border: 1px solid var(--light-gray);
                border-radius: 8px;
                background-color: var(--white);
                font-size: 1rem;
                color: var(--text);
                transition: border 0.3s;
            }

            input:focus,
            textarea:focus,
            select:focus {
                border-color: var(--primary);
                outline: none;
                background-color: var(--white);
            }

            .radio-group {
                display: flex;
                gap: 2rem;
                margin-top: 10px;
            }

            .radio-container {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            input[type="radio"] {
                width: 18px;
                height: 18px;
                accent-color: var(--primary);
            }

            .submit-btn {
                width: 100%;
                padding: 15px;
                background-color: var(--primary);
                color: var(--white);
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 10px;
                text-transform: uppercase;
            }

            .submit-btn:hover {
                background-color: var(--accent);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .payment-notice, .error-message {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 25px;
                font-weight: 600;
                text-align: center;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .payment-notice {
                background-color: lightgray;
                border: 1px solid #c3e6cb;
                color: #155724;
            }

            .error-message {
                background-color: var(--warning-bg);
                border: 1px solid #f5c6cb;
                color: #721c24;
            }

            .grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
            }

            textarea {
                resize: vertical;
                min-height: 100px;
            }

            footer {
                flex-shrink: 0;
                color: black;
                padding: 20px;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
                margin-top: auto;
            }

            footer a {
                color: black;
                text-decoration: none;
            }

            footer a:hover {
                text-decoration: underline;
            }

            @media (max-width: 768px) {
                .container {
                    width: 95%;
                    padding: 20px;
                }

                .radio-group {
                    flex-direction: column;
                    gap: 1rem;
                }

                .grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Shipping & Payment</h2>
            </div>

            <form action="../ConfirmOrderServlet" method="post">
                <div class="form-group">
                    <label for="shippingAddress">Shipping Address</label>
                    <textarea name="shippingAddress" id="shippingAddress" 
                              placeholder="Enter your full shipping address..." required></textarea>
                </div>

                <% if ("CreditCard".equals(paymentMethod)) { %>
                <div class="form-group">
                    <label>Card Type</label>
                    <div class="radio-group">
                        <div class="radio-container">
                            <input type="radio" name="cardType" id="visa" value="Visa" required>
                            <label for="visa">Visa</label>
                        </div>
                        <div class="radio-container">
                            <input type="radio" name="cardType" id="mastercard" value="MasterCard" required>
                            <label for="mastercard">MasterCard</label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="cardName">Name on Card</label>
                    <input type="text" name="cardName" id="cardName" placeholder="Full Name" required>
                </div>

                <div class="form-group">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" name="cardNumber" id="cardNumber"
                           pattern="\d{4}[\s]?\d{4}[\s]?\d{4}[\s]?\d{4}"
                           title="Card number must be 14 to 16 digits"
                           placeholder="8888 8888 8888 8888"
                           required>
                </div>

                <div class="form-group grid">
                    <div>
                        <label for="expiry">Expiry Date</label>
                        <input type="month" name="expiry" id="expiry" required>
                    </div>
                    <div>
                        <label for="cvv">CVV</label>
                        <input type="text" name="cvv" id="cvv"
                               pattern="\d{3,4}"
                               title="3 or 4-digit security code"
                               placeholder="123" style="width: 90%;"
                               required>
                    </div>
                </div>

                <% } else if ("EWallet".equals(paymentMethod)) { %>
                <div class="form-group">
                    <label for="ewalletType">E-Wallet Type</label>
                    <select name="ewalletType" id="ewalletType" required>
                        <option value="" disabled selected>Select your e-wallet</option>
                        <option value="GrabPay">GrabPay</option>
                        <option value="TouchNGo">Touch 'n Go</option>
                        <option value="Boost">Boost</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="tel" name="phoneNumber" id="phoneNumber"
                           pattern="[0-9]{10,12}"
                           placeholder="0123456789"
                           required>
                </div>

                <% } else if ("Cash".equals(paymentMethod)) { %>
                <div class="payment-notice">
                    <p>You selected Cash on Delivery</p>
                </div>
                <% } else { %>
                <div class="error-message">
                    <p>Invalid payment method selected</p>
                </div>
                <% } %>

                <input type="hidden" name="paymentMethod" value="<%= paymentMethod %>">
                <button type="submit" class="submit-btn">Confirm Order</button>
            </form>
        </div>
        <!-- Footer -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>
    </body>
</html>