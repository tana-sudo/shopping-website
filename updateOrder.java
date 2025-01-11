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
@WebServlet("/updateOrder")
public class updateOrder extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          // Retrieve form data
        String orderID = request.getParameter("orderID");
        Connection con = null;
        PreparedStatement st = null;
        
        try {
            // Establish connection
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
            
            // Prepare SQL statement
            String sql = "UPDATE orders SET status=? WHERE orderID=?";
            st = con.prepareStatement(sql);
            st.setString(1, "on the way");
            st.setString(2, orderID);
           
            
            // Execute update
            int rowsAffected = st.executeUpdate();
            
           
            if (rowsAffected > 0) {
                request.setAttribute("errorMessage", "updated successfully");
                response.sendRedirect("orderdetails.jsp");
            } 
        } catch (Exception e) {
            // Handle exception
            e.printStackTrace();
            // Redirect to an error page
            response.sendRedirect("profile_update_error.html");
        } 
        
    }

   

}
