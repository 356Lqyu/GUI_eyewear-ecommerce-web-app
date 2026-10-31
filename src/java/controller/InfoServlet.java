/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class InfoServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        // Set company info in application scope (global)
        context.setAttribute("companyName", context.getInitParameter("companyName"));
        context.setAttribute("companyEmail", context.getInitParameter("companyEmail"));
        context.setAttribute("copyright", context.getInitParameter("copyright"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is logged in
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        // Forward user to corresponding dashboard based on their role
        if ("manager".equals(userRole)) {
            request.getRequestDispatcher("secureManager/ManagerDashboard.jsp").forward(request, response);
        } else if ("staff".equals(userRole)) {
            request.getRequestDispatcher("secureStaff/StaffDashboard.jsp").forward(request, response);
        } else if ("customer".equals(userRole)) {
            request.getRequestDispatcher("secureCustomer/CustomerDashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect("LoginRoleSelection");
        }
    }

}
