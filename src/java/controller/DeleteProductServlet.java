package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.ProductService;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String productId = request.getParameter("id");

        try {
            if (productId == null || productId.isEmpty()) {
                throw new ServletException("Product ID is required");
            }

            productService.deleteProduct(productId);

            session.setAttribute("successMessage", "Product " + productId + " deleted successfully!");
            request.getRequestDispatcher("ListProductServlet").forward(request, response);
        } catch (Exception ex) {
            session.setAttribute("errorMessage", "Error deleting product: " + ex.getMessage());
            response.sendRedirect("ListProductServlet");
        }
    }
}
