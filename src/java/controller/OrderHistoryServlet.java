package controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.*;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp");
            return;
        }

        EntityManager em = emf.createEntityManager();

        try {
            List<Orders> orderList = em.createQuery(
                "SELECT o FROM Orders o WHERE o.user.userId = :userId ORDER BY o.orderDate DESC", Orders.class)
                .setParameter("userId", user.getUserId())
                .getResultList();

            request.setAttribute("orderList", orderList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/secureCustomer/OrderHistory.jsp");
            dispatcher.forward(request, response);

        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        emf.close();
    }
}