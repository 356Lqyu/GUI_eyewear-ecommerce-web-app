package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import model.*;

@WebServlet("/ModifyUserServlet")
public class ModifyUserServlet extends HttpServlet {

    @EJB
    private UserService userService;

    // Details validation
    private static final Pattern IC_PATTERN = Pattern.compile("^\\d{6}-\\d{2}-\\d{4}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{2}-\\d{7,8}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(gmail\\.com|opticare\\.com)$");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = request.getParameter("role");

        try {
            String userId = request.getParameter("userId");
            Users existingUser = userService.findUserById(userId);

            if (existingUser == null) {
                throw new ServletException("User not found! Please try again. ");
            }

            // Get updated details from request
            String ic = request.getParameter("ic");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String securityQuestion = request.getParameter("securityQuestion");
            String securityAnswer = request.getParameter("securityAnswer");

            // Validation
            if (!validateIc(ic)) {
                session.setAttribute("errorMessage", "Invalid IC format. Please enter with YYMMDD-XX-XXXX format.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewStaffServlet?userId=" + userId);
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewCustomerServlet?userId=" + userId);
                }
                return;
            }

            if (!validateDOB(ic.substring(0, 6))) {
                session.setAttribute("errorMessage", "Invalid date of birth in IC. Format should be YYMMDD.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewStaffServlet?userId=" + userId);
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewCustomerServlet?userId=" + userId);
                }
                return;
            }

            if (!validateBirthYear(ic.substring(0, 2))) {
                session.setAttribute("errorMessage", "User must be at least 18 years old.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewStaffServlet?userId=" + userId);
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewCustomerServlet?userId=" + userId);
                }
                return;
            }

            if (contactNumber != null && !contactNumber.isEmpty() && !validatePhoneNumber(contactNumber)) {
                session.setAttribute("errorMessage", "Invalid phone number. Please enter with 0XX-XXXXXXX format.");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewStaffServlet?userId=" + userId);
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewCustomerServlet?userId=" + userId);
                }
                return;
            }

            if (!validateEmail(email)) {
                session.setAttribute("errorMessage", "Invalid email format. Email must end with @gmail.com or @opticare.com");
                if ("staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewStaffServlet?userId=" + userId);
                } else if ("customer".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/secureManager/ViewCustomerServlet?userId=" + userId);
                }
                return;
            }

            // Update user fields
            existingUser.setUsername(request.getParameter("username"));
            existingUser.setPassword(request.getParameter("password"));
            existingUser.setIc(ic);
            existingUser.setEmail(email);
            existingUser.setContactNumber(contactNumber);
            existingUser.setSecurityQuestion(securityQuestion);
            existingUser.setSecurityAnswer(securityAnswer);

            // Update role-specific fields
            if ("customer".equals(role)) {
                Customer customer = existingUser.getCustomer();
                if (customer == null) {
                    customer = new Customer(userId);
                    existingUser.setCustomer(customer);
                    customer.setUsers(existingUser);
                }
            } else if ("staff".equals(role)) {
                Staff staff = existingUser.getStaff();
                if (staff == null) {
                    staff = new Staff(userId);
                    existingUser.setStaff(staff);
                    staff.setUsers(existingUser);
                }

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date hiredDate = null;
                try {
                    hiredDate = dateFormat.parse(request.getParameter("hiredDate"));
                    staff.setHiredDate(hiredDate);
                } catch (ParseException e) {
                    throw new ServletException("Invalid date format", e);
                }

                String salaryStr = request.getParameter("salary");
                if (salaryStr != null && !salaryStr.isEmpty()) {
                    try {
                        Double salary = Double.parseDouble(salaryStr);
                        staff.setSalary(salary);
                    } catch (NumberFormatException e) {
                        throw new ServletException("Invalid salary format", e);
                    }
                }
            }

            // Update the user
            userService.updateUser(existingUser);

            // Set success message and back to Manage User page
            String successMessage = role.substring(0, 1).toUpperCase() + role.substring(1)
                    + " " + existingUser.getUsername() + " has been successfully updated!";
            session.setAttribute("successMessage", successMessage);
            response.sendRedirect("secureManager/ListUserServlet?type=" + role);

        } catch (Exception ex) {
            session.setAttribute("errorMessage", "Failed to update " + role + " - " + ex.getMessage());
            response.sendRedirect("secureManager/ListUserServlet?type=" + role);
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
