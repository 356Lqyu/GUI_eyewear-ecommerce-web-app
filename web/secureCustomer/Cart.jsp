<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.* , java.util.List"%>
<%@page import="jakarta.persistence.EntityManager"%>
<%@page import="jakarta.persistence.EntityManagerFactory"%>
<%@page import="jakarta.persistence.Persistence"%>
<%@page session="true" %>
<%
    // Retrieve the user object from the session
    Users user = (Users) session.getAttribute("user");

    // If user is not logged in, redirect to login page
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/LoginRequest.jsp");
        return;
    }

    EntityManagerFactory emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
    EntityManager em = emf.createEntityManager();

    Cart cart = null;
    List<Cartitem> cartItems = null;
    double total = 0.0;

    try {
        // Fetch the cart for the logged-in user
        cart = em.createQuery("SELECT c FROM Cart c WHERE c.status = 'IN_CART' AND c.user.userId = :uid", Cart.class)
                 .setParameter("uid", user.getUserId())
                 .getSingleResult();
        
        // Fetch the items in the cart
        cartItems = em.createQuery("SELECT ci FROM Cartitem ci WHERE ci.cart = :cart", Cartitem.class)
                      .setParameter("cart", cart)
                      .getResultList();

        // Debugging: Print out cart and cartItems for verification
        System.out.println("Cart fetched: " + cart);
        System.out.println("Cart Items: " + cartItems);
    } catch (Exception e) {
        // Handle exception by setting cartItems to null
        cartItems = null;
        System.out.println("Error fetching cart items: " + e.getMessage());
    } finally {
        em.close();
        emf.close();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

        <title>My Cart</title>
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

            .cart-items {
                margin-bottom: 40px;
            }

            .cart-item {
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 20px;
                padding: 20px;
                margin-bottom: 20px;
                background-color: var(--white);
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s, box-shadow 0.2s;
                border: 1px solid var(--light-gray);
                position: relative;
            }

            .cart-item:hover {
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .item-count-badge {
                position: absolute;
                top: 15px;
                left: 15px;
                background-color: var(--primary);
                color: var(--white);
                border-radius: 50px;
                padding: 3px 8px;
                font-size: 12px;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 4px;
                z-index: 1;
            }

            .product-details {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .product-name {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
                color: var(--primary);
            }

            .product-id {
                font-size: 14px;
                color: var(--accent);
                margin-bottom: 10px;
            }

            .product-price {
                font-size: 16px;
                font-weight: 600;
                color: var(--primary);
                margin-bottom: 15px;
            }

            .product-actions {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .quantity-control {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .input-quantity {
                width: 60px;
                padding: 8px 12px;
                border: 1px solid var(--light-gray);
                border-radius: 6px;
                text-align: center;
                font-weight: 600;
                transition: border 0.3s;
            }

            .input-quantity:focus {
                border-color: var(--primary);
                outline: none;
            }

            .action-button {
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
            }

            .update-btn {
                background-color: var(--light-gray);
                color: var(--text);
            }

            .update-btn:hover {
                background-color: #d0d0d0;
            }

            .remove-button {
                background-color: #f8d7da;
                color: #721c24;
            }

            .remove-button:hover {
                background-color: #f5c6cb;
            }

            .item-total {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                justify-content: space-between;
            }

            .subtotal {
                font-size: 18px;
                font-weight: 700;
                color: var(--primary);
            }

            .cart-summary {
                background-color: var(--white);
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                border: 1px solid var(--light-gray);
            }

            .summary-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 20px;
                color: var(--primary);
                padding-bottom: 10px;
                border-bottom: 1px solid var(--light-gray);
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
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

            .checkout-btn {
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

            .checkout-btn:hover {
                background-color: var(--accent);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .checkout-btn:active {
                transform: translateY(0);
            }

            .cart-empty {
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


            .item-badge {
                position: absolute;
                top: -10px;
                left: -10px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: var(--primary);
                color: var(--white);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 18px;
                box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
            }

            footer {
                flex-shrink: 0;
                background-color: var(--primary-color);
                color: black;
                padding: 20px;
                text-align: center;
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

                .cart-item {
                    grid-template-columns: 1fr;
                }

                .item-total {
                    align-items: flex-start;
                    margin-top: 15px;
                }

                .product-actions {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .item-count-badge {
                    top: 10px;
                    left: 10px;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <main>
                <div class="container">


                    <div class="header">
                        <h1>My Shopping Cart</h1>
                        <a href="../Product.jsp" class="continue-shopping">
                            <i class="fas fa-arrow-left"></i> &nbsp; Continue Shopping
                        </a>
                    </div>

                    <% 
                        // Check if cartItems is null or empty and display appropriate message
                        if (cartItems == null || cartItems.isEmpty()) {
                    %>
                    <div class="cart-empty">
                        <h2 class="empty-title">Your Cart is Empty</h2>
                        <p class="empty-message">Looks like you haven't added any items to your cart yet.</p>
                        <a href="../Product.jsp" class="browse-btn">Browse Products</a>
                    </div>
                    <% 
                        } else {
                            double totalPrice = 0;
                            int itemCount = 0;
                    %>
                    <div class="cart-items">
                        <% 
                            for (Cartitem item : cartItems) {
                                itemCount++;
                                Product product = item.getProduct();
                                double itemTotal = product.getPrice() * item.getQuantity();
                                totalPrice += itemTotal;
                        %>
                        <div class="cart-item">
                            <div class="item-badge"><%= itemCount %></div>
                            <div class="product-details">
                                <div>
                                    <h3 class="product-name"><%= product.getProductName() %></h3>
                                    <p class="product-id">Product ID: <%= product.getProductId() %></p>
                                    <p class="product-price">RM<%= String.format("%.2f", product.getPrice()) %> /pcs</p>
                                </div>

                                <div class="product-actions">
                                    <form action="<%= request.getContextPath() %>/UpdateCartItemServlet" method="post" class="quantity-control">
                                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                        <input type="hidden" name="originPage" value="cart"> 
                                        <label for="quantity_<%= item.getCartItemId() %>">Quantity:</label>
                                        <input type="number" id="quantity_<%= item.getCartItemId() %>" name="quantity" 
                                               value="<%= item.getQuantity() %>" min="1" required class="input-quantity">
                                        <button type="submit" class="action-button update-btn">
                                            Update
                                        </button>
                                    </form>

                                    <form action="<%= request.getContextPath() %>/RemoveCartItemServlet" method="post">
                                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                        <input type="hidden" name="originPage" value="cart"> 
                                        <button type="submit" class="action-button remove-button">
                                            Remove
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <div class="item-total">
                                <p class="subtotal">RM<%= String.format("%.2f", itemTotal) %></p>
                            </div>
                        </div>
                        <% 
                            }
                        %>
                    </div>

                    <div class="cart-summary">
                        <h3 class="summary-title">Order Summary</h3>

                        <div class="summary-row">
                            <span class="summary-label">Subtotal (<%= cartItems.size() %> items)</span>
                            <span class="summary-value">RM<%= String.format("%.2f", totalPrice) %></span>
                        </div>

                        <%
                            double deliveryFee = 0.0;
                            if (totalPrice < 1000) {
                                deliveryFee = 25.0;
                            }
                        %>
                        <div class="summary-row">
                            <span class="summary-label">Delivery Fee</span>
                            <span class="summary-value">RM<%= String.format("%.2f", deliveryFee) %></span>
                        </div>

                        <div class="summary-row grand-total">
                            <span class="summary-label">Grand Total</span>
                            <span class="summary-value">RM<%= String.format("%.2f", totalPrice + deliveryFee) %></span>
                        </div>

                        <form action="Checkout.jsp" method="post">
                            <button type="submit" class="checkout-btn">
                                <i class="fas fa-arrow-right"></i> &nbsp; Proceed to Checkout
                            </button>
                        </form>
                    </div>
                    <% } %>
                </div>
            </main>
            <!-- Footer -->
            <footer>
                ${copyright}
                | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
            </footer>
        </div>
    </body>
</html>