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

@WebServlet("/secureManager/ViewCustomerServlet")
public class ViewCustomerServlet extends HttpServlet {

    @EJB
    private UserService userService;

    // Fetch specifc customer details for modification
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // Get the userId and fetch the customer details
            String userId = request.getParameter("userId");

            if (userId == null || userId.isEmpty()) {
                session.setAttribute("errorMessage", "Invalid customer ID! Please try again. ");
                response.sendRedirect("ListUserServlet");
                return;
            }

            Users customerUser = userService.findUserById(userId);
            Customer customerDetails = null;

            if (customerUser != null) {
                customerDetails = userService.findCustomerById(userId);
                customerUser.setCustomer(customerDetails);
            }

            if (customerUser == null || customerDetails == null) {
                session.setAttribute("errorMessage", "Customer not found! Please try again. ");
                response.sendRedirect("ListUserServlet");
                return;
            }

            request.setAttribute("customerToModify", customerUser);
            request.getRequestDispatcher("ModifyCustomer.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Fail to retrieve customer details - " + e.getMessage());
            response.sendRedirect("ListUserServlet");
        }
    }
}
