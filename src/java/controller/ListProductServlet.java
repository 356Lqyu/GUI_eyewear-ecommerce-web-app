package controller;

import model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ListProductServlet")
public class ListProductServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Product> productList = em.createNamedQuery("Product.findAll", Product.class).getResultList();
            request.setAttribute("productList", productList);
            request.getRequestDispatcher("/secureStaff/ManageProduct.jsp").forward(request, response);

        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Error retrieving products: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/secureStaff/ManageProduct.jsp");
        }
    }
}
