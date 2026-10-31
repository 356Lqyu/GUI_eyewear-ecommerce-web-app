/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.PersistenceUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.UserTransaction;
import jakarta.annotation.Resource;
import java.io.IOException;
import model.Rating;
import model.Users;

@WebServlet("/secureStaff/DeleteRatingServlet")
public class DeleteRatingServlet extends HttpServlet {
    
    @PersistenceUnit(unitName = "FourEyesCollectivePU")
    private EntityManagerFactory emf;
    
    @Resource
    private UserTransaction utx;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null ) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String ratingIdStr = request.getParameter("ratingId");
        EntityManager em = null;
        
        try {
            // Start transaction BEFORE creating EntityManager
            utx.begin();
            
            em = emf.createEntityManager();
            
            if (ratingIdStr == null || ratingIdStr.trim().isEmpty()) {
                throw new ServletException("Rating ID is required");
            }
            
            // Join the EM to the current transaction
            em.joinTransaction();
            
            Rating rating = em.find(Rating.class, ratingIdStr);
            if (rating == null) {
                throw new ServletException("Rating not found with ID: " + ratingIdStr);
            }
            
            // Make entity managed in this persistence context
            rating = em.merge(rating);
            em.remove(rating);
            
            // Commit the transaction
            utx.commit();
            
            // Clear cache
            em.clear();
            if (emf.getCache() != null) {
                emf.getCache().evict(Rating.class, ratingIdStr);
                emf.getCache().evictAll();
            }
            
            session.setAttribute("successMessage", "Rating " + ratingIdStr + " deleted successfully!");
        } catch (Exception ex) {
            try {
                if (utx != null) {
                    utx.rollback();
                }
            } catch (Exception rollbackEx) {
                System.err.println("Error during transaction rollback: " + rollbackEx.getMessage());
            }
            session.setAttribute("errorMessage", "Error deleting rating: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/secureStaff/ManageRating.jsp?nocache=" + System.currentTimeMillis());
    }
}