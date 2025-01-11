<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>checkout</title>
    <link rel="stylesheet" href="css/checkout.css"/>
</head>
<body>
    <main>
    <section>      
        <form action="processorder.jsp">
            <div class="row">
                <div class="payment">
                    <h2>Payment</h2>
                    <label for="cname">Name on Card</label>
                    <input type="text" id="cname" name="cardname" placeholder="Tanatswa Mutandwa J" class="zvimwe" required/>
                    <label for="ccnum">Credit card number</label>
                    <input type="text" id="ccnum" name="cardnumber" placeholder="1111-2222-3333-4444" class="zvimwe" required><br>
                    <div class="altering">
                    <label for="expmonth">Exp Month</label>
                    <input type="text" id="expmonth" name="expmonth" placeholder="January" class="year" required>           
                    <label for="expyear">Exp Year</label>
                    <input type="text" id="expyear" name="expyear" placeholder="2025" class="year" required>
                    <label for="cvv">CVV</label>
                    <input type="text" id="cvv" name="cvv" placeholder="562" class="year" required>
                    </div>
                </div>
            </div>    
            <input type="submit" value="Continue to checkout" class="btn">
        </form>
        <div class="container">
            <h2>Order Details</h2>
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
      <p>
    <img src="<%=picture%>" alt="alt" class="pic" />
    <span class="name"><%=name%></span>
    <span class="qty">qty(<%=quantity%>)</span>
    <span class="price">$<%=price%></span>
   </p>
           
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
        </div>
    </section>
        <aside>
            <div class="tops">
                <h2>Summary</h2>            
                original Price<span class="summary">$<%=subtotal%></span><br>
                Tax(14%)<span class="summary1">$ <%=String.format("%.2f", subtotal * 0.14)%></span><br>
                 <hr>
                 Total<span class="summary2"><strong>$<%=String.format("%.2f", subtotal * 1.14)%></strong></span><br>
                 <input type="submit" value="Continue Shopping" class="btn" onclick="window.location.href='shopping.jsp'">
            </div>
        </aside>
   </main>
</body>
</html>
