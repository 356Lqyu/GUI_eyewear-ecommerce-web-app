/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import model.*;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

@Stateless
public class RatingService {
    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    private static final Logger logger = Logger.getLogger(RatingService.class.getName());

    public void submitRating(String productId, String userId, int ratingValue, String comment) {
        logger.info("Submitting rating: productId=" + productId + ", userId=" + userId);

        Product product = em.find(Product.class, productId);
        if (product == null) {
            throw new IllegalArgumentException("Product not found: " + productId);
        }

        Users user = em.find(Users.class, userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found: " + userId);
        }

        Rating rating = new Rating();
        rating.setRatingId("RT" + System.currentTimeMillis() % 10000);
        rating.setProduct(product);
        rating.setUser(user);
        rating.setRatingValue(ratingValue);
        rating.setComment(comment);
        rating.setRatingDate(new Date());

        em.persist(rating);
        logger.info("Rating submitted successfully.");
    }
    
}