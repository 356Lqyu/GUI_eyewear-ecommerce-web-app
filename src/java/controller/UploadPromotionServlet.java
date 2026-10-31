package controller;

import model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.transaction.Transactional;

import java.io.*;

@WebServlet(name = "UploadPromotionServlet", urlPatterns = {"/UploadPromotionServlet"})
@MultipartConfig
@Transactional
public class UploadPromotionServlet extends HttpServlet {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            // Get the slot parameter
            int slot = Integer.parseInt(request.getParameter("slot"));
            if (slot < 1 || slot > 3) {
                showError(out, "Slot must be between 1 and 3.");
                return;
            }

            // Get the promotional text
            String promoText = request.getParameter("promoText");
            Part imagePart = request.getPart("image");

            if (imagePart == null || imagePart.getSize() == 0) {
                showError(out, "No image uploaded. Please try again.");
                return;
            }

            // Paths to save the image
            String serverPromotionPath = getServletContext().getRealPath("/Promotion");
            String projectRootPath = new File(serverPromotionPath).getParentFile().getParentFile().getParent();
            String projectPromotionPath = projectRootPath + "/web/Promotion";

            // File name and promo ID
            String imageFileName = "PromotionImage" + slot + ".png";
            String promoId = "P00" + slot;

            // Save the image to both locations
            saveImage(imagePart, new File(serverPromotionPath, imageFileName));
            saveImage(imagePart, new File(projectPromotionPath, imageFileName));

            // Update or insert promotion
            Promotion promo = em.find(Promotion.class, promoId);
            if (promo != null) {
                promo.setImageName(imageFileName);
                promo.setPromoText(promoText);
                em.merge(promo);
            } else {
                promo = new Promotion(promoId, imageFileName, promoText);
                em.persist(promo);
            }

            // Success message
            showSuccess(out, "Promotion uploaded successfully!");

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error adding promotion: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/secureStaff/UploadPromotion.jsp");

        }
    }

// Helper method to save the uploaded image to a file
    private void saveImage(Part imagePart, File targetFile) throws IOException {
        try (InputStream input = imagePart.getInputStream(); FileOutputStream output = new FileOutputStream(targetFile)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }
    }

    // Helper method to show a success message and redirect after 3 seconds
    private void showSuccess(PrintWriter out, String message) {
        out.println("<html><head>");
        out.println("<meta http-equiv='refresh' content='3;URL=secureStaff/UploadPromotion.jsp'>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', sans-serif; background-color: #f1f1f1; text-align: center; padding-top: 50px; }");
        out.println(".popup { width: 600px; height: 400px; display: inline-block; padding: 20px; apdding-top:50px; border: 2px solid #ccc; background-color: #888888 border-radius: 15px; box-shadow: 0 0 10px #222222; }");
        out.println(".popup h2 { padding-top:100px;}");
        out.println("</style>");
        out.println("</head><body>");
        out.println("<div class='popup'><h2>🎉 " + message + "</h2><p>You will be redirected shortly...</p></div>");
        out.println("</body></html>");
    }

    // Helper method to show an error message
    private void showError(PrintWriter out, String message) {
        out.println("<html><body><p style='color:red; text-align:center;'>" + message + "</p></body></html>");
    }
}
