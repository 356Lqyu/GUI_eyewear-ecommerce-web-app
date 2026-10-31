package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import model.*;

@WebServlet("/ModifyProductServlet")
@MultipartConfig(maxFileSize = 16177215) 
public class ModifyProductServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @EJB
    private CategoryService categoryService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String productId = request.getParameter("productId");
            Product product = productService.findProductById(productId);

            if (product == null) {
                throw new ServletException("Product not found.");
            }

            // Update basic fields
            product.setProductName(request.getParameter("productName"));
            product.setProductDescription(request.getParameter("productDescription"));
            product.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            product.setPrice(Double.parseDouble(request.getParameter("price")));

            // Update category
            String categoryId = request.getParameter("categoryId");
            Category category = categoryService.findCategoryById(categoryId);
            if (category == null) {
                throw new ServletException("Category not found.");
            }
            product.setCategoryId(category);

            // Handle image upload
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream inputStream = filePart.getInputStream()) {
                    byte[] imageBytes = inputStream.readAllBytes();
                    product.setImage(imageBytes);
                }
            }
            // Do nothing if user did not upload any image and remain existing image in DB

            productService.updateProduct(product);

            session.setAttribute("successMessage", "Product " + product.getProductName() + " successfully updated!");
            response.sendRedirect(request.getContextPath() + "/ListProductServlet");

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating product: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ListProductServlet");
        }
    }
}
