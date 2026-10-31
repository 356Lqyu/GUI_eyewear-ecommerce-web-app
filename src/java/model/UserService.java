package model;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

@Stateless
public class UserService {

    @PersistenceContext
    private EntityManager em;

    public void addUser(Users user) {
        try {
            em.persist(user);

            // Specific user types (customer , staff and manager)
            if ("staff".equals(user.getRole())) {
                Staff staff = user.getStaff();
                if (staff != null) {
                    em.persist(staff);
                }
            } else if ("customer".equals(user.getRole())) {
                Customer customer = user.getCustomer();
                if (customer != null) {
                    em.persist(customer);
                }
            } else if ("manager".equals(user.getRole())) {
                Manager manager = user.getManager();
                if (manager != null) {
                    em.persist(manager);
                }
            }
            em.flush();
        } catch (Exception e) {
            throw new RuntimeException("Error adding user: " + e.getMessage(), e);
        }
    }

    public Users findUserById(String userId) {
        return em.find(Users.class, userId);
    }

    public Customer findCustomerById(String userId) {
        return em.find(Customer.class, userId);
    }

    public Staff findStaffById(String userId) {
        return em.find(Staff.class, userId);
    }

    public Manager findManagerById(String userId) {
        return em.find(Manager.class, userId);
    }

    public Users findUserByUsername(String username) {
        try {
            return em.createQuery(
                    "SELECT u FROM Users u WHERE u.username = :username", Users.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    //Update &  delete function
    public void updateUser(Users user) {
        em.merge(user);
        em.flush();
    }

    public void deleteUser(String userId) {
        Users user = em.find(Users.class, userId);
        if (user != null) {
            em.remove(user);
        }
    }

    //Validate user fucntion
    public Users validateUser(String username, String password) {
        try {
            Users user = em.createQuery(
                    "SELECT u FROM Users u WHERE u.username = :username AND u.password = :password", Users.class)
                    .setParameter("username", username)
                    .setParameter("password", password)
                    .getSingleResult();

            switch (user.getRole()) {
                case "manager":
                    user.setManager(findManagerById(user.getUserId()));
                    break;
                case "staff":
                    user.setStaff(findStaffById(user.getUserId()));
                    break;
                case "customer":
                    user.setCustomer(findCustomerById(user.getUserId()));
                    break;
            }

            return user;

        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Users> getAllStaffUsers() {
        List<Users> staffUsers = em.createQuery(
                "SELECT u FROM Users u WHERE u.role = 'staff' ORDER BY u.userId", Users.class)
                .getResultList();

        for (Users user : staffUsers) {
            user.setStaff(findStaffById(user.getUserId()));
        }

        return staffUsers;
    }

    public List<Users> getAllCustomerUsers() {
        List<Users> customerUsers = em.createQuery(
                "SELECT u FROM Users u WHERE u.role = 'customer' ORDER BY u.userId", Users.class)
                .getResultList();

        for (Users user : customerUsers) {
            user.setCustomer(findCustomerById(user.getUserId()));
        }

        return customerUsers;
    }

    public void resetPassword(String userId, String newPassword) {
        Users user = findUserById(userId);
        if (user != null) {
            user.setPassword(newPassword);
            em.merge(user);
        }
    }

    public String getICByUserId(String userId) {
        try {
            TypedQuery<String> query = em.createQuery(
                    "SELECT u.ic FROM Users u WHERE u.userId = :userId", String.class
            );
            query.setParameter("userId", userId);

            return query.getSingleResult();
        } catch (NoResultException e) {
            System.out.println("IC not found for userId: " + userId);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean isBirthdayMonth(String ic) {
        if (ic == null || ic.length() < 6) {
            return false; // Invalid IC
        }

        try {
            String icMonth = ic.substring(2, 4); // Get MM
            String currentMonth = new java.text.SimpleDateFormat("MM").format(new java.util.Date());

            return icMonth.equals(currentMonth);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
