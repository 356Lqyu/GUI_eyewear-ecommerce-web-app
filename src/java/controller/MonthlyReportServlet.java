/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.transaction.Transactional;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@WebServlet("/MonthlyReportServlet")
@Transactional
public class MonthlyReportServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String monthParam = request.getParameter("month"); // format: yyyy-MM
        if (monthParam == null || !monthParam.matches("\\d{4}-\\d{2}")) {
            response.sendError(400, "Invalid or missing month parameter.");
            return;
        }

        try {
            YearMonth yearMonth = YearMonth.parse(monthParam);
            LocalDate startDate = yearMonth.atDay(1);
            LocalDate endDate = yearMonth.atEndOfMonth();

            Timestamp startTimestamp = Timestamp.valueOf(startDate.atStartOfDay());
            Timestamp endTimestamp = Timestamp.valueOf(endDate.atTime(23, 59, 59));

            Long totalOrders = em.createQuery(
                    "SELECT COUNT(o) FROM Orders o WHERE o.orderDate BETWEEN :startDate AND :endDate", Long.class)
                    .setParameter("startDate", startTimestamp)
                    .setParameter("endDate", endTimestamp)
                    .getSingleResult();

            Double totalRevenue = em.createQuery(
                    "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Orders o WHERE o.orderDate BETWEEN :startDate AND :endDate", Double.class)
                    .setParameter("startDate", startTimestamp)
                    .setParameter("endDate", endTimestamp)
                    .getSingleResult();

            Long totalCustomers = em.createQuery(
                    "SELECT COUNT(DISTINCT o.user.userId) FROM Orders o WHERE o.orderDate BETWEEN :startDate AND :endDate", Long.class)
                    .setParameter("startDate", startTimestamp)
                    .setParameter("endDate", endTimestamp)
                    .getSingleResult();

            List<Object[]> paymentMethods = em.createQuery(
                    "SELECT p.paymentMethod, COUNT(p) FROM Payment p WHERE p.order.orderDate BETWEEN :startDate AND :endDate GROUP BY p.paymentMethod",
                    Object[].class)
                    .setParameter("startDate", startTimestamp)
                    .setParameter("endDate", endTimestamp)
                    .getResultList();

            // NEW: load list of orders
            List<Orders> orderList = em.createQuery(
                    "SELECT o FROM Orders o WHERE o.orderDate BETWEEN :startDate AND :endDate ORDER BY o.orderDate ASC", Orders.class)
                    .setParameter("startDate", startTimestamp)
                    .setParameter("endDate", endTimestamp)
                    .getResultList();

            request.setAttribute("month", monthParam);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("paymentMethods", paymentMethods);
            request.setAttribute("orderList", orderList); // pass to JSP

            request.getRequestDispatcher("/secureManager/MonthlyReport.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error generating report: " + e.toString());
        }
    }
}
