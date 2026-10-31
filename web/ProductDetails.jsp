<%@ page import="jakarta.persistence.*, model.*, java.util.*, java.text.SimpleDateFormat, java.net.URLEncoder" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // product details page will be displayed in home (guests) and customer dashboard
    // so need to retrieve user object for session ( guests or customer)
    Users user = (Users) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "guest";
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Details</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            :root {
                --primary-color: #333333;
                --secondary-color: #555555;
                --accent-color: #888888;
                --light-color: #f1f1f1;
                --star-color: #FFD700;
            }

            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: var(--light-color);
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                overscroll-behavior: none;
            }

            .main-container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0px 10px;
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

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid var(--light-gray);
            }

            .page-title {
                margin: 0;
                color: var(--primary-color);
                font-size: 28px;
                font-weight: 700;
                font-variant: small-caps;
            }

            .continue-shopping {
                display: inline-flex;
                align-items: center;
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s;
                padding: 8px 16px;
                border-radius: 6px;
                background-color: #f5f5f5;
            }

            .continue-shopping:hover {
                color: var(--accent-color);
                background-color: #e0e0e0;
            }

            .continue-shopping svg {
                margin-right: 8px;
            }

            .product-container {
                display: flex;
                flex-wrap: wrap;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                overflow: hidden;
                margin-bottom: 30px;
                width: 1200px;
            }

            .image-section {
                flex: 1;
                min-width: 300px;
                padding: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: white;
            }

            .product-image {
                max-width: 100%;
                max-height: 400px;
                object-fit: contain;
                border-radius: 5px;
            }

            .details-section {
                flex: 1;
                min-width: 300px;
                padding: 30px;
                border-left: 1px solid #eee;
            }

            .product-title {
                font-size: 1.8rem;
                color: var(--primary-color);
                margin: 0 0 15px 0;
                font-weight: 600;
            }

            .product-meta {
                display: flex;
                justify-content: space-between;
                margin-bottom: 20px;
                align-items: center;
            }

            .product-category {
                background: var(--primary-color);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.9rem;
            }

            .product-price {
                font-size: 1.6rem;
                font-weight: 700;
                color: var(--primary-color);
            }

            .product-price:before {
                content: 'RM';
                font-size: 1.2rem;
                margin-right: 5px;
                color: var(--accent-color);
            }

            .product-description {
                color: var(--secondary-color);
                line-height: 1.6;
                font-size: 1rem;
                margin: 20px 0;
            }

            .product-stock {
                color: var(--secondary-color);
                font-size: 1rem;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .action-links {
                display: flex;
                justify-content: flex-end;
                margin-top: 30px;
                flex-wrap: wrap;
                gap: 15px;
            }

            .action-link {
                display: inline-flex;
                align-items: center;
                color: var(--accent-color);
                text-decoration: none;
                font-size: 0.95rem;
                padding: 10px 20px;
                border-radius: 5px;
                transition: all 0.2s;
            }

            .action-link:hover {
                background-color: #f5f5f5;
            }

            .action-link i {
                margin-right: 8px;
            }

            .add-to-cart-link {
                margin-top: 160px;
                background: var(--primary-color);
                color: white;
            }

            .add-to-cart-link:hover {
                background: var(--secondary-color);
                color: white;
            }

            .rate-product-link {
                background: grey;
                color: white;
            }

            .rate-product-link:hover {
                background: #e6c200;
                color: white;
            }

            /* Ratings Section Styles */
            .ratings-section {
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                padding: 30px;
                margin-top: 20px;
            }

            .ratings-title {
                font-size: 1.5rem;
                color: var(--primary-color);
                margin: 0 0 20px 0;
                font-weight: 600;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
                display: flex;
                align-items: center;
            }

            .ratings-title i {
                color: var(--star-color);
                margin-right: 10px;
            }

            .rating-summary {
                text-align: center;
                margin-bottom: 30px;
                padding: 20px;
                background: #f9f9f9;
                border-radius: 8px;
            }

            .average-rating {
                font-size: 2.5rem;
                color: var(--star-color);
                font-weight: 700;
                margin-bottom: 5px;
            }

            .rating-count {
                color: var(--accent-color);
                font-size: 1rem;
                margin-bottom: 15px;
            }

            .rating-card {
                background: #f9f9f9;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 15px;
            }

            .rating-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }

            .rating-stars {
                color: var(--star-color);
                font-size: 1rem;
            }

            .rating-user {
                font-weight: 600;
                color: var(--primary-color);
                margin-right: 10px;
            }

            .rating-date {
                font-size: 0.8rem;
                color: var(--accent-color);
            }

            .rating-comment {
                color: var(--secondary-color);
                line-height: 1.5;
                margin-top: 10px;
            }

            .no-ratings {
                color: var(--accent-color);
                font-style: italic;
                text-align: center;
                padding: 30px;
            }

            .rate-product-btn {
                text-align: center;
                margin-top: 20px;
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

            @media (max-width: 768px) {
                .product-container {
                    flex-direction: column;
                }

                .details-section {
                    border-left: none;
                    border-top: 1px solid #eee;
                }

                .image-section {
                    padding: 20px;
                }

                .details-section {
                    padding: 20px;
                }

                .product-title {
                    font-size: 1.5rem;
                }

                .page-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="main-container">
            <%
                String pid = request.getParameter("id");
                if (pid != null) {
                    EntityManagerFactory emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
                    EntityManager em = emf.createEntityManager();
        
                    Product product = em.find(Product.class, pid);
        
                    if (product != null) {
                        Category category = em.find(Category.class, product.getCategoryId().getCategoryId());
            %>
            <div class="page-header">
                <h1 class="page-title">Product (<%= product.getProductId() %>)</h1>
                <a href="Product.jsp" class="continue-shopping">
                    <i class="fas fa-arrow-left"></i> &nbsp; Back to Products
                </a>
            </div>

            <div class="product-container">
                <div class="image-section">
                    <img src="<%= request.getContextPath() %>/GetProductDetails?id=<%= product.getProductId() %>" 
                         class="product-image" 
                         alt="<%= product.getProductName() %>" />
                </div>

                <div class="details-section">
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

                    <div class="action-links">
                        <% if (role.equals("customer")) { %>
                        <a href="secureCustomer/AddToCart.jsp?id=<%= product.getProductId() %>" class="action-link add-to-cart-link">
                            <i class="fas fa-cart-plus"></i> Add To Cart
                        </a>
                        <% } else { %>
                        <a href="LoginRequest.jsp" class="action-link add-to-cart-link">
                            <i class="fas fa-cart-plus"></i> Add To Cart
                        </a>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="ratings-section">
                <h2 class="ratings-title">
                    <i class="fas fa-star"></i>
                    Customer Reviews
                </h2>

                <%
                    // Get ratings for this product
                    TypedQuery<Rating> ratingQuery = em.createQuery(
                        "SELECT r FROM Rating r WHERE r.product.productId = :productId ORDER BY r.ratingDate DESC", 
                        Rating.class
                    );
                    ratingQuery.setParameter("productId", product.getProductId());
                    List<Rating> ratings = ratingQuery.getResultList();

                    if (ratings.isEmpty()) {
                %>
                <div class="no-ratings">
                    <i class="fas fa-comments" style="font-size: 2rem; margin-bottom: 15px;"></i>
                    <p>No comments yet. Be first to review this product!</p>
                </div>
                <%
                    } else {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");

                        // Calculate average rating
                        double avgRating = 0;
                        for (Rating r : ratings) {
                            avgRating += r.getRatingValue();
                        }
                        avgRating = avgRating / ratings.size();
                %>
                <div class="rating-summary">
                    <div class="average-rating"><%= String.format("%.1f", avgRating) %></div>
                    <div class="rating-stars">
                        <%
                            int fullStars = (int) avgRating;
                            boolean hasHalfStar = (avgRating - fullStars) >= 0.5;
                            
                            for (int i = 1; i <= 5; i++) {
                                if (i <= fullStars) {
                        %>
                        <i class="fas fa-star"></i>
                        <%
                                } else if (i == fullStars + 1 && hasHalfStar) {
                        %>
                        <i class="fas fa-star-half-alt"></i>
                        <%
                                } else {
                        %>
                        <i class="far fa-star"></i>
                        <%
                                }
                            }
                        %>
                    </div>
                    <div class="rating-count">Based on <%= ratings.size() %> review<%= ratings.size() != 1 ? "s" : "" %></div>
                </div>

                <%
                        // Display individual ratings
                        for (Rating rating : ratings) {
                            Users ratingUser = rating.getUser();
                %>
                <div class="rating-card">
                    <div class="rating-header">
                        <div>
                            <span class="rating-user"><%= ratingUser != null ? ratingUser.getUsername() : "Anonymous" %></span>
                            <div class="rating-stars">
                                <%
                                    int ratingValue = rating.getRatingValue();
                                    for (int i = 1; i <= 5; i++) {
                                        if (i <= ratingValue) {
                                %>
                                <i class="fas fa-star"></i>
                                <%
                                        } else {
                                %>
                                <i class="far fa-star"></i>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>
                        <div class="rating-date"><%= dateFormat.format(rating.getRatingDate()) %></div>
                    </div>
                    <% if (rating.getComment() != null && !rating.getComment().trim().isEmpty()) { %>
                    <p class="rating-comment"><%= rating.getComment() %></p>
                    <% } %>
                </div>
                <%
                        }
                    }
                %>

                <% if (user != null && role.equals("customer")) { %>
                <div class="rate-product-btn">
                    <a href="${pageContext.request.contextPath}/secureCustomer/RateProduct.jsp?id=<%= product.getProductId() %>&name=<%= URLEncoder.encode(product.getProductName(), "UTF-8") %>" 
                       class="action-link rate-product-link">
                         Rate This Product
                    </a>
                </div>
                <% } else if (!role.equals("customer")) { %>
                <div style="text-align: center; margin-top: 20px; color: var(--accent-color);">
                    <p><i class="fas fa-info-circle"></i> Please login as a customer to rate this product</p>
                </div>
                <% } %>
            </div>
            <%
                    } else {
            %>
            <div style="text-align: center; padding: 30px 0;">
                <i class="fas fa-exclamation-circle" style="color: var(--accent-color);"></i>
                <h3>Product Not Found</h3>
                <p>The requested product could not be found.</p>
                <a href="Product.jsp" class="continue-shopping">
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
                <a href="Product.jsp" class="continue-shopping">
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
    </body>
</html>