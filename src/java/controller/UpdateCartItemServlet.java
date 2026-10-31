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

@WebServlet("/UpdateCartItemServlet")
@Transactional
public class UpdateCartItemServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the cart item and update its quantity and price
        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));
        String originPage = request.getParameter("originPage");

        // Find the CartItem by its ID
        Cartitem item = em.find(Cartitem.class, cartItemId);
        if (item != null) {
            // Update the quantity
            item.setQuantity(newQuantity);

            // Update the price based on the new quantity 
            double newPrice = item.getProduct().getPrice() * newQuantity; 
            item.setPrice(newPrice);  // Set the updated price

            // Merge the updated CartItem entity
            em.merge(item);
        }

        if ("checkout".equals(originPage)) {
            response.sendRedirect(request.getContextPath() + "/secureCustomer/Checkout.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/secureCustomer/Cart.jsp");
        }
    }
}