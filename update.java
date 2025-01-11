import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)
public class update extends HttpServlet {

    public static final String UPLOAD_DIR = "pictures";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the request parameters
        String id = request.getParameter("id");
        String pname = request.getParameter("pname");
        String price = request.getParameter("price");
        String qty = request.getParameter("qty");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        Part filePart = request.getPart("picture");    
        // Extract the filename
        String fileName = extractFileName(filePart);

        //Set up the upload directory
        String applicationPath = getServletContext().getRealPath("");
        //String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        String uploadPath ="C:/Users/mutan/Documents/NetBeansProjects/urbanelegence/web/pictures";
        File fileUploadDirectory = new File(uploadPath);
        if (!fileUploadDirectory.exists()) {
            fileUploadDirectory.mkdirs();
        }
        // Save the file to the upload directory
        String savePath = uploadPath + File.separator + fileName;
        filePart.write(savePath);
        
        // Set the database file name
        String dbFileName = UPLOAD_DIR + File.separator +fileName;
        
        // Copy the file to the pictures folder in the project
        try (InputStream input = filePart.getInputStream()) {
            File targetFile = new File(applicationPath + File.separator + "pictures" + File.separator + fileName);
            Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ex) {
            Logger.getLogger(admin.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        // Handle the rest of your logic (e.g., database insertion) here
        // Redirect to a success page or show a success message
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "")) {
                // Prepare the SQL statement
                String sql = "update products set product_name =?,price =?,quantity =?,category =?,type =?,picture =? where stockID='"+id+"'";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    // Set the parameters
                    pst.setString(1, pname);
                    pst.setString(2, price);
                    pst.setString(3, qty);
                    pst.setString(4, category);
                    pst.setString(5, type);
                    pst.setString(6, dbFileName);
                    
                    // Execute the SQL statement
                    boolean rs = pst.execute();
                    if (!rs) {
                        // If successful, forward to admin.jsp with a success message
                        request.getRequestDispatcher("admin.jsp").forward(request, response);
                    } else {
                        // If unsuccessful, redirect to admin.jsp with an error message
                        response.sendRedirect("admin.jsp?error=0");
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            // Log the exception
            Logger.getLogger(admin.class.getName()).log(Level.SEVERE, null, ex);
            // Redirect to admin.jsp with an error message
            response.sendRedirect("admin.jsp?error=1"+ex.getMessage());
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}