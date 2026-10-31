/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.*;
import jakarta.ejb.EJB;
import java.io.*;
import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import model.Users;
import jakarta.transaction.Transactional;  
import java.io.IOException;
import java.util.List;

@WebServlet("/AddToCartServlet")
@Transactional  // Add this annotation to ensure transaction management
public class AddToCartServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // Get the cart for the user (create if doesn't exist)
        Cart cart = getOrCreateCartForUser(user);

        // Retrieve product ID and quantity from the request
        String productId = request.getParameter("productId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Find the product from the database
        Product product = findProductById(productId);
        if (product == null) {
            response.sendError(404, "Product not found.");
            return;
        }

        // Add the product to the cart
        try {
            addProductToCart(cart, product, quantity);

            List<Cartitem> cartItems = em.createQuery(
                    "SELECT ci FROM Cartitem ci WHERE ci.cart.cartId = :cartId", Cartitem.class)
                    .setParameter("cartId", cart.getCartId())
                    .getResultList();
            session.setAttribute("cartItems", cartItems);

            response.sendRedirect(request.getContextPath() + "/Product.jsp");
        } catch (Exception e) {
            response.sendError(500, "Error adding item to cart: " + e.getMessage());
        }
    }

    // Get or create a cart for the user
    private Cart getOrCreateCartForUser(Users user) {
        String userId = user.getUserId();

        // Check if the user already has a cart
        Cart cart = em.createQuery("SELECT c FROM Cart c WHERE c.user.userId = :userId AND c.status = 'IN_CART'", Cart.class)
                .setParameter("userId", userId)
                .getResultStream()
                .findFirst()
                .orElse(null);

        // If no cart exists, create a new one
        if (cart == null) {
            String newCartId = generateNewCartId();
            cart = new Cart();
            cart.setCartId(newCartId);
            cart.setUser(user);
            cart.setStatus("IN_CART");
            em.persist(cart);  // The persist operation will now be within a transaction
        }

        return cart;
    }

    // Generate a new cart ID
    private String generateNewCartId() {
        String maxId = em.createQuery("SELECT MAX(c.cartId) FROM Cart c", String.class)
                .getSingleResult();
        int nextIdNumber = 1;

        if (maxId != null && maxId.startsWith("CA")) {
            try {
                nextIdNumber = Integer.parseInt(maxId.substring(2)) + 1;
            } catch (NumberFormatException e) {
                // Log error
            }
        }
        return String.format("CA%04d", nextIdNumber);
    }

    // Add a product to the user's cart
    private void addProductToCart(Cart cart, Product product, int quantity) {
        // Check if the product already exists in the cart
        Cartitem existingItem = em.createQuery("SELECT ci FROM Cartitem ci WHERE ci.cart.cartId = :cartId AND ci.product.productId = :productId", Cartitem.class)
                .setParameter("cartId", cart.getCartId())
                .setParameter("productId", product.getProductId())
                .getResultStream()
                .findFirst()
                .orElse(null);

        if (existingItem != null) {
            // If the item already exists, update the quantity
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            em.merge(existingItem);  // The merge operation will now be within a transaction
        } else {
            // If the item doesn't exist, create a new cart item
            Cartitem cartItem = new Cartitem();
            cartItem.setCart(cart);
            cartItem.setProduct(product);
            cartItem.setQuantity(quantity);
            cartItem.setPrice(product.getPrice());
            em.persist(cartItem);  // The persist operation will now be within a transaction
        }
    }

    // Helper method to find a product by ID
    private Product findProductById(String productId) {
        try {
            return em.find(Product.class, productId);
        } catch (Exception e) {
            return null;
        }
    }
}