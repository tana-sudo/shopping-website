import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.*;

/**
 *
 * @author Tanatswa
 */
public class cart extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      String name = request.getParameter("name");
      String price = request.getParameter("price");
      String qty = request.getParameter("qty");
      String pic = request.getParameter("picture");
      String sesh = (String)request.getParameter("sesh");
       try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
         Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                // Prepare the SQL statement
                 String sqls = "Select*from users where email=?";
                 PreparedStatement psst = con.prepareStatement(sqls);            
                 psst.setString(1, sesh);                
                 ResultSet rss = psst.executeQuery();
                 if(rss.next())
                 {
                  String id = rss.getString(1);
                 String sql = "INSERT INTO cart (`name`,`price`,`quantity`,`picture`,`userID`)"
                        + "VALUES (?,?,?,?,?)";
                 PreparedStatement pst = con.prepareStatement(sql);
                    pst.setString(1, name);
                    pst.setString(2, price);
                    pst.setString(3, qty);
                    pst.setString(4, pic);
                    pst.setString(5, id); 
                    // Execute the SQL statement
                   boolean rs = pst.execute();
                    if (!rs) {                    
                        request.getRequestDispatcher("shopping.jsp").forward(request, response);
                    } else {
                        // If unsuccessful, redirect to admin.jsp with an error message
                        response.sendRedirect("shopping.jsp?error=0");
                    }   
                 }
            
        } catch (ClassNotFoundException | SQLException ex) {
            // Log the exception
            Logger.getLogger(admin.class.getName()).log(Level.SEVERE, null, ex);
            // Redirect to admin.jsp with an error message
            response.sendRedirect("shopping.jsp?error=1"+ex.getMessage());
            return;
        }
    }

}
