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

@WebServlet("/secureManager/ViewStaffServlet")
public class ViewStaffServlet extends HttpServlet {

    @EJB
    private UserService userService;

    // Fetch specifc staff details for modification
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // Get the userId and fetch the staff details
            String userId = request.getParameter("userId");

            if (userId == null || userId.isEmpty()) {
                session.setAttribute("errorMessage", "Invalid staff ID! Please try again. ");
                response.sendRedirect("ListUserServlet");
                return;
            }

            Users staffUser = userService.findUserById(userId);
            Staff staffDetails = null;

            if (staffUser != null) {
                staffDetails = userService.findStaffById(userId);
                staffUser.setStaff(staffDetails);
            }

            if (staffUser == null || staffDetails == null) {
                session.setAttribute("errorMessage", "Staff not found! Please try again. ");
                response.sendRedirect("ListUserServlet");
                return;
            }

            request.setAttribute("staffToModify", staffUser);
            request.getRequestDispatcher("ModifyStaff.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Fail to retrieve staff details - " + e.getMessage());
            response.sendRedirect("ListUserServlet");
        }
    }
}
