package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.UserService;
import model.Users;

@WebServlet("/PasswordRecovery")
public class PasswordRecovery extends HttpServlet {

    @EJB
    private UserService userService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String securityAnswer = request.getParameter("securityAnswer");

        try {
            Users user = userService.findUserByUsername(username);

            if (user == null) {
                request.setAttribute("error", "Username not found! Please try again.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
                return;
            }

            // User needs to enter their username, then will display corresponding security question
            // They need to enter their security answer, and if valid, their password will be displayed
            if (securityAnswer == null || securityAnswer.trim().isEmpty()) {
                request.setAttribute("username", username);
                request.setAttribute("securityQuestion", user.getSecurityQuestion());
                request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
                return;
            }

            // Validate security answer
            if (!user.getSecurityAnswer().equalsIgnoreCase(securityAnswer.trim())) {
                request.setAttribute("error", "Incorrect security answer");
                request.setAttribute("username", username);
                request.setAttribute("securityQuestion", user.getSecurityQuestion());
                request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
                return;
            }

            // Show password if validation successfully
            request.setAttribute("username", username);
            request.setAttribute("securityQuestion", user.getSecurityQuestion());
            request.setAttribute("password", user.getPassword());
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Fail to recovery password - " + e.getMessage());
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        }
    }
}
