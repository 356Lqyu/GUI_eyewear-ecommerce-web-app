<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.*" %>
<%
    Users user = (Users) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp");
        return;
    }

    List<Orders> orderList = (List<Orders>) request.getAttribute("orderList");

    int totalOrders = 0;
    double totalSpent = 0.0;

    if (orderList != null) {
        totalOrders = orderList.size();
        for (Orders order : orderList) {
            totalSpent += order.getTotalAmount();
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <title>Order History</title>
        <style>
            :root {
                --primary: #000000;
                --secondary: #f5f5f5;
                --accent: #5c5554;
                --light-gray: #e0e0e0;
                --white: #ffffff;
                --text: #333333;
            }

            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
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

            .page-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            main {
                flex: 1;
            }

            .container {
                width: 85%;
                max-width: 1200px;
                margin: 30px auto;
                padding: 30px;
                background-color: var(--white);
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                position: relative;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid var(--light-gray);
            }

            h1 {
                margin: 0;
                color: var(--primary);
                font-size: 28px;
                font-weight: 700;
            }

            .continue-shopping {
                display: inline-flex;
                align-items: center;
                color: var(--primary);
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s;
            }

            .continue-shopping:hover {
                color: var(--accent);
            }

            .continue-shopping svg {
                margin-right: 8px;
            }

            .order-grid {
                display: grid;
                grid-template-columns: 1fr;
                gap: 20px;
                margin-bottom: 40px;
            }

            .order-card {
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 20px;
                padding: 20px;
                background-color: var(--white);
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s, box-shadow 0.2s;
                border: 1px solid var(--light-gray);
                position: relative;
            }

            .order-card:hover {
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transform: translateY(-2px);
            }

            .order-details {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .order-id {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
                color: var(--primary);
            }

            .order-date {
                font-size: 14px;
                color: var(--accent);
                margin-bottom: 10px;
            }

            .order-address {
                font-size: 14px;
                color: var(--text);
                margin-bottom: 15px;
            }

            .order-summary {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                justify-content: space-between;
            }

            .order-total {
                font-size: 18px;
                font-weight: 700;
                color: var(--primary);
            }

            .order-status {
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: 600;
                background-color: var(--light-gray);
                color: var(--text);
                text-align: center;
                margin-top: 10px;
            }

            .status-completed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }

            .empty {
                text-align: center;
                padding: 60px 20px;
            }

            .empty-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 20px;
                color: var(--primary);
            }

            .empty-message {
                font-size: 16px;
                margin-bottom: 30px;
                color: var(--text);
            }

            .browse-btn {
                padding: 12px 30px;
                background-color: var(--primary);
                color: var(--white);
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
            }

            .browse-btn:hover {
                background-color: var(--accent);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .order-totals-summary {
                background-color: var(--white);
                padding: 25px;
                margin-top: 20px;
            }

            .summary-title {
                display: flex;
                align-items: center;
                font-size: 30px;
                font-weight: 700;
                margin-bottom: 20px;
                color: var(--primary);
                padding-bottom: 10px;
                border-bottom: 1px solid var(--light-gray);
            }
            .summary-title i {
                margin-right: 12px;
                font-size: 30px;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
            }

            .summary-label {
                font-size:18px;
                font-weight: 600;
            }

            .summary-value {
                font-size: 18px;
                font-weight: 700;
            }

            footer {
                flex-shrink: 0;
                background-color: var(--primary);
                color: white;
                padding: 20px;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
            }

            footer a {
                color: white;
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

                .order-card {
                    grid-template-columns: 1fr;
                }

                .order-summary {
                    align-items: flex-start;
                    margin-top: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <main>
                <div class="container">
                    <div class="header">
                        <h1>Order History</h1>
                        <a href="${pageContext.request.contextPath}/secureCustomer/CustomerDashboard.jsp" class="continue-shopping">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M19 12H5M12 19l-7-7 7-7"/>
                            </svg>
                            Back To Home
                        </a>
                    </div>

                    <% if (orderList != null && !orderList.isEmpty()) { %>
                    <div class="order-grid">
                        <% for (Orders order : orderList) { %>
                        <div class="order-card">
                            <div class="order-details">
                                <div>
                                    <h3 class="order-id">Order ID: <%= order.getOrderId() %></h3>
                                    <p class="order-date">Date: <%= order.getOrderDate() %></p>
                                    <p class="order-address">Shipping Address: <%= order.getShippingAddress() %></p>
                                </div>
                            </div>

                            <div class="order-summary">
                                <p class="order-total">RM<%= String.format("%.2f", order.getTotalAmount()) %></p>
                                <div class="order-status <%= "status-" + order.getStatus().toLowerCase().replace(" ", "-") %>">
                                    <%= order.getStatus() %>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <!-- Add summary section after all order cards -->
                        <div class="order-totals-summary">
                            <h3 class="summary-title">
                                <i class="fas fa-clipboard-list"></i>
                                Order Summary
                            </h3>
                            <div class="summary-row">
                                <span class="summary-label">Total Orders</span>
                                <span class="summary-value"><%= totalOrders %></span>
                            </div>
                            <div class="summary-row">
                                <span class="summary-label">Total Amount Spent</span>
                                <span class="summary-value">RM<%= String.format("%.2f", totalSpent) %></span>
                            </div>
                        </div>
                    </div>
                    <% } else { %>
                    <div class="empty">
                        <h2 class="empty-title">No Orders Found</h2>
                        <p class="empty-message">You haven't placed any orders yet.</p>
                        <a href="../Product.jsp" class="browse-btn">Browse Products</a>
                    </div>
                    <% } %>
                </div>
            </main>
            <footer>
                ${copyright}
                | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
            </footer>
        </div>
    </body>
</html>