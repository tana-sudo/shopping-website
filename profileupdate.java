import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
/**
 *
 * @author Tanatswa
 */
@WebServlet("/profileupdate")
public class profileupdate extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          // Retrieve form data
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String country = request.getParameter("country");
        String phone = request.getParameter("phone");
        String uname = request.getParameter("uname");
        String gender = request.getParameter("gender");
        String sesh = request.getParameter("sesh");
        Connection con = null;
        PreparedStatement st = null;
        
        try {
            // Establish connection
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
            
            // Prepare SQL statement
            String sql = "UPDATE users SET firstname=?, lastname=?, email=?, address=?, country=?, phonenumber=?, username=?, gender=? WHERE email=?";
            st = con.prepareStatement(sql);
            st.setString(1, fname);
            st.setString(2, lname);
            st.setString(3, email);
            st.setString(4, address);
            st.setString(5, country);
            st.setString(6, phone);
            st.setString(7, uname);
            st.setString(8, gender);
            st.setString(9, sesh); 
            
            // Execute update
            int rowsAffected = st.executeUpdate();
            
            // Redirect to a success page or handle accordingly
            if (rowsAffected > 0) {
                request.setAttribute("errorMessage", "updated successfully");
                response.sendRedirect("profileupdate.jsp");
            } 
        } catch (Exception e) {
            // Handle exception
            e.printStackTrace();
            // Redirect to an error page
            response.sendRedirect("profile_update_error.html");
        } 
        
    }

   

}
