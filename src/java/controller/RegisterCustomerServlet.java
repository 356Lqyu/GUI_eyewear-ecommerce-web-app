package controller;

import model.*;
import jakarta.ejb.EJB;
import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/RegisterCustomerServlet")
public class RegisterCustomerServlet extends HttpServlet {

    @EJB
    private UserService userService;

    // Details validation
    private static final Pattern IC_PATTERN = Pattern.compile("^\\d{6}-\\d{2}-\\d{4}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{2}-\\d{7,8}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@gmail\\.com$");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Clear previous error messages
        session.removeAttribute("errorMessage");
        session.removeAttribute("successMessage");

        try {
            // Automatically generate customer ID
            String newUserId = "CU" + String.format("%04d", new Random().nextInt(9000) + 1000);

            // Get parameters from register form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String ic = request.getParameter("ic");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String securityQuestion = request.getParameter("securityQuestion");
            String securityAnswer = request.getParameter("securityAnswer");


            // Check to make sure all fields are filled in
            if (username == null || username.isEmpty() || password == null || password.isEmpty() || ic == null || ic.isEmpty() || email == null || email.isEmpty()
                    || contactNumber == null || contactNumber.isEmpty() || securityQuestion == null 
                    || securityQuestion.isEmpty() || securityAnswer == null || securityAnswer.isEmpty()) {
                session.setAttribute("errorMessage", "Please fill in all fields");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            // Make sure username are unique 
            if (userService.findUserByUsername(username) != null) {
                session.setAttribute("errorMessage", "Username already exists");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            // Details validation (ic , phone number , email)
            if (!validateIc(ic)) {
                session.setAttribute("errorMessage", "Invalid IC format. Please enter with YYMMDD-XX-XXXX format.");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            if (!validateDOB(ic.substring(0, 6))) {
                session.setAttribute("errorMessage", "Invalid date of birth in IC. Format should be YYMMDD");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            if (!validateBirthYear(ic.substring(0, 2))) {
                session.setAttribute("errorMessage", "Sorry, you are underage and are not allowed to register!");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            if (!validatePhoneNumber(contactNumber)) {
                session.setAttribute("errorMessage", "Invalid phone number format. Please enter with 0XX-XXXXXXX format.");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            if (!validateEmail(email)) {
                session.setAttribute("errorMessage", "Invalid email format. Email must end with @gmail.com");
                response.sendRedirect("RegisterCustomer.jsp");
                return;
            }

            // Create Users object
            Users newUser = new Users(
                    newUserId,
                    username,
                    password,
                    ic,
                    email,
                    "customer",
                    securityQuestion,
                    securityAnswer
            );
            newUser.setContactNumber(contactNumber);

            // Create Customer
            Customer customer = new Customer();
            customer.setUserId(newUserId);

            customer.setUsers(newUser);
            newUser.setCustomer(customer);

            userService.addUser(newUser);

            // Set success message
            session.setAttribute("successMessage", "Registration successful! You can now log in to our website.");
            response.sendRedirect("RegisterCustomer.jsp");
            return;

        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("errorMessage", "Registration failed! "
                    + (ex.getMessage() != null ? ex.getMessage() : "Please check your details"));
            response.sendRedirect("RegisterCustomer.jsp");
        }
    }

    // Validate IC format (YYMMDD-XX-XXXX)
    private boolean validateIc(String ic) {
        if (ic == null) {
            return false;
        }
        Matcher matcher = IC_PATTERN.matcher(ic);
        return matcher.matches();
    }

    // Validate date of birth part in IC (YYMMDD)
    private boolean validateDOB(String dateP) {
        if (dateP == null || dateP.length() != 6) {
            return false;
        }

        try {
            int month = Integer.parseInt(dateP.substring(2, 4));
            int day = Integer.parseInt(dateP.substring(4, 6));

            if (month < 1 || month > 12) {
                return false;
            }

            int maxDay;
            switch (month) {
                case 4:
                case 6:
                case 9:
                case 11:
                    maxDay = 30;
                    break;
                case 2:
                    maxDay = 28;
                    break;
                default:
                    maxDay = 31;
            }

            if (day < 1 || day > maxDay) {
                return false;
            }

            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Validate birth year must before 2007 (customer should be at least age 18+)
    private boolean validateBirthYear(String yearPart) {
        try {
            int year = Integer.parseInt(yearPart);
            int currentYear = LocalDate.now().getYear() % 100;

            int fullYear = (year > currentYear) ? 1900 + year : 2000 + year;
            return fullYear < 2007;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Validate phone number format
    private boolean validatePhoneNumber(String phoneNumber) {
        if (phoneNumber == null) {
            return false;
        }
        Matcher matcher = PHONE_PATTERN.matcher(phoneNumber);
        return matcher.matches();
    }

    // Validate email format 
    private boolean validateEmail(String email) {
        if (email == null) {
            return false;
        }
        Matcher matcher = EMAIL_PATTERN.matcher(email);
        return matcher.matches();
    }
}
