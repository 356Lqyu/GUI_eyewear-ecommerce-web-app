package controller;

import model.*;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/secureStaff/ViewProductServlet")
public class ViewProductServlet extends HttpServlet {
    @EJB
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String contextPath = request.getContextPath();

        try {
            String productId = request.getParameter("productId");

            if (productId == null || productId.isEmpty()) {
                session.setAttribute("errorMessage", "Invalid product ID");
                response.sendRedirect(contextPath + "/ListProductServlet");
                return;
            }

            Product product = productService.findProductById(productId);

            if (product == null) {
                session.setAttribute("errorMessage", "Product not found");
                response.sendRedirect(contextPath + "/ListProductServlet");
                return;
            }

            request.setAttribute("productToModify", product);
            request.getRequestDispatcher("/secureStaff/ModifyProduct.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error retrieving product details: " + e.getMessage());
            response.sendRedirect(contextPath + "/ListProductServlet");
        }
    }
}