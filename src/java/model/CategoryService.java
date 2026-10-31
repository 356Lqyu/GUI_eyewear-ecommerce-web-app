package model;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;

@Stateless
public class CategoryService {

    @PersistenceContext(unitName = "FourEyesCollectivePU") 
    private EntityManager em;

    public Category findCategoryById(String categoryId) {
        if (categoryId == null) {
            return null;
        }
        return em.find(Category.class, categoryId);
    }

    public Category findByName(String categoryName) {
        try {
            return em.createQuery("SELECT c FROM Category c WHERE c.categoryName = :name", Category.class)
                     .setParameter("name", categoryName)
                     .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public void addCategory(Category category) {
        em.persist(category);
        em.flush();
    }

    public void updateCategory(Category category) {
        em.merge(category);
        em.flush();
    }

    public void deleteCategory(String categoryId) {
        Category category = findCategoryById(categoryId);
        if (category != null) {
            em.remove(category);
        }
    }
}
