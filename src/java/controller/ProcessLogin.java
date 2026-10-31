package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.UserService;
import model.Users;
import jakarta.ejb.EJB;

@WebServlet("/ProcessLogin")
public class ProcessLogin extends HttpServlet {

    @EJB
    private UserService userService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Users user = userService.validateUser(username, password);
            if (user == null) {
                throw new ServletException("Invalid username or password");
            }

            if (!"customer".equalsIgnoreCase(user.getRole())) {
                throw new ServletException("Only for customer login! Management personnel should use management login.");
            }

            // Invalidate old session if exists
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Then create new session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("ic", user.getIc());
            session.setMaxInactiveInterval(30 * 60);

            try {
                request.login(username, password);
            } catch (ServletException e) {
                System.out.println("Login failed: " + e.getMessage());
            }

            // If username and password valid , redirect to customer dashboard
            response.sendRedirect(request.getContextPath() + "/secureCustomer/CustomerDashboard.jsp");

        } catch (Exception e) {
            request.setAttribute("error", "Fail to login - " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("CustomerLogin.jsp");
            dispatcher.forward(request, response);
        }
    }
}
