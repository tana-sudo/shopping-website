<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/shopping.css"/>
    <title>apparel</title>
    <script>
        function updateItems() {
            var selectedValue = document.getElementById("sortbyDropdown").value;
            var items = document.getElementsByClassName("shoptingz");
            for (var i = 0; i < items.length; i++) {
                items[i].style.display = "none";
            }
            var selectedItems = document.getElementsByClassName(selectedValue);
            for (var j = 0; j < selectedItems.length; j++) {
                selectedItems[j].style.display = "block";
            }
        } 
              let isConverted = false; 

function convertCurrency() {
    if (!isConverted) {
        fetch('https://api.exchangerate-api.com/v4/latest/USD')
            .then(response => response.json())
            .then(data => {
                var conversionRate = 13.60; 
                var prices = document.querySelectorAll('.price');
                prices.forEach(price => {
                    var originalPrice = parseInt(price.textContent.substring(1)); // Convert price to integer
                    var convertedPrice = originalPrice * conversionRate;
                    price.textContent = 'BWP ' + convertedPrice.toFixed(2); // Format to two decimal places
                });
                
                isConverted = true; 
            })
            .catch(error => {
                console.error('Error fetching exchange rate:', error);
            });
    } else {
     
        var prices = document.querySelectorAll('.price');
        prices.forEach(price => {
            var originalPrice = parseFloat(price.textContent.substring(4)); 
            var another=0.074;
            var total=originalPrice*another;
            price.textContent = '$' + total.toFixed(0); 
        });
        
        isConverted = false; 
    }
}
    </script>
</head>
<body>
    <header>
        <a href="shopping.jsp"><image src="icons/logo.jpg" class="logo"/></a>
        <nav>
            <ul>
                <li><a href="apparel.jsp" class="category">Apparel</a></li>
                <li> <label for="sort">Sort by:</label></li>
                <li><select id="sortbyDropdown" onchange="updateItems()">
                        <option value="option1">Default Order</option>
                        <option value="option2">Price Ascending</option>
                        <option value="option3">Price Descending</option>
                    </select></li>
                <li><button type="submit" class="currency"onclick="convertCurrency()">usd-pula</button></li>
                <li> <a href="cart.jsp" class="cart"><img src="icons/basket.png" class="cart-image"/> 
               <span class="cart-count"> 
    <% 
    String sesh = (String)session.getAttribute("email");
    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
        String sqls = "SELECT * FROM users WHERE email=?";
        PreparedStatement psst = con.prepareStatement(sqls);            
        psst.setString(1, sesh);                
        ResultSet rss = psst.executeQuery();
        if(rss.next()) {
            String ids = rss.getString(1);
            String countSql = "SELECT COUNT(*) AS cartCount FROM cart WHERE userID=?";
            PreparedStatement countPs = con.prepareStatement(countSql);
            countPs.setString(1, ids); // Corrected method invocation
            ResultSet countRs = countPs.executeQuery();
            countRs.next();
            int cartCount = countRs.getInt("cartCount");
            
            // Close the result set and prepared statement
            countRs.close();
            countPs.close();
            
            // Display the cart count
            out.println(cartCount);
            
            // Close the connection
            con.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } 
    %>
</span>

                </a></li>
             <form action="logout" method="post" >
                 <input type="submit" value="Logout" class="logout" >
            </form>
                <li> <a class="user-logo" href="profileupdate.jsp"><image src="icons/user.png" class="user"/>
                        <span> <%
    try {
        // Retrieve email from session
        String email = (String) session.getAttribute("email");
        if (email != null) {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
            String sql = "SELECT username FROM users WHERE email=?";
            PreparedStatement pstmt = con.prepareStatement(sql);
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
            con.close();
        } else {
            out.println("Session not found"); 
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage()); 
    }
    %></span></a></li>
            </ul>
        </nav>
 <form action="search.jsp" method="post">
<div class="search-container">
    <input type="text" name="search" class="search_btn" placeholder="Search"/>
    <button type="submit" name="buttonsub"><img src="icons/search.jpg" class="search" /></button>
</div>
</form>
    </header>

    <section>
        <%
            Connection con = null;
            Statement st = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                st = con.createStatement();
                String sql = "SELECT * FROM products where category='apparel'"; 
                rs = st.executeQuery(sql);
                while (rs.next()) {
                    String id = rs.getString(1);
        %>
        <div class="shoptingz option1">
            <form action="cart3" method="post">
            <image src="<%=rs.getString(7)%>" class="components-tingz"/><br>
            <span class="tingzz"><%=rs.getString(2)%></span><br>
            <span class="tingzz price">$<%=rs.getString(3)%></span><br>
            <span><input type="number" name="qty" value="1" min="1"/></span><br>
            <input type="hidden" name="name" value="<%=rs.getString(2)%>"/>
            <input type="hidden" name="price" value="<%=rs.getString(3)%>"/>
            <input type="hidden" name="picture" value="<%=rs.getString(7)%>"/>
            <input type="hidden" name="sesh" value="<%=session.getAttribute("email")%>"/>
            <button class="btn" type="submit">Add To Cart</button>
            </form>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println(e);
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) { }
                try { if (st != null) st.close(); } catch (Exception e) { }
                try { if (con != null) con.close(); } catch (Exception e) { }
            }
        %>
        <%
            Connection con2 = null;
            Statement st2 = null;
            ResultSet rs2 = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                st2 = con2.createStatement();
                String sql2 = "SELECT * FROM products where category='apparel' ORDER BY price ASC"; 
                rs2 = st2.executeQuery(sql2);
                while (rs2.next()) {
                    String id = rs2.getString(1);
        %>
        <div class="shoptingz option2" style="display: none;">
            <form action="cart3" method="post">
            <image src="<%=rs2.getString(7)%>" class="components-tingz"/><br>
            <span class="tingzz"><%=rs2.getString(2)%></span><br>
            <span class="tingzz price">$<%=rs2.getString(3)%></span><br>
            <span><input type="number" name="qty" value="1" min="1"/></span><br>
             <input type="hidden" name="name" value="<%=rs2.getString(2)%>"/>
            <input type="hidden" name="price" value="<%=rs2.getString(3)%>"/>
            <input type="hidden" name="picture" value="<%=rs2.getString(7)%>"/>
            <input type="hidden" name="sesh" value="<%=session.getAttribute("email")%>"/>
            <button class="btn" type="submit">Add To Cart</button>
            </form>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println(e);
            } finally {
                try { if (rs2 != null) rs2.close(); } catch (Exception e) { }
                try { if (st2 != null) st2.close(); } catch (Exception e) { }
                try { if (con2 != null) con2.close(); } catch (Exception e) { }
            }
        %>
        <%
            Connection con3 = null;
            Statement st3 = null;
            ResultSet rs3 = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                st3 = con3.createStatement();
                String sql3 = "SELECT * FROM products where category='apparel' ORDER BY price DESC "; 
                rs3 = st3.executeQuery(sql3);
                while (rs3.next()) {
                    String id = rs3.getString(1);
        %>
        <div class="shoptingz option3" style="display: none;">
            <form action="cart3" method="post">
            <image src="<%=rs3.getString(7)%>" class="components-tingz"/><br>
            <span class="tingzz"><%=rs3.getString(2)%></span><br>
            <span class="tingzz price">$<%=rs3.getString(3)%></span><br>
            <span><input type="number" name="qty" value="1" min="1"/></span><br>
            <input type="hidden" name="name" value="<%=rs3.getString(2)%>"/>
            <input type="hidden" name="price" value="<%=rs3.getString(3)%>"/>
            <input type="hidden" name="picture" value="<%=rs3.getString(7)%>"/>
            <input type="hidden" name="sesh" value="<%=session.getAttribute("email")%>"/>
            <button class="btn" type="submit">Add To Cart</button>
            </form>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println(e);
            } finally {
                try { if (rs3 != null) rs3.close(); } catch (Exception e) { }
                try { if (st3 != null) st3.close(); } catch (Exception e) { }
                try { if (con3 != null) con3.close(); } catch (Exception e) { }
            }
        %>
    </section>

    <footer>
        <span></span>
    </footer>
</body>
</html>
