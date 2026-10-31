<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.*, controller.* , jakarta.persistence.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
    <head>
        <title>Monthly Sales Report</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: var(--secondary);
                color: var(--text);
                line-height: 1.6;
                overscroll-behavior: none;
                padding-bottom: 60px;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                position: relative;
            }

            .container {
                width: 85%;
                max-width: 1200px;
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
                border-bottom: 1px solid var(--light-gray);
            }

            .logo-container {
                text-align: center;
                margin-bottom: 10px;
            }

            .logo-container img {
                max-height: 120px;
            }

            h1, h2 {
                color: var(--primary);
                text-align: center;
            }

            h1 {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 10px;
            }

            h2 {
                font-size: 22px;
                font-weight: 600;
                margin: 30px 0 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid var(--light-gray);
            }

            .report-meta {
                text-align: center;
                color: var(--accent);
                margin-bottom: 30px;
                font-size: 14px;
            }

            .summary-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .summary-card {
                background-color: var(--white);
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                border: 1px solid var(--light-gray);
                text-align: center;
            }

            .summary-card-title {
                font-size: 16px;
                color: var(--accent);
                margin-bottom: 10px;
            }

            .summary-card-value {
                font-size: 24px;
                font-weight: 700;
                color: var(--primary);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0 30px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid var(--light-gray);
            }

            th {
                background-color: var(--secondary);
                font-weight: 600;
                color: var(--primary);
            }

            tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }

            .currency {
                font-weight: 600;
            }


            .buttons {
                text-align: center;
                margin-top: 30px;
            }

            .print-btn {
                padding: 12px 30px;
                background-color: var(--primary);
                color: var(--white);
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s;
                display: inline-flex;
                align-items: center;
            }

            .print-btn i {
                margin-right: 8px;
            }

            .print-btn:hover {
                background-color: var(--accent);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .back-to-dashboard {
                display: inline-flex;
                align-items: center;
                color: var(--primary);
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s;
            }

            .back-to-dashboard:hover {
                color: var(--accent);
            }

            .back-to-dashboard svg {
                margin-right: 8px;
            }

            .footer {
                text-align: center;
                padding-left: 180px;
                width: 80%;
                margin-top: auto;
            }


            @media (max-width: 768px) {
                .container {
                    width: 95%;
                    padding: 20px;
                }

                .summary-cards {
                    grid-template-columns: 1fr;
                }

                th, td {
                    padding: 8px 10px;
                    font-size: 14px;
                }
            }

            @media print {
                @page {
                    size: A4 portrait;
                    margin: 15mm 10mm;
                }

                body {
                    background-color: var(--white);
                    margin: 0;
                    padding: 0;
                    font-size: 10pt;
                    line-height: 1.3;
                    color: #000;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    padding-bottom: 20mm;
                    display: block;

                }

                .footer {
                    position: fixed;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    background-color: var(--white);
                    border-top: 1px solid #ddd;
                }

                .container {
                    box-shadow: none;
                    padding: 0;
                    margin: 0;
                    width: 100%;
                    max-width: 100%;
                }

                .buttons, .header {
                    display: none;
                }

                .logo-container {
                    margin-bottom: 15px;
                }

                .logo-container img {
                    max-height: 50px;
                }

                h1 {
                    font-size: 16pt;
                    margin-bottom: 5mm;
                }

                h2 {
                    font-size: 14pt;
                    margin: 5mm 0 3mm;
                    page-break-after: avoid;
                }

                .report-meta {
                    font-size: 9pt;
                    margin-bottom: 5mm;
                }

                table {
                    width: 100%;
                    margin: 3mm 0 5mm;
                    font-size: 9pt;
                    page-break-inside: avoid;
                }

                th, td {
                    padding: 3px 6px;
                }

                .summary-cards {
                    display: table;
                    width: 100%;
                    margin-bottom: 5mm;
                    page-break-inside: avoid;
                }

                .summary-card {
                    display: table-cell;
                    width: 15%;
                    padding: 3mm;
                    border: 1px solid #ddd;
                    box-shadow: none;
                    page-break-inside: avoid;
                }

                .summary-card-title {
                    font-size: 9pt;
                }

                .summary-card-value {
                    font-size: 12pt;
                }

                .summary-cards, table, .summary-card {
                    page-break-inside: avoid;
                }

                h2 {
                    page-break-before: auto;
                }

                tr {
                    page-break-inside: avoid;
                }



            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/Images/LOGO3.png" alt="Company Logo" />
                </div>

                <a href="${pageContext.request.contextPath}/secureManager/ManagerDashboard.jsp" class="back-to-dashboard">
                    <i class="fas fa-arrow-left"></i> &nbsp;Back To Dashboard
                </a>
            </div>

            <h1>Monthly Sales Report</h1>

            <div class="report-meta">
                <p>Month: ${month} | Generated on: <%= new java.util.Date() %></p>
            </div>

            <div class="summary-cards">
                <div class="summary-card">
                    <div class="summary-card-title">Total Orders</div>
                    <div class="summary-card-value">${totalOrders}</div>
                </div>
                <div class="summary-card">
                    <div class="summary-card-title">Total Revenue</div>
                    <div class="summary-card-value">RM ${totalRevenue}</div>
                </div>
                <div class="summary-card">
                    <div class="summary-card-title">Unique Customers</div>
                    <div class="summary-card-value">${totalCustomers}</div>
                </div>
                <div class="summary-card">
                    <div class="summary-card-title">Avg. Order Value</div>
                    <div class="summary-card-value">
                        <c:choose>
                            <c:when test="${totalOrders > 0}">
                                RM <fmt:formatNumber value="${totalRevenue / totalOrders}" maxFractionDigits="2" />
                            </c:when>
                            <c:otherwise>RM 0.00</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <h2>Payment Method Breakdown</h2>
            <table>
                <tr>
                    <th>Payment Method</th>
                    <th>Number of Orders</th>
                </tr>
                <c:forEach var="method" items="${paymentMethods}">
                    <tr>
                        <td>${method[0]}</td>
                        <td>${method[1]}</td>
                    </tr>
                </c:forEach>
            </table>

            <h2>Order Details</h2>
            <table>
                <tr>
                    <th>Order ID</th>
                    <th>Customer Name</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                </tr>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.user.username}</td>
                        <td>${order.orderDate}</td>
                        <td class="currency">RM <fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2" /></td>
                        <td>
                            <span class="status-${order.status.toLowerCase()}">${order.status}</span>
                        </td>
                    </tr>
                </c:forEach>
            </table>

            <div class="buttons">
                <button onclick="window.print()" class="print-btn">
                    <i class="fas fa-print"></i> Print / Save as PDF
                </button>
            </div>
        </div>
        <!-- Footer -->
        <footer class="footer">
            ${copyright}
        </footer>
        
    </body>
</html>