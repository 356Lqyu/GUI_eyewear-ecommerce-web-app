/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.*;
import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.transaction.Transactional;
import java.io.IOException;
import java.util.Date;
import java.sql.Timestamp;
import java.util.List;
import model.Users;

@WebServlet("/CheckoutServlet")
@Transactional
public class CheckoutServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp");
            return;
        }

        try {
            // Fetch the active cart for the user
            Cart cart = em.createQuery(
                    "SELECT c FROM Cart c WHERE c.user.userId = :userId AND c.status = 'IN_CART'", Cart.class)
                    .setParameter("userId", user.getUserId())
                    .getSingleResult();

            // Calculate totals
            List<Cartitem> cartItems = cart.getItems();
            double subtotal = 0.0;
            for (Cartitem item : cartItems) {
                subtotal += item.getQuantity() * item.getPrice();
            }
            
            double deliveryFee = (subtotal < 1000) ? 25.0 : 0.0;
            double salesTax = subtotal * 0.06; // 6% sales tax
            double totalPrice = subtotal + deliveryFee + salesTax;

            // Update cart status to ORDERED
            cart.setStatus("ORDERED");
            em.merge(cart);

            // Store values in session for confirmation
            session.setAttribute("orderedCartItems", cartItems);
            session.setAttribute("checkoutSubtotal", subtotal);
            session.setAttribute("checkoutDeliveryFee", deliveryFee);
            session.setAttribute("checkoutSalesTax", salesTax);
            session.setAttribute("checkoutTotalPrice", totalPrice);

            response.sendRedirect(request.getContextPath() + "/secureCustomer/Checkout.jsp");
        } catch (NoResultException e) {
            response.sendError(400, "No active cart found for checkout.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error during checkout: " + e.getMessage());
        }
    }
}