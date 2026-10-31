package controller;

import model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ListCategoryServlet")
public class ListCategoryServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        try {
            List<Category> categoryList = em.createNamedQuery("Category.findAll", Category.class).getResultList();
            request.setAttribute("categoryList", categoryList);
            request.getRequestDispatcher("/secureStaff/ManageCategory.jsp").forward(request, response);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error retrieving categories: " + e.getMessage());
            response.sendRedirect("ManageCategory.jsp");
        }
    }
}
