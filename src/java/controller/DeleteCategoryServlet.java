package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.CategoryService;

@WebServlet("/DeleteCategoryServlet")
public class DeleteCategoryServlet extends HttpServlet {

    @EJB
    private CategoryService categoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String categoryId = request.getParameter("id");

        try {
            if (categoryId == null || categoryId.isEmpty()) {
                throw new ServletException("Category ID is required");
            }

            categoryService.deleteCategory(categoryId);

            session.setAttribute("successMessage", "Category " + categoryId + " deleted successfully!");
            request.getRequestDispatcher("ListCategoryServlet").forward(request, response);
        } catch (Exception ex) {
            session.setAttribute("errorMessage", "Error deleting category: " + ex.getMessage());
            response.sendRedirect("ListCategoryServlet");
        }
    }
}
