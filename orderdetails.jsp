<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            border: none;
        }
        th, td {
            
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        a{
            background-color: #4CAF50;
            color: white;
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 1rem;
            text-decoration: none;
        }
       .update-btn {
            background-color: #4CAF50;
            color: white;
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;

        }
       a:hover, .update-btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h2>Order Details</h2>
    <a href="admin.jsp">back</a>
    <table>
        <tr>
            <th>Order Number</th>
            <th>Email</th>
            <th>Date</th>
            <th>Time</th>
            <th>Amount</th>
            <th>Status</th>
            <th></th>
        </tr>
        <% 
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                String query = "SELECT orders.OrderID, users.email, orders.orderDate, orders.orderTime, orders.totalamount, orders.status FROM orders INNER JOIN users ON orders.userID = users.userID";
                stmt = con.prepareStatement(query);
                rs = stmt.executeQuery();
                while (rs.next()) {
                    String orderID = rs.getString("orderID");
                    String userEmail = rs.getString("email");
                    String orderDate = rs.getString("orderDate");
                    String orderTime = rs.getString("orderTime");
                    double totalAmount = rs.getDouble("totalamount");
                    String status = rs.getString("status");
        %>
        <tr>
            <td><%= orderID %></td>
            <td><%= userEmail %></td>
            <td><%= orderDate %></td>
            <td><%= orderTime %></td>
            <td>$<%=String.format("%.2f",totalAmount)%></td>
            <td><%= status %></td>
            <td>
               
                    <form action="updateOrder" method="post">
                        <input type="hidden" name="orderID" value="<%= orderID %>">
                        <input type="submit" class="update-btn" value="Update">
                    </form>
               
            </td>
        </tr>
        <% 
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </table>
    
</body>
</html>
