<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/cart.css"/>
    <title>Shopping Cart</title>
</head>
<body>
    <h2>Shopping Cart</h2>
    <table>
        <tr>
            <th>Item</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
            <th></th>
        </tr>
        <% 
            Connection con = null;
            PreparedStatement st = null;
            ResultSet rs = null;
            double subtotal = 0.0;
            String sesh = (String)session.getAttribute("email");
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                String sqls = "Select*from users where email=?";
                PreparedStatement psst = con.prepareStatement(sqls);            
                 psst.setString(1, sesh);                
                 ResultSet rss = psst.executeQuery();
                 if(rss.next())
                 {
                String ids = rss.getString(1);
                String sql = "SELECT * FROM cart where userID=?";
                st = con.prepareStatement(sql); 
                st.setString(1, ids); 
                rs = st.executeQuery();
                while (rs.next()) {
                    String id = rs.getString(1);                  
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    int quantity = rs.getInt("quantity");
                    String picture = rs.getString("picture");
                    double total = price * quantity;
                    subtotal += total;
        %>
        <tr>
            <td><img src="<%=picture%>" alt="<%=name%>" class="picture"/> <%=name%></td>
            <td>$<%=price%></td>
            <td><%=quantity%></td>
            <td>$<%=total%></td>
            <td><a href="removecart.jsp?id=<%=id%>">remove</a></td>
        </tr>
        <% 
                }
}
            } catch (Exception e) {
                out.println(e);
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) { }
                try { if (st != null) st.close(); } catch (Exception e) { }
                try { if (con != null) con.close(); } catch (Exception e) { }
            }
        %>
        <tr>
            <td colspan="3">Subtotal:</td>
            <td>$<%=subtotal%></td>
        </tr>
        <tr>
            <td colspan="3">Tax (14%):</td>
            <td>$<%=String.format("%.2f", subtotal * 0.14)%></td>
        </tr>
        <tr>
            <td colspan="3"><strong>Total:</strong></td>
            <td><strong>$<%=String.format("%.2f", subtotal * 1.14)%></strong></td>
        </tr>
    </table> 
        <button onclick="window.location.href='checkout.jsp'"><strong>Checkout</strong></button>
</html>
