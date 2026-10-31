<%@ page import="model.*" %>
<%@ page import="java.util.*, jakarta.servlet.http.HttpSession, java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Initialize variables
    String message = "";
    String productId = request.getParameter("id");
    String productName = request.getParameter("name");

    // Validate required parameters
    if (productId == null || productName == null) {
        response.sendRedirect("../Product.jsp?error=missing_parameters");
        return;
    }

    // Check user session
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp?redirect=secureCustomer/RateProduct.jsp?id=" + 
                            URLEncoder.encode(productId, "UTF-8") + "&name=" + 
                            URLEncoder.encode(productName, "UTF-8"));
        return;
    }

    // Process form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int ratingValue = 0;
            try {
                ratingValue = Integer.parseInt(request.getParameter("ratingValue"));
            } catch (NumberFormatException e) {
                message = "Please select a valid rating (1-5)";
            }

            String comment = request.getParameter("comment") != null ? request.getParameter("comment") : "";

            if (ratingValue < 1 || ratingValue > 5) {
                message = "Rating must be between 1 and 5 stars";
            } else {
                try {
                    javax.naming.Context ctx = new javax.naming.InitialContext();
                    RatingService ratingService = (RatingService) ctx.lookup("java:app/FourEyesCollective/RatingService");
                    ratingService.submitRating(productId, user.getUserId(), ratingValue, comment);

                    response.sendRedirect(request.getContextPath() + "/ProductDetails.jsp?id=" + productId + "&rated=1");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    message = "Failed to submit your rating. Please try again later.";
                    if (e.getMessage() != null && e.getMessage().contains("not found")) {
                        message = e.getMessage();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Failed to submit rating: " + 
                      (e.getMessage() != null ? e.getMessage() : "An unexpected error occurred. Please try again.");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Rate <%= productName %></title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            :root {
                --primary-color: #333333;
                --secondary-color: #555555;
                --accent-color: #888888;
                --light-color: #f1f1f1;
                --star-color: #FFD700;
                --error-color: #dc3545;
                --success-color: #28a745;
            }

            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: var(--light-color);
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .main-container {
                max-width: 800px;
                margin: 30px auto;
                padding: 0 20px;
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
                border-bottom: 1px solid #eee;
                padding-top: 50px;
            }

            .page-title {
                margin: 0;
                color: var(--primary-color);
                font-size: 28px;
                font-weight: 700;
            }

            .back-link {
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

            .back-link:hover {
                color: var(--accent-color);
                background-color: #e0e0e0;
            }

            .back-link i {
                margin-right: 8px;
            }

            .rating-form-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                padding: 30px;
                margin-bottom: 30px;
                width: 700px;
            }

            .form-title {
                color: var(--primary-color);
                font-size: 1.5rem;
                margin: 0 0 20px 0;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .form-title i {
                color: var(--star-color);
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: var(--secondary-color);
            }

            .rating-stars-select {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .rating-stars-select select {
                padding: 10px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 1rem;
                min-width: 100px;
            }

            .star-preview {
                color: var(--star-color);
                font-size: 1.2rem;
            }

            .form-textarea {
                width: 95%;
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 1rem;
                min-height: 120px;
                resize: vertical;
            }

            .form-textarea:focus {
                border-color: var(--primary-color);
                outline: none;
                box-shadow: 0 0 0 2px rgba(51, 51, 51, 0.2);
            }

            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 5px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                border: none;
            }

            .btn-submit {
                background: #5a6268;
                color: white;
            }

            .btn-submit:hover {
                background: lightgrey;
                transform: translateY(-2px);
            }

            .btn-cancel {
                background: white;
                color: black;
                text-decoration: none;
                box-shadow: 1px 1px 1px 1px grey;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-cancel:hover {
                background: lightgrey;
                transform: translateY(-2px);
            }

            .message {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .error-message {
                background-color: #f8d7da;
                color: var(--error-color);
            }

            .success-message {
                background-color: #d4edda;
                color: var(--success-color);
            }

            .message-icon {
                font-size: 20px;
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
                .page-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }

                .form-actions {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }
        </style>
        <script>
            function updateStarPreview() {
                const ratingValue = document.getElementById('ratingValue').value;
                const starPreview = document.getElementById('starPreview');

                starPreview.innerHTML = '';
                for (let i = 0; i < 5; i++) {
                    const star = document.createElement('i');
                    star.className = i < ratingValue ? 'fas fa-star' : 'far fa-star';
                    starPreview.appendChild(star);
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                updateStarPreview();
                document.getElementById('ratingValue').addEventListener('change', updateStarPreview);
            });
        </script>
    </head>
    <body>
        <div class="main-container">
            <div class="page-header">
                <h1 class="page-title">Rate Product</h1>
                <a href="<%= request.getContextPath() %>/ProductDetails.jsp?id=<%= productId %>" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Product
                </a>
            </div>

            <div class="rating-form-container">
                <h2 class="form-title">
                    <i class="fas fa-star"></i>
                    <%= productName %>
                </h2>

                <% if (!message.isEmpty()) { %>
                <div class="message error-message">
                    <div class="message-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div>
                        <%= message %>
                    </div>
                </div>
                <% } %>

                <form method="post">
                    <input type="hidden" name="id" value="<%= productId %>">
                    <input type="hidden" name="name" value="<%= productName %>">

                    <div class="form-group">
                        <label for="ratingValue" class="form-label">Your Rating</label>
                        <div class="rating-stars-select">
                            <select name="ratingValue" id="ratingValue" required>
                                <option value="">Select rating</option>
                                <% for (int i = 1; i <= 5; i++) { %>
                                <option value="<%= i %>"><%= i %> star<%= i > 1 ? "s" : "" %></option>
                                <% } %>
                            </select>
                            <div class="star-preview" id="starPreview"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="comment" class="form-label">Your Review (optional)</label>
                        <textarea name="comment" id="comment" class="form-textarea" placeholder="Share your thoughts about this product..."></textarea>
                    </div>

                    <div class="form-actions">
                        <a href="<%= request.getContextPath() %>/ProductDetails.jsp?id=<%= productId %>" class="btn btn-cancel">Cancel</a>
                        <button type="submit" class="btn btn-submit">Submit Review</button>
                    </div>
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