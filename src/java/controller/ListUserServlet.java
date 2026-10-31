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
import java.util.List;

@WebServlet("/secureManager/ListUserServlet")
public class ListUserServlet extends HttpServlet {

    @EJB
    private UserService userService;

    // Fetch user form database to show in table
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String type = request.getParameter("type"); // Get role (customer or staff)

        try {
            if ("staff".equals(type)) {
                // Fetch all staff
                List<Users> staffList = userService.getAllStaffUsers();
                request.setAttribute("staffList", staffList);
                request.getRequestDispatcher("ManageStaff.jsp").forward(request, response);
            } else if ("customer".equals(type)) {
                // Fetch all customers
                List<Users> customerList = userService.getAllCustomerUsers();
                request.setAttribute("customerList", customerList);
                request.getRequestDispatcher("ManageCustomer.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Invalid user role specified");
                response.sendRedirect("../secureManager/ManagerDashboard.html");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Fail to retrieve user list - " + e.getMessage());
            if ("staff".equals(type)) {
                response.sendRedirect("ManageStaff.jsp");
            } else {
                response.sendRedirect("ManageCustomer.jsp");
            }
        }
    }
}
