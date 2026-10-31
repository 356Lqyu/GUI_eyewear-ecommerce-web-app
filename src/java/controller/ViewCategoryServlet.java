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

@WebServlet("/secureStaff/ViewCategoryServlet")
public class ViewCategoryServlet extends HttpServlet {
    @EJB
    private CategoryService categoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String contextPath = request.getContextPath();

        try {
            String categoryId = request.getParameter("categoryId");

            if (categoryId == null || categoryId.isEmpty()) {
                session.setAttribute("errorMessage", "Invalid category ID");
                response.sendRedirect(contextPath + "/ListCategoryServlet");
                return;
            }

            Category category = categoryService.findCategoryById(categoryId);

            if (category == null) {
                session.setAttribute("errorMessage", "Category not found");
                response.sendRedirect(contextPath + "/ListCategoryServlet");
                return;
            }

            request.setAttribute("categoryToModify", category);
            request.getRequestDispatcher("/secureStaff/ModifyCategory.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error retrieving category details: " + e.getMessage());
            response.sendRedirect(contextPath + "/ListCategoryServlet");
        }
    }
}
