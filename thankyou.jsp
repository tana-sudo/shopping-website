<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Invoice</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .customer-details {
            margin-bottom: 20px;
        }
        .details {
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th,td {
            border: none;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        hr {
            border: none;
            border-top: 1px solid #ddd;
        }
        .total-row {
            font-weight: bold;
        }
        button{
            font-family: Gothic;
            font-size:30px;
            padding: 10px;
            background-color: #7DF9FF;
            color: black;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 7px;
            margin-left: 25rem;
            margin-right: 25rem;
            height: 10vh;
            width: 30vw;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Invoice</h1>
        <div class="customer-details">
            <% Connection conn = null;                  
                String sesh = (String)session.getAttribute("email");
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                    String sqls = "Select * from users where email=?";
                    PreparedStatement psst = conn.prepareStatement(sqls);            
                     psst.setString(1, sesh);                
                     ResultSet rss = psst.executeQuery();
                     if(rss.next())
                     {
                      String fname = rss.getString("firstname");
                      String lname = rss.getString("lastname");
                      String address = rss.getString("address");
                      String country = rss.getString("country");
                      String phone = rss.getString("phonenumber");
                %>
                <label><strong>Customer Name:</strong></label> <%=fname%> <%=lname%><br>
                <label><strong>Address:</strong></label> <%=address%><br>
                <label><strong>Country:</strong></label> <%=country%><br>
                <label><strong>Phone Number:</strong></label> <%=phone%><br>
                <% 
                        }
                } catch (Exception e) {
                    out.println(e);
                } 
            %>
        </div>
        <div class="details">
            <h2>Order Details</h2>
            <% 
                Connection con = null;
                PreparedStatement st = null;
                ResultSet rs = null;
                double subtotal = 0.0;
                String orderID =request.getParameter("id");
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");

                    // Retrieve order details
                    String query = "SELECT od.*, p.product_name FROM orders_details od JOIN products p ON od.stockID = p.stockID WHERE orderID=?";
                    st = con.prepareStatement(query);
                    st.setString(1, orderID);
                    rs = st.executeQuery();
            %>
            <table>
                <tr>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total</th>
                </tr>
                <% 
                    while (rs.next()) {
                        String itemName = rs.getString("product_name");
                        int quantity = rs.getInt("quantity");
                        double unitPrice = rs.getDouble("unitPrice");
                        double itemSubtotal = quantity * unitPrice;
                        subtotal += itemSubtotal;
                %>
                <tr>
                    <td><%= itemName %></td>
                    <td><%= quantity %></td>
                    <td>$<%= unitPrice %></td>
                    <td>$<%= itemSubtotal %></td>
                </tr>
                <% } %>
                <tr class="total-row">
                    <td colspan="3" style="text-align: right;">Subtotal:</td>
                    <td>$<%= subtotal %></td>
                </tr>
                <tr class="total-row">
                    <td colspan="3" style="text-align: right;">Tax (14%):</td>
                    <td>$<%=String.format("%.2f", subtotal * 0.14)%></td>
                </tr>
                <tr>
                    <td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
                    <td><strong>$<%=String.format("%.2f", subtotal * 1.14)%></strong></td>
                </tr>
            </table>
            <% 
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
        </div>
    </div>
   <button onclick="window.location.href='shopping.jsp'"><strong>Continue Shopping</strong></button>
</body>
</html>
