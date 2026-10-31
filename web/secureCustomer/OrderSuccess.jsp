<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.*"%>
<%@page import="java.util.List"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("../CustomerLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Order Success</title>
        <style>
            :root {
                --primary: #000000;
                --secondary: #f5f5f5;
                --accent: #5c5554;
                --light-gray: #e0e0e0;
                --white: #ffffff;
                --text: #333333;
                --success-bg: #e0ffe0;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: var(--secondary);
                color: var(--text);
                line-height: 1.6;
                overscroll-behavior: none;
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
                max-width: 1200px;
                margin: 30px auto;
                padding: 30px;
                background-color: var(--white);
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid var(--light-gray);
            }

            h1, h2, h3 {
                margin: 0;
                color: var(--primary);
                font-weight: 700;
            }

            h1 {
                font-size: 28px;
                text-align: center;
                margin-bottom: 30px;
            }

            h2 {
                font-size: 24px;
                margin-bottom: 20px;
            }

            h3 {
                font-size: 20px;
                margin-bottom: 15px;
            }

            .success-message {
                background-color: var(--success-bg);
                color: #155724;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
                text-align: center;
                font-size: 18px;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .order-card {
                background-color: var(--white);
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                border: 1px solid var(--light-gray);
                margin-bottom: 30px;
            }

            .order-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

            .order-info p {
                margin: 10px 0;
                font-size: 16px;
            }

            .order-info strong {
                color: var(--primary);
                font-weight: 600;
            }

            .back-home-link {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 14px 28px;
                background-color: var(--primary);
                color: var(--white);
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 16px;
                transition: all 0.3s;
                margin-top: 20px;
                gap: 8px;
            }

            .back-home-link:hover {
                background-color: var(--accent);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            footer {
                flex-shrink: 0;
                background-color: var(--primary-color);
                color: black;
                text-align: center;
                margin-top: 0px;
                padding-top: 6px;
                width: 100%;
                box-sizing: border-box;
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

                .order-info {
                    grid-template-columns: 1fr;
                }

                h1 {
                    font-size: 24px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Order Confirmation</h1>
            </div>

            <div class="success-message">
                🎉 Thank you for your order! Your purchase was successful.
            </div>

            <div class="order-card">
                <h2>Order Details</h2>
                <div class="order-info">
                    <p><strong>Order ID:</strong> ${orderId != null ? orderId : 'N/A'}</p>
                    <p><strong>Payment ID:</strong> ${paymentId != null ? paymentId : 'N/A'}</p>
                    <p><strong>Total Amount:</strong> RM${totalAmount != null ? totalAmount : 'N/A'}</p>
                    <p><strong>Payment Method:</strong> ${paymentMethod != null ? paymentMethod : 'N/A'}</p>
                    <p><strong>Shipping Address:</strong> ${shippingAddress != null ? shippingAddress : 'N/A'}</p>
                    <p><strong>Payment Date:</strong> ${paymentDate != null ? paymentDate : 'N/A'}</p>
                    <p><strong>Order Created:</strong> ${orderDate != null ? orderDate : 'N/A'}</p>
                </div>
            </div>

            <div style="text-align: center;">
                <a href="<%= request.getContextPath() %>/secureCustomer/CustomerDashboard.jsp" class="back-home-link">
                    <i class="fas fa-arrow-left"></i> &nbsp; Return to Dashboard
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>
    </body>
</html>