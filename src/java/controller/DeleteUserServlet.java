package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.UserService;
import model.Users;

@WebServlet("/secureManager/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userId = request.getParameter("id");
        String type = request.getParameter("type"); // Get role to delete (staff or customer)

        try {
            if (userId == null || userId.isEmpty()) {
                throw new ServletException("User ID is required");
            }

            userService.deleteUser(userId);

            // Check if role = staff , then delete staff and go back to ManageSatff
            // Check if role = customer , then delete customer and go back to ManageCustomer
            if ("staff".equals(type)) {
                session.setAttribute("successMessage", "Staff " + userId + " deleted successfully!");
                response.sendRedirect("ListUserServlet?type=staff");
            } else if ("customer".equals(type)) {
                session.setAttribute("successMessage", "Customer " + userId + " deleted successfully!");
                response.sendRedirect("ListUserServlet?type=customer");
            } else {
                throw new ServletException("Invalid user type specified");
            }
        } catch (Exception ex) {
            if ("staff".equals(type)) {
                session.setAttribute("errorMessage", "Fail to delete staff - " + ex.getMessage());
                response.sendRedirect("ListUserServlet?type=staff");
            } else if ("customer".equals(type)) {
                session.setAttribute("errorMessage", "Fail to delete customer - " + ex.getMessage());
                response.sendRedirect("ListUserServlet?type=customer");
            } else {
                session.setAttribute("errorMessage", "Error -" + ex.getMessage());
                response.sendRedirect("../secureManager/ManagerDashboard.html");
            }
        }
    }
}
