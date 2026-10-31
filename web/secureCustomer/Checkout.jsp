<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "../CustomerLogin.jsp");
        return;
    }

    UserService userService = new UserService();
    String ic = (String) session.getAttribute("ic");
    if (ic == null) {
        ic = userService.getICByUserId(user.getUserId());
        session.setAttribute("ic", ic);
    }

    boolean isBirthdayMonth = userService.isBirthdayMonth(ic);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

        <title>Checkout</title>
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
            }

            h2 {
                font-size: 24px;
                margin-bottom: 20px;
            }

            h3 {
                font-size: 20px;
                margin-bottom: 15px;
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

            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                background-color: var(--white);
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            th, td {
                padding: 15px;
                text-align: center;
                border-bottom: 1px solid var(--light-gray);
            }

            th {
                background-color: var(--primary);
                color: var(--white);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 14px;
            }

            tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }

            .quantity-input {
                width: 60px;
                padding: 8px 12px;
                border: 1px solid var(--light-gray);
                border-radius: 6px;
                text-align: center;
                font-weight: 600;
                transition: border 0.3s;
            }

            .quantity-input:focus {
                border-color: var(--primary);
                outline: none;
            }

            .btn {
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                font-size: 14px;
            }

            .update-btn {
                background-color: var(--light-gray);
                color: var(--text);
            }

            .update-btn:hover {
                background-color: #d0d0d0;
            }

            .remove-btn {
                background-color: #f8d7da;
                color: #721c24;
            }

            .remove-btn:hover {
                background-color: #f5c6cb;
            }

            .proceed-btn {
                width: 100%;
                padding: 14px;
                background-color: var(--primary);
                color: var(--white);
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .proceed-btn:hover {
                background-color: var(--accent);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .dropdown {
                width: 100%;
                padding: 12px 15px;
                font-size: 16px;
                margin: 15px 0;
                border: 1px solid var(--light-gray);
                border-radius: 8px;
                background-color: var(--white);
                color: var(--text);
                transition: border 0.3s;
            }

            .dropdown:focus {
                border-color: var(--primary);
                outline: none;
            }

            footer {
                flex-shrink: 0;
                background-color: var(--primary-color);
                color: black;
                padding: 20px;
                text-align: center;
                margin-top: auto;
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

            .tip-warning, .tip-success {
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

            .tip-warning {
                background-color: var(--warning-bg);
                border: 1px solid #f5c6cb;
                color: #721c24;
            }

            .tip-success {
                background-color: var(--success-bg);
                border: 1px solid #c3e6cb;
                color: #155724;
            }

            .birthday-message {
                background-color: var(--birthday-bg);
                color: #000;
                text-align: center;
                padding: 15px;
                font-weight: 700;
                margin-bottom: 30px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .cart-summary {
                background-color: var(--white);
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                border: 1px solid var(--light-gray);
                margin-top: 30px;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding: 8px 0;
            }

            .summary-label {
                font-weight: 600;
            }

            .summary-value {
                font-weight: 700;
            }

            .grand-total {
                font-size: 18px;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid var(--light-gray);
            }

            @media (max-width: 768px) {
                .container {
                    width: 95%;
                    padding: 20px;
                }

                table {
                    display: block;
                    overflow-x: auto;
                }

                .header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Checkout</h1>
                <a href="../Product.jsp" class="continue-shopping">
                    <i class="fas fa-arrow-left"></i> &nbsp; Continue Shopping
                </a>
            </div>

            <% if (isBirthdayMonth) { %>
            <div class="birthday-message">
                🎉  Happy birthday! It's your month! Get a gift once you purchase!
            </div>
            <% } %>

            <%
                String userId = user.getUserId();
                CartItemService cartItemService = new CartItemService();
                List<Cartitem> cartItems = cartItemService.getCartItemsByUserId(userId);

                session.setAttribute("cartItems", cartItems);

                if (cartItems == null || cartItems.isEmpty()) {
            %>
            <div class="cart-empty">
                <h2 class="empty-title">Your Cart is Empty</h2>
                <p class="empty-message">Looks like you haven't added any items to your cart yet.</p>
                <a href="../Product.jsp" class="proceed-btn">Browse Products</a>
            </div>
            <%
                    return;
                }

                DecimalFormat df = new DecimalFormat("#0.00");
                double subtotal = 0.0;
                for (Cartitem item : cartItems) {
                    if (item.getProduct() != null) {
                        subtotal += item.getQuantity() * item.getProduct().getPrice();
                    }
                }

                double deliveryFee = (subtotal < 1000) ? 25.0 : 0.0;
                double totalPrice = subtotal + deliveryFee;
            %>

            <h2>Order Summary</h2>

            <table>
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price Each</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Cartitem item : cartItems) {
                        if (item.getProduct() != null) {
                            double itemSubtotal = item.getQuantity() * item.getProduct().getPrice();
                    %>
                    <tr>
                        <td><%= item.getProduct().getProductName() %></td>
                        <td>
                            <form action="<%= request.getContextPath() %>/UpdateCartItemServlet" method="post" style="display: flex; justify-content: center; gap: 8px;">
                                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                <input type="hidden" name="originPage" value="checkout">
                                <input type="number" name="quantity" class="quantity-input" value="<%= item.getQuantity() %>" min="1" required>
                                <button type="submit" class="btn update-btn">Update</button>
                            </form>
                        </td>
                        <td>RM <%= df.format(item.getProduct().getPrice()) %></td>
                        <td>RM <%= df.format(itemSubtotal) %></td>
                        <td>
                            <form action="<%= request.getContextPath() %>/RemoveCartItemServlet" method="post">
                                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                <input type="hidden" name="originPage" value="checkout">
                                <button type="submit" class="btn remove-btn">Remove</button>
                            </form>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>

            <% 
            if (subtotal < 1000) {
                double remaining = 1000 - subtotal;
            %>
            <div class="tip-warning">
                💡 You're <strong>RM <%= df.format(remaining) %></strong> away from <strong>FREE delivery</strong>! 
                Add more items to save RM <%= df.format(deliveryFee) %> on shipping.
            </div>
            <% 
                } else { 
            %>
            <div class="tip-success">
                ✅ You've qualified for <strong>FREE delivery</strong>!
            </div>
            <% } %>

            <div class="cart-summary">
                <h3>Order Summary</h3>

                <div class="summary-row">
                    <span class="summary-label">Subtotal (<%= cartItems.size() %> items)</span>
                    <span class="summary-value">RM <%= df.format(subtotal) %></span>
                </div>

                <div class="summary-row">
                    <span class="summary-label">Delivery Fee</span>
                    <span class="summary-value">RM <%= df.format(deliveryFee) %></span>
                </div>

                <div class="summary-row grand-total">
                    <span class="summary-label">Grand Total</span>
                    <span class="summary-value">RM <%= df.format(totalPrice) %></span>
                </div>

                <form action="../secureCustomer/PaymentDetails.jsp" method="get">
                    <label for="paymentMethod" style="display: block; margin-bottom: 8px; font-weight: 600;">Select Payment Method:</label>
                    <select name="paymentMethod" id="paymentMethod" class="dropdown" required>
                        <option value="" disabled selected>Select a payment method</option>
                        <option value="CreditCard">Credit Card</option>
                        <option value="EWallet">E-Wallet</option>
                        <option value="Cash">Cash</option>
                    </select>

                    <input type="hidden" name="subtotal" value="<%= subtotal %>">
                    <input type="hidden" name="deliveryFee" value="<%= deliveryFee %>">
                    <input type="hidden" name="totalPrice" value="<%= totalPrice %>">

                    <button type="submit" class="proceed-btn">
                        Proceed to Payment <i class="fas fa-arrow-right"></i>
                    </button>
                </form>
            </div>
        </div>
        <!-- Footer -->
        <footer>
            ${copyright}
            | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
        </footer>
    </body>
</html>