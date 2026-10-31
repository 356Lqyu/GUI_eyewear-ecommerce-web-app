<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Logout</title>
    <script type="text/javascript">
        function confirmLogout() {
            if (confirm("Sure to logout?")) {
                <%
                    // Clear session and logout
                    session.invalidate();
                    request.logout();
                %>
                window.location.href = "home.jsp";
            } else {
                window.history.back();
            }
        }
        window.onload = confirmLogout;
    </script>
</head>
<body>
    <div style="text-align: center; margin-top: 50px;">
        <p>Logging out...</p>
    </div>
</body>
</html>