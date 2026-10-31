package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.Category;
import model.CategoryService;

@WebServlet("/AddCategoryServlet")
public class AddCategoryServlet extends HttpServlet {

    @EJB
    private CategoryService categoryService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String categoryId = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");

        // Validation
        if (categoryId == null || categoryId.trim().isEmpty() ||
            categoryName == null || categoryName.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required.");
            response.sendRedirect(request.getContextPath() + "/secureStaff/AddCategory.jsp");
            return;
        }

        try {
            // Check if category name already exists
            if (categoryService.findByName(categoryName) != null) {
                session.setAttribute("errorMessage", "Category name already exists. Please choose a different name.");
                response.sendRedirect(request.getContextPath() + "/secureStaff/AddCategory.jsp");
                return;
            }

            // Create and save new category
            Category newCategory = new Category();
            newCategory.setCategoryId(categoryId);
            newCategory.setCategoryName(categoryName);

            categoryService.addCategory(newCategory);

            session.setAttribute("successMessage", "Category [" + categoryName + "] added successfully!");
            response.sendRedirect(request.getContextPath() + "/secureStaff/ManageCategory.jsp");

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error adding category: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/secureStaff/AddCategory.jsp");
            
        }
    }
}
