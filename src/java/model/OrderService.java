/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.*;
import jakarta.persistence.*;

import java.util.List;

public class OrderService {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("FourEyesCollectivePU");

    public List<Orders> getAllOrders() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT o FROM Orders o ORDER BY o.orderDate DESC", Orders.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }
}