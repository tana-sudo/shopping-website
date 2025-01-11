<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Random" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>checkout</title>
</head>
<body>
<% 
    Connection con = null;
    PreparedStatement st = null;
    ResultSet rs = null;
    double subtotal = 0.0;
    String sesh = (String) session.getAttribute("email");
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");

        // Get user's ID
        String sqls = "SELECT * FROM users WHERE email=?";
        PreparedStatement psst = con.prepareStatement(sqls);
        psst.setString(1, sesh);
        ResultSet rss = psst.executeQuery();
        if (rss.next()) {
            int userID = rss.getInt("UserID");

            // Generate unique order ID based on current time and random number
            long currentTime = System.currentTimeMillis();
            Random random = new Random();
            int randomNum = random.nextInt(1000); // Generate a random number between 0 and 999
            String orderID = String.valueOf(currentTime) + String.valueOf(randomNum);

            // Insert into Orders table
            String insertOrderQuery = "INSERT INTO Orders (orderID, userID, totalamount) VALUES (?, ?,  ?)";
            PreparedStatement insertOrderStmt = con.prepareStatement(insertOrderQuery);
            insertOrderStmt.setString(1, orderID);
            insertOrderStmt.setInt(2, userID);
            insertOrderStmt.setDouble(3, 0.0); // Placeholder for TotalAmount, will be updated later
            insertOrderStmt.executeUpdate();
            
            // Get items in the cart for the user
            String sql = "SELECT * FROM Cart WHERE UserID=?";
            st = con.prepareStatement(sql);
            st.setInt(1, userID);
            rs = st.executeQuery();
            while (rs.next()) {
                String name = rs.getString("name");
                int quantity = rs.getInt("Quantity");
                double unitPrice = rs.getDouble("price");
                // Get unit price from the Product table
                String getProductQuery = "SELECT*FROM products WHERE product_name=?";
                PreparedStatement getProductStmt = con.prepareStatement(getProductQuery);
                getProductStmt.setString(1, name);
                ResultSet productRS = getProductStmt.executeQuery();
                if (productRS.next()) {
                    String productID = productRS.getString("stockID");
                    

                    // Insert into OrderDetails table
                    String query = "INSERT INTO orders_details (OrderID, stockID, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
                    PreparedStatement tmt = con.prepareStatement(query);
                     tmt.setString(1, orderID);
                     tmt.setString(2, productID);
                     tmt.setInt(3, quantity);
                     tmt.setDouble(4, unitPrice);
                     tmt.executeUpdate();

                    // Calculate subtotal
                    subtotal += (unitPrice * quantity);
                }
            }

            // Update TotalAmount in Orders table
         String updateQuery = "UPDATE Orders SET totalamount=? WHERE orderID=?";
PreparedStatement updateStmt = con.prepareStatement(updateQuery);
double totalAmount = subtotal * 1.14; 
updateStmt.setDouble(1, totalAmount);
updateStmt.setString(2, orderID);
boolean updated = updateStmt.execute();
if (!updated) {
    String deleteQuery = "DELETE FROM cart WHERE userID=?";
    PreparedStatement deleteStmt = con.prepareStatement(deleteQuery);
    deleteStmt.setInt(1, userID);
    int deletedRows = deleteStmt.executeUpdate();
    if (deletedRows > 0) {
        response.sendRedirect("thankyou.jsp?id="+orderID);
    }
}

            
        }
    } catch (Exception e) {
        out.println(e);
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (con != null) con.close();
        } catch (Exception e) {
            out.println(e);
        }
    }
%>
</body>
</html>
