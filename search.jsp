<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Search</title>
    <style>
            section{
        display: flex;
        margin-top: 10px;
    }
         .shoptingz {
       
        flex-direction: column;
        align-items: center;
        border: 1px solid #ccc;
        padding: 15px;
        margin: 10px;
        width: 230px; 
        transition: transform 0.3s;
        
    }
    .shoptingz:hover {
        transform: scale(1.05); 
    }

    
    .components-tingz {
         width: 220px; 
         height: 28vh;
         margin-left: 5px;
         margin-right: 5px;
         margin-top: 5px;
    }

    .tingzz {
        font-weight: bold;
       margin: 10px;
    }
    .bton{
        background-color: #4CAF50;
        color: white;
        padding: 8px 16px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        border-radius: 4px;
        cursor: pointer;
        margin: 5px;
        width: 40%;
        margin-left:20rem;
        height:auto; 
    }
     .btn {
        background-color: #4CAF50;
        color: white;
        padding: 8px 16px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        border-radius: 4px;
        cursor: pointer;
        margin: 5px;
        width: 100%;
        height:auto;
        
    }

    /* Hover effect for the button */
    .btn:hover {
        background-color: #45a049;
    }
    input[type="number"] {
        width: 50px; 
        text-align: center;
        margin: 5px;
    }
    .spanela{
        font-family:  Ariel;
        font-size: 30px
    }
    .cart-image{
            width: 2.5vw;
            height: auto;
            margin-left: 6rem;
        }
    </style>
</head>
<body>
    <span class="spanela">searching for items relative to : <strong><%=request.getParameter("search")%></strong></span>
    <a href="cart.jsp" class="cart"><img src="icons/basket.png" class="cart-image"/> 
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
</a>

    <section>
        <%
            String searchs = request.getParameter("search");
            Connection con = null;
            Statement st = null;
            ResultSet rs = null;
            try {
                if(searchs != null && !searchs.isEmpty()) {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                    st = con.createStatement();
                    String sql = "SELECT * FROM products WHERE product_name LIKE '%" + searchs + "%'";
                    rs = st.executeQuery(sql);
                    while (rs.next()) {
        %>
        <div class="shoptingz option1">
            <form action="cart" method="post">
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
                }
            } catch (Exception e) {
                out.println(e);
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) { }
                try { if (st != null) st.close(); } catch (Exception e) { }
                try { if (con != null) con.close(); } catch (Exception e) { }
            }
        %>
    </section>
     <input type="submit" value="Continue Shopping" class="bton" onclick="window.location.href='shopping.jsp'">
</body>
</html>
