/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import jakarta.validation.ConstraintViolationException;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/ConfirmOrderServlet")
@Transactional
public class ConfirmOrderServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    // Generate unique Payment ID
    private String generateNewPaymentId() {
        String maxId = em.createQuery("SELECT MAX(c.paymentId) FROM Payment c", String.class)
                .getSingleResult();
        int nextIdNumber = 1;

        if (maxId != null && maxId.startsWith("PM")) {
            try {
                nextIdNumber = Integer.parseInt(maxId.substring(2)) + 1;
            } catch (NumberFormatException e) {
                // handle error if needed
            }
        }
        return String.format("PM%04d", nextIdNumber);
    }

    // Generate unique Order ID
    private String generateNewOrderId() {
        String maxId = em.createQuery("SELECT MAX(o.orderId) FROM Orders o", String.class)
                .getSingleResult();
        int nextIdNumber = 1;

        if (maxId != null && maxId.startsWith("OD")) {
            try {
                nextIdNumber = Integer.parseInt(maxId.substring(2)) + 1;
            } catch (NumberFormatException e) {
                // handle error if needed
            }
        }
        return String.format("OD%04d", nextIdNumber);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp");
            return;
        }
        
        try {
            // Retrieve cart and payment details
            Cart cart = em.createQuery(
                    "SELECT c FROM Cart c WHERE c.user.userId = :userId AND c.status = 'ORDERED'", Cart.class)
                    .setParameter("userId", user.getUserId())
                    .getSingleResult();

            // Create payment
            Payment payment = new Payment();
            payment.setPaymentId(generateNewPaymentId());
            payment.setPaymentMethod(request.getParameter("paymentMethod"));
            payment.setShippingAddress(request.getParameter("shippingAddress"));
            
            // Set payment amounts from session
            payment.setPaymentAmount((Double) session.getAttribute("checkoutSubtotal"));
            payment.setDeliveryFees((Double) session.getAttribute("checkoutDeliveryFee"));
            payment.setSalesTax((Double) session.getAttribute("checkoutSalesTax"));
            payment.setTotalAmount((Double) session.getAttribute("checkoutTotalPrice"));
            payment.setStatus("PAID");
            
            // Handle payment method specific fields
            if ("CreditCard".equals(payment.getPaymentMethod())) {
                payment.setCardNumber(request.getParameter("cardNumber"));
                payment.setExpiry(request.getParameter("expiry"));
                payment.setCvv(request.getParameter("cvv"));
                payment.setCardType(request.getParameter("cardType"));
            } else if ("EWallet".equals(payment.getPaymentMethod())) {
                payment.setPhoneNumber(request.getParameter("phoneNumber"));
                payment.setEwalletType(request.getParameter("ewalletType"));
            }
            
            // Create order
            Orders order = new Orders();
            order.setOrderId(generateNewOrderId());
            order.setUser(user);
            order.setCart(cart);
            order.setShippingAddress(request.getParameter("shippingAddress"));
            order.setStatus("CONFIRMED");
            order.setTotalAmount(payment.getTotalAmount());
            
            // Link payment to order
            payment.setOrder(order);
            
            // Persist entities
            em.persist(payment);
            em.persist(order);
            
            // Update cart status
            cart.setStatus("CHECKED_OUT");
            em.merge(cart);
            
            // Set success attributes
            request.setAttribute("orderId", order.getOrderId());
            request.setAttribute("paymentId", payment.getPaymentId());
            request.setAttribute("totalAmount", order.getTotalAmount());
            request.setAttribute("shippingAddress", order.getShippingAddress());
            request.setAttribute("paymentDate", payment.getPaymentDate());
            request.setAttribute("orderDate", order.getOrderDate());
            request.setAttribute("paymentMethod", payment.getPaymentMethod());
            
            // Clear session attributes
            session.removeAttribute("orderedCartItems");
            session.removeAttribute("checkoutSubtotal");
            session.removeAttribute("checkoutDeliveryFee");
            session.removeAttribute("checkoutSalesTax");
            session.removeAttribute("checkoutTotalPrice");
            
            // Forward to success page
            request.getRequestDispatcher("/secureCustomer/OrderSuccess.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error confirming order: " + e.getMessage());
        }
    }
}