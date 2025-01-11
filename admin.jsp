<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>admin</title>
        <link rel="stylesheet" href="css/admin.css"/>
         <script>
        function openEditDialog() {
           alert("Deleted successsfully")
        }
    </script>
    </head>
    <body>
       <%
    // Check if the session variable "email" is empty
    String mail = (String) session.getAttribute("email");
    if (mail == null || mail.isEmpty()) {
        response.sendRedirect("index.jsp");
    } else {
%>
        <section class="First">      
            <h1>Inventory Management</h1>  
            <form action="logout" method="post" >
                 <input type="submit" value="Logout" class="logout" >
            </form>
            <a class="logt" href="orderdetails.jsp" style="text-decoration:none;">vieworders</a>
            <a href="profileupdate_1.jsp" class="tops">
                <image src="icons/group.png" class="imges" style="width: 3vw; margin-left:90%;" />
            <span class="top">
               <%
    try {
        // Retrieve email from session
        String email = (String) session.getAttribute("email");
        if (email != null) {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
            String sql = "SELECT username FROM users WHERE email=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String username = rs.getString("username");
                out.println(username);
            } else {
                out.println("User not found"); 
            }

           
            rs.close();
            pstmt.close();
            conn.close();
        } else {
            out.println("Session not found"); 
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage()); 
    }
    %>   
            </span>
            </a>
           
        </section>
        <section class="second">
            <div class="table-data">
                <table class="goods">
                    <tr>
                        <td>Image</td>
                        <td>Name</td>
                        <td>Price</td>
                        <td>Quantity</td>
                        <td>Category</td>
                        <td>Type</td>
                        <td>Action</td>   
                    </tr> 
   <%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
        st = con.createStatement();
        String sql = "SELECT * FROM products"; 
        rs = st.executeQuery(sql);
        while (rs.next()) {
            String id = rs.getString(1);
            String name = rs.getString(2);
            String price = rs.getString(3);
            String quantity = rs.getString(4);
            String category = rs.getString(5);
            String type = rs.getString(6);
            String filename = rs.getString(7);
            
            
%>
                    
                       <tr>
                           <td><image src="<%=filename%>" class="images"/></td>
                        <td><%=name%></td>
                        <td>$<%=price%></td>
                        <td><%=quantity%></td>
                        <td><%=category%></td>
                        <td><%=type%></td>
                        <td><a href="update.jsp?id=<%=id%>"  name="edit" class="crud edit-btn">Edit</a><br><a href="delete.jsp?id=<%=id%>" class="crud delete-btn" onclick="openEditDialog();">Delete</a></td>   
                    </tr> 
                   
                    <%
        }
    } catch (Exception e) {
        out.println(e);
    } finally {
        // Close resources in the finally block to ensure they are always closed
        try { if (rs != null) rs.close(); } catch (Exception e) { /* ignored */ }
        try { if (st != null) st.close(); } catch (Exception e) { /* ignored */ }
        try { if (con != null) con.close(); } catch (Exception e) { /* ignored */ }
    }
}
%>

                </table>

            </div>
            <div class="inventory">
                <span>${successMessage}</span> 
                <form action="admin" method="post" enctype="multipart/form-data">
                    <label>Name</label> 
                    <input type="text" name="pname" class="p_text" required/><br>
                    <label>Price</label> 
                    <input type="text" name="price" class="p_text" required/><br>
                    <label>Quantity</label> 
                    <input type="number" name="qty"  value="1" min="1" class="p_text" required/><br>
                    <label>Category</label> 
                    <select name="category" id="category" required/>
                    <option value="footwear">footwear</option>
                    <option value="apparel">Apparel</option>
                    <option value="accessories">Accessories</option>
                   </select>
                   <label>Type</label> 
                   <select name="type" id="type" required/>
                    <option value="casual">Casual</option>
                    <option value="formal">Formal</option>
                    <option value="other">other</option>
                   </select>
                   <input type="file" accept="image/*" name="p_image" required/>
                   <input type="submit" value="Add Product">
                </form>  
            </div>
        </section>
           
       </body>
</html>
