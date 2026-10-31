<%@ page import="jakarta.persistence.*, model.*, java.util.*, javax.naming.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Get the user from session 
    Users user = (Users) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect("../CustomerLogin.jsp");
        return;
    }
    
    // To get customer details 
    Customer customerDetails = user.getCustomer();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add to Cart</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            :root {
                --primary-color: #333333;
                --secondary-color: #555555;
                --accent-color: #888888;
                --light-color: #f1f1f1;
            }

            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: var(--light-color);
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                animation: fadeIn 1s ease-out;
                overscroll-behavior: none;
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

            .compact-container {
                max-width: 800px;
                margin: 30px auto;
                padding: 0 20px;
                flex: 1;
            }

            .compact-card {
                background: white;
                border-radius: 50px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                overflow: hidden;
                display: flex;
                flex-direction: column;
                width: 600px;
                margin-bottom: 30px;
            }

            .product-image-container {
                padding: 20px;
                text-align: center;
                background: white;
                border-bottom: 1px solid #eee;
            }

            .product-image {
                max-width: 100%;
                max-height: 300px;
                object-fit: contain;
            }

            .product-info {
                padding: 20px;
            }

            .product-title {
                font-size: 1.5rem;
                color: var(--primary-color);
                margin: 0 0 10px 0;
                font-weight: 600;
            }

            .product-meta {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
            }

            .product-category {
                background: var(--primary-color);
                color: white;
                padding: 3px 10px;
                border-radius: 12px;
                font-size: 0.8rem;
            }

            .product-price {
                font-size: 1.4rem;
                font-weight: 700;
                color: var(--primary-color);
            }

            .product-price:before {
                content: 'RM';
                font-size: 1rem;
                margin-right: 3px;
                color: var(--accent-color);
            }

            .product-description {
                color: var(--secondary-color);
                line-height: 1.5;
                font-size: 0.95rem;
                margin: 15px 0;
            }

            .product-stock {
                color: var(--secondary-color);
                font-size: 0.9rem;
                margin-bottom: 15px;
            }

            .add-to-cart-form {
                display: flex;
                gap: 10px;
                align-items: center;
                margin-top: 20px;
            }

            .quantity-input {
                width: 70px;
                padding: 8px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 0.9rem;
            }

            .add-to-cart-btn {
                background: var(--primary-color);
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9rem;
                transition: background 0.2s;
                flex-grow: 1;
            }

            .add-to-cart-btn:hover {
                background: var(--secondary-color);
            }

            .back-link {
                display: inline-block;
                margin-top: 15px;
                color: var(--accent-color);
                text-decoration: none;
                font-size: 0.9rem;
                padding-left: 220px;
            }

            .back-link i {
                margin-right: 5px;
            }
            
            footer {
                flex-shrink: 0;
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

            @media (max-width: 600px) {
                .compact-container {
                    margin: 15px auto;
                    padding: 0 15px;
                }

                .compact-card {
                    width: 100%;
                }

                .product-image {
                    max-height: 200px;
                }

                .add-to-cart-form {
                    flex-direction: column;
                    align-items: stretch;
                }

                .quantity-input {
                    width: 100%;
                }

                .back-link {
                    padding-left: 0;
                    text-align: center;
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <div class="compact-container">
                <%
                    String pid = request.getParameter("id");
                    if (pid != null) {
                        EntityManagerFactory emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
                        EntityManager em = emf.createEntityManager();
            
                        Product product = em.find(Product.class, pid);
            
                        if (product != null) {
                            Category category = em.find(Category.class, product.getCategoryId().getCategoryId());
                %>
                <h1 style="padding-left:180px; font-style: oblique; font-variant: small-caps;">Product(<%= product.getProductId() %>)</h1>
                <div class="compact-card">
                    <div class="product-image-container">
                        <img src="<%= request.getContextPath() %>/GetProductDetails?id=<%= product.getProductId() %>" 
                             class="product-image" 
                             alt="<%= product.getProductName() %>" />
                    </div>

                    <div class="product-info">
                        <h1 class="product-title"><%= product.getProductName() %></h1>

                        <div class="product-meta">
                            <span class="product-category"><%= category.getCategoryName() %></span>
                            <span class="product-price"><%= String.format("%.2f", product.getPrice()) %></span>
                        </div>

                        <p class="product-description"><%= product.getProductDescription() %></p>

                        <div class="product-stock">
                            <i class="fas fa-box-open"></i>
                            <span>In Stock: <%= product.getQuantity() %></span>
                        </div>

                        <form action="../AddToCartServlet" method="post" class="add-to-cart-form">
                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                            <input type="number" 
                                   name="quantity" 
                                   min="1" 
                                   max="<%= product.getQuantity() %>" 
                                   value="1" 
                                   class="quantity-input" 
                                   required>
                            <button type="submit" class="add-to-cart-btn">
                                <i class="fas fa-cart-plus"></i> Add to Cart
                            </button>
                        </form>

                        <a href="../Product.jsp" class="back-link">
                            <i class="fas fa-arrow-left"></i> Back to Products
                        </a>
                    </div>
                </div>
                <%
                        } else {
                %>
                <div style="text-align: center; padding: 30px 0;">
                    <i class="fas fa-exclamation-circle" style="color: var(--accent-color);"></i>
                    <h3>Product Not Found</h3>
                    <p>The requested product could not be found.</p>
                    <a href="../Product.jsp" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Products
                    </a>
                </div>
                <%
                        }
                        em.close();
                        emf.close();
                    } else {
                %>
                <div style="text-align: center; padding: 30px 0;">
                    <i class="fas fa-exclamation-triangle" style="color: var(--accent-color);"></i>
                    <h3>No Product Selected</h3>
                    <p>Please select a product to view details.</p>
                    <a href="../Product.jsp" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Products
                    </a>
                </div>
                <%
                    }
                %>
            </div>
            <!-- Footer -->
            <footer>
                ${copyright}
                | Contact us: <a href="mailto:${companyEmail}">${companyEmail}</a>
            </footer>
        </div>
    </body>
</html>