<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Record</title>
</head>
<body>
    <%
        // Get the record ID from the request parameter
        String id = request.getParameter("id");
        
        // Check if the ID is provided
        if (id != null && !id.isEmpty()) {
            try {
                // Load the JDBC driver and establish a connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");

                // Prepare the SQL statement to delete the record
                String sql = "DELETE FROM cart WHERE cartID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, id);
                
                // Execute the delete statement
                int rowsDeleted = pstmt.executeUpdate();
                if (rowsDeleted > 0) {
                    // If deletion is successful, redirect back to the admin page
                    response.sendRedirect("cart.jsp");
                } else {
                    // If no rows were affected, display an error message
                    out.println("<h2>No record found with ID " + id + "</h2>");
                }

                // Close the prepared statement and connection
                pstmt.close();
                conn.close();
            } catch (ClassNotFoundException | SQLException e) {
                // Display error message if an exception occurs
                out.println("<h2>Error: " + e.getMessage() + "</h2>");
            }
        } else {
            // Display error message if ID is not provided
            out.println("<h2>Error: Record ID not provided.</h2>");
        }
    %>
</body>
</html>
