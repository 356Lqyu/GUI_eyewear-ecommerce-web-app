package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.*;

@WebServlet("/ModifyCategoryServlet")
public class ModifyCategoryServlet extends HttpServlet {

    @EJB
    private CategoryService categoryService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String categoryId = request.getParameter("categoryId");
            Category category = categoryService.findCategoryById(categoryId);

            if (category == null) {
                throw new ServletException("Category not found.");
            }

            category.setCategoryName(request.getParameter("categoryName"));
            categoryService.updateCategory(category);

            session.setAttribute("successMessage", "Category " + category.getCategoryName() + " successfully updated!");
            response.sendRedirect(request.getContextPath() + "/ListCategoryServlet");

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating category: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ListCategoryServlet");
        }
    }
}
