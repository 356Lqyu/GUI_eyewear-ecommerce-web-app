package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.*;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    @EJB
    private UserService userService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("../CustomerLogin.html");
            return;
        }

        try {
            // Get new password and confirm password
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword == null || newPassword.isEmpty()) {
                session.setAttribute("passwordError", "Please enter your new password!");
                throw new ServletException("Please enter your new password!");
            }

            if (confirmPassword == null || confirmPassword.isEmpty()) {
                session.setAttribute("passwordError", "Please enter your confirm password!");
                throw new ServletException("Please enter your confirm password!");
            }

            // Check whether new password matches with confirm password or not
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("passwordError", "New passwords do not match!");
                throw new ServletException("New passwords do not match!");
            }

            // Set password length should at least 8
            if (newPassword.length() < 8) {
                session.setAttribute("passwordError", "Password must be at least 8 characters!");
                throw new ServletException("Password must be at least 8 characters!");
            }

            // If valid then update customer password (reset password only for customer)
            currentUser.setPassword(newPassword);
            userService.updateUser(currentUser);

            session.setAttribute("user", currentUser);
            session.setAttribute("successMessage", "Your password has been successfully reset!");

            //Redirect to customer profile
            response.sendRedirect("secureCustomer/UserProfile.jsp");

        } catch (Exception ex) {
            session.setAttribute("errorMessage", "Fail to reset password!  " + ex.getMessage());
            response.sendRedirect("secureCustomer/ResetPassword.jsp");
        }
    }
}
