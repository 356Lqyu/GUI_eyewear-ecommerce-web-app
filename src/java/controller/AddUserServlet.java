package controller;

import model.*;
import jakarta.ejb.EJB;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.time.LocalDate;

@WebServlet("/AddUserServlet")
public class AddUserServlet extends HttpServlet {

    @EJB
    private UserService userService;

    // Details validation (Ic , phone , email pattern)
    private static final Pattern IC_PATTERN = Pattern.compile("^\\d{6}-\\d{2}-\\d{4}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{2}-\\d{7,8}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(gmail\\.com|opticare\\.com)$");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = request.getParameter("role");

        try {
            // Validate fields 
            if (role == null || role.isEmpty()) {
                throw new ServletException("Role is required");
            }

            String userId = request.getParameter("userId");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String ic = request.getParameter("ic");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String securityQuestion = request.getParameter("securityQuestion");
            String securityAnswer = request.getParameter("securityAnswer");

            // Make sure all details are filled in
            if (userId == null || userId.isEmpty()
                    || username == null || username.isEmpty()
                    || password == null || password.isEmpty()
                    || ic == null || ic.isEmpty()
                    || email == null || email.isEmpty()
                    || contactNumber == null || contactNumber.isEmpty()
                    || securityQuestion == null || securityQuestion.isEmpty()
                    || securityAnswer == null || securityAnswer.isEmpty()) {
                throw new ServletException("Please fill in all fields.");
            }

            // Check if the username already exists in database (duplicate username)
            if (userService.findUserByUsername(username) != null) {
                session.setAttribute("errorMessage", "Username already exists. Please enter an unique username.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
                }
                return;
            }

            // Deatils validation
            // Validate IC
            if (!validateIc(ic)) {
                session.setAttribute("errorMessage", "Invalid IC. Please enter with YYMMDD-XX-XXXX format.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
                }
                return;
            }

            // Validate date and month part of IC (YYMMDD)
            if (!validateDOB(ic.substring(0, 6))) {
                session.setAttribute("errorMessage", "Invalid date of birth in IC. Format should be YYMMDD.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
                }
                return;
            }

            // Validate birth year is before 2007 (is underage)
            if (!validateBirthYear(ic.substring(0, 2))) {
                session.setAttribute("errorMessage", "User must be at least 18 years old.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
                }
                return;
            }

            // Validate phone number format
            if (!validatePhoneNumber(contactNumber)) {
                session.setAttribute("errorMessage", "Invalid phone number format. Please enter with 0XX-XXXXXXX format.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
                }
                return;
            }

            // Validate email format
            if (!validateEmail(email)) {
                session.setAttribute("errorMessage", "Invalid email format. Email must end with @gmail.com");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
                }
                return;
            }

            // Create Users object
            Users newUser = new Users();
            newUser.setUserId(userId);
            newUser.setUsername(username);
            newUser.setPassword(password);
            newUser.setIc(ic);
            newUser.setEmail(email);
            newUser.setContactNumber(contactNumber);
            newUser.setRole(role);
            newUser.setSecurityQuestion(securityQuestion);
            newUser.setSecurityAnswer(securityAnswer);

            if ("staff".equals(role)) {
                Date hiredDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("hiredDate"));
                // Make sure hired date is not in future
                if (hiredDate.after(new Date())) {
                    session.setAttribute("errorMessage", "Hired date cannot be in future.");
                    response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
                    return;
                }
                Double salary = new Double(request.getParameter("salary"));

                // Create Staff
                Staff staff = new Staff();
                staff.setUserId(userId);
                staff.setHiredDate(hiredDate);
                staff.setSalary(salary);

                staff.setUsers(newUser);
                newUser.setStaff(staff);

                userService.addUser(newUser);

            } else if ("customer".equals(role)) {
                // Create Customer
                Customer customer = new Customer();
                customer.setUserId(userId);

                customer.setUsers(newUser);
                newUser.setCustomer(customer);

                userService.addUser(newUser);
            }

            // Capitalize first letter of role , so can show in AddUserConfrimation
            String capitalizedRole = role.substring(0, 1).toUpperCase() + role.substring(1);

            // Set success message
            session.setAttribute("successMessage", capitalizedRole + " " + username + " has been successfully added!");
            session.setAttribute("successRole", capitalizedRole);
            session.setAttribute("successUserId", userId);

            if ("staff".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/ManageStaff.jsp");
            } else if ("customer".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/ManageCustomer.jsp");
            }

        } catch (ParseException pe) {
            session.setAttribute("errorMessage", "Invalid date format - " + pe.getMessage());
            if ("staff".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
            } else if ("customer".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
            }
        } catch (NumberFormatException nfe) {
            session.setAttribute("errorMessage", "Invalid number format - " + nfe.getMessage());
            if ("staff".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
            } else if ("customer".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
            }
        } catch (Exception ex) {
            session.setAttribute("errorMessage", "Fail to add new user - " + ex.getMessage());
            if ("staff".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/AddStaff.jsp");
            } else if ("customer".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/secureManager/AddCustomer.jsp");
            }
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

            // Check number of days for each month
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

    // Validate birth year must before 2007 (age 18+)
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
