package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Product;
import model.ProductService;

@WebServlet("/GetProductImageServlet")
public class GetProductImageServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("productId");
        Product product = productService.findProductById(productId);

        if (product != null && product.getImage() != null) {
            response.setContentType("image/jpeg");
            response.getOutputStream().write(product.getImage());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
