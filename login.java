import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("login")
public class login extends HttpServlet { 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cust = "customer";
        String admin = "admin";
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String hashedPassword = hashPassword(password);
        
        String dbURL = "jdbc:mysql://localhost:3306/java";
        String dbUser = "root";
        String dbPassword = "";
         try
         {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String query = "SELECT*FROM users WHERE email = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, email);
                pstmt.setString(2, hashedPassword);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    String userType = rs.getString(9);               
                    if (admin.equals(userType)) {
                         HttpSession session = request.getSession();
                         session.setAttribute("email", email);
                        response.sendRedirect("admin.jsp");
                    } else if (cust.equals(userType)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("email", email);
                        response.sendRedirect("shopping.jsp");
                    }
                   
                }
                else
                {                   
                   request.setAttribute("errorMessage", "Invalid email or password");
                   request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            
        } catch (SQLException | ClassNotFoundException ex) {
            
            request.setAttribute("errorMessage", "database"+ex.getMessage());
        }

       
    }
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
