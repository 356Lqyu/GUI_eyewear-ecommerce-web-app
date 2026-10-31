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

@WebServlet("/RemoveCartItemServlet")
@Transactional
public class RemoveCartItemServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        String originPage = request.getParameter("originPage");
        
        Cartitem item = em.find(Cartitem.class, cartItemId);
        if (item != null) {
            em.remove(item);
        }

        if ("checkout".equals(originPage)) {
            response.sendRedirect(request.getContextPath() + "/secureCustomer/Checkout.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/secureCustomer/Cart.jsp");
        }
    }
}