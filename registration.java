import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/registration")
public class registration extends HttpServlet {
    String url = "jdbc:mysql://localhost:3306/java";
    String uname = "root";
    String pass = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("fname");
        String lastName = request.getParameter("lname");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String country = request.getParameter("country");
        String phoneNumber = request.getParameter("phone");
        String username = request.getParameter("uname");
        String password = request.getParameter("pass");
        String gender = request.getParameter("gender");
        String userType = "customer";
        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || address.isEmpty() || country.isEmpty() ||
            phoneNumber.isEmpty() || username.isEmpty() || password.isEmpty() || gender.isEmpty()) {
        request.setAttribute("errorMessage", "insert all the fields");
        request.getRequestDispatcher("registration.jsp").forward(request, response);
        return;
    }

        try {
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, uname, pass);
            System.out.println("Database connection established.");

            // Check if username or email already exists
            if (isExistingUser(conn, username, email)) {
                 request.setAttribute("errorMessage", "email or username exist");
                 request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }

            // Validate password strength
            if (!isValidPassword(password)) {
                 request.setAttribute("errorMessage", "password must more than 8 charecters");
                 request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }
            
            // Hash the password
            String hashedPassword = hashPassword(password);

            // Create a SQL statement
            String sql = "INSERT INTO users (firstname, lastname, email, address, country, phonenumber, username, usertype, password, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            // Set parameters for the SQL statement
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, address);
            pstmt.setString(5, country);
            pstmt.setString(6, phoneNumber);
            pstmt.setString(7, username);
            pstmt.setString(8, userType);
            pstmt.setString(9, hashedPassword);
            pstmt.setString(10, gender);

            // Execute the SQL statement
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            pstmt.close();
            conn.close();

            if (rowsAffected > 0) {
                // Redirect to registration success page
                response.sendRedirect("index.jsp");
            } else {
                // Redirect to registration page with an error message              
                 request.setAttribute("errorMessage", "Invalid email or password");
                 request.getRequestDispatcher("registration.jsp").forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException ex) {
            ex.printStackTrace();
            // Handle exceptions
            response.sendRedirect("registration.jsp?error=4&message=" + ex.getMessage());
        }
    }

    // Method to check if username or email already exists
    private boolean isExistingUser(Connection conn, String username, String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, email);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            int count = rs.getInt(1);
            return count > 0;
        }
        return false;
    }

    // Method to validate password strength
    private boolean isValidPassword(String password) {
        // Implement your password strength validation logic here
        // For example, minimum length, containing both letters and numbers, and special characters
        return password.length() >= 8 && password.matches(".*[a-zA-Z].*") && password.matches(".*\\d.*");
    }

    // Method to hash the password using SHA-256 algorithm
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            // Handle hash algorithm not found exception
            return null;
        }
    }
}
