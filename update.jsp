<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Record</title>
    <style>
              body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 5px;
            padding: 10px;
        }
        h1 {
            color: #333;
            margin-left: 39%;
            margin-right: 39%;
        }
        label {
            font-weight: bold;
        }
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        button{
    padding: 10px;
    background-color: #4caf50;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    margin-bottom: 7px;
}
    </style>
</head>
<body>
    <%
        // Initialize variables to hold retrieved data
        String name = "";
        String price = "";
        String qty = "";
        String category = "";
        String type = "";

        // Get the record ID from the request parameter
        String id = request.getParameter("id");

        // Check if the ID is provided
        if (id != null && !id.isEmpty()) {
            try {
                // Load the JDBC driver and establish a connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");

                // Prepare the SQL statement to retrieve the record
                String sql = "SELECT * FROM products WHERE stockID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, id);

                // Execute the SQL query
                ResultSet rs = pstmt.executeQuery();

                // Check if the record exists
                if (rs.next()) {
                    // Retrieve data from the result set
                    name = rs.getString("product_name");
                    price = rs.getString("price");
                    qty = rs.getString("quantity");
                    category = rs.getString("category");
                    type = rs.getString("type");
                } else {
                    // If no record found, display an error message
                    out.println("<h2>No record found with ID " + id + "</h2>");
                }

                // Close the result set, prepared statement, and connection
                rs.close();
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

    <h1>Update Record</h1>
    <button onclick="window.location.href='admin.jsp'">back</button>
    <form action="update" method="post" enctype="multipart/form-data">
        <label>Product Name:</label>
        <input type="text" name="pname" value="<%=name%>" required><br><br>
        
        <label>Price:</label>
        <input type="text" name="price" value="<%=price%>" required><br><br>
        
        <label>Quantity:</label>
        <input type="number" name="qty" value="<%=qty%>" required><br><br>     
        <label>Category:</label>
        <select name="category" required>
            <option value="shoes" <%= category.equals("shoes") ? "selected" : "" %>>Shoes</option>
            <option value="apparel" <%= category.equals("apparel") ? "selected" : "" %>>Apparel</option>
            <option value="jewelry" <%= category.equals("jewelry") ? "selected" : "" %>>Jewelry</option>
        </select><br><br>
        
        <label>Type:</label>
        <select name="type" required>
            <option value="casual" <%= type.equals("casual") ? "selected" : "" %>>Casual</option>
            <option value="formal" <%= type.equals("formal") ? "selected" : "" %>>Formal</option>
            <option value="other" <%= type.equals("other") ? "selected" : "" %>>Other</option>
        </select><br><br>
        
        <label>Image:</label>
        <input type="file" name="picture" required>
        <input type="hidden" name="id" value="<%=id%>"> 
        <input type="submit" value="Update">
    </form>
</body>
</html>
