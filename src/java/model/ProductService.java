package model;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Stateless
public class ProductService {

    @PersistenceContext(unitName = "FourEyesCollectivePU")
    private EntityManager em;

    public Product findProductById(String productId) {
        if (productId == null) {
            return null;
        }
        return em.find(Product.class, productId);
    }

    public void addProduct(Product product) {
        em.persist(product);
        em.flush();
    }

    public void updateProduct(Product product) {
        em.merge(product);
        em.flush();
    }

    public void deleteProduct(String productId) {
        Product product = findProductById(productId);
        if (product != null) {
            em.remove(product);
        }
    }
}
