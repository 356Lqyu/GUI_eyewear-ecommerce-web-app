/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import model.*;
import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.transaction.UserTransaction;
import javax.naming.InitialContext;

@WebServlet("/AddProduct")
@MultipartConfig(maxFileSize = 16177215)
public class AddProduct extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;
    
    private UserTransaction userTransaction;

    @Override
    public void init() throws ServletException {
        try {
            // Look up the UserTransaction
            InitialContext ic = new InitialContext();
            userTransaction = (UserTransaction) ic.lookup("java:comp/UserTransaction");
        } catch (Exception e) {
            throw new ServletException("Failed to initialize UserTransaction", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        
        String productId = request.getParameter("product_id");
        String name = request.getParameter("product_name");
        String description = request.getParameter("product_description");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));
        String categoryId = request.getParameter("category_id");

        Part imagePart = request.getPart("image");
        InputStream imageStream = imagePart.getInputStream();
        byte[] imageBytes = imageStream.readAllBytes();

        try {
            // Begin transaction
            userTransaction.begin();

            // Find the category by ID
            Category category = em.find(Category.class, categoryId);
            if (category == null) {
                throw new Exception("Category not found!");
            }

            // Create new product
            Product product = new Product();
            product.setProductId(productId);
            product.setProductName(name);
            product.setProductDescription(description);
            product.setQuantity(quantity);
            product.setPrice(price);
            product.setImage(imageBytes);
            product.setCategoryId(category);

            em.persist(product);
            
            // Commit transaction
            userTransaction.commit();

            session.setAttribute("successMessage", "Product" +  product.getProductName() + " added successfully!");
            response.sendRedirect(request.getContextPath() + "/secureStaff/ManageProduct.jsp");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid number format for quantity or price");
            response.sendRedirect(request.getContextPath() + "/secureStaff/AddProduct.jsp");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error adding product: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/secureStaff/AddProduct.jsp");
        }
    }
}