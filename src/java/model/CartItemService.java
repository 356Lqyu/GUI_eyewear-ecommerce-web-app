/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class CartItemService {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("FourEyes2PU");

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    //use in checkout.jsp. paymentDetails.jsp
    public List<Cartitem> getOrderedCartItemsByUserId(String userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT ci FROM Cartitem ci JOIN FETCH ci.cart c "
                    + "WHERE c.user.userId = :userId AND c.status = 'ORDERED'", Cartitem.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

}