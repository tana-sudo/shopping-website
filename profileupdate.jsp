<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile</title>
    <link rel="stylesheet" href="css/profileupdate.css">
</head>
<body>
    <section> 
        <div class="second">
            <h1>Update Profile</h1>
            <span>${errorMessage}</span>
            <button onclick="window.location.href='shopping.jsp'">back</button>
            <form action="profileupdate" method="post">
                 <% 
            Connection con = null;
            PreparedStatement st = null;
            ResultSet rs = null;
            double subtotal = 0.0;
            String sesh = (String)session.getAttribute("email");
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/java", "root", "");
                String sqls = "Select * from users where email=?";
                PreparedStatement psst = con.prepareStatement(sqls);            
                 psst.setString(1, sesh);                
                 ResultSet rss = psst.executeQuery();
                 if(rss.next())
                 {
                   String fname=rss.getString(2);
                   String lname=rss.getString(3);
                   String email=rss.getString(4);
                   String address=rss.getString(5);
                   String country=rss.getString(6);
                   String phone=rss.getString(7);
                   String uname=rss.getString(8);
                   String gender=rss.getString(11);
        %>
                <label for="fname">First Name</label>
                <input type="text" id="fname" name="fname" value="<%=fname%>" required>
                <label for="lname">Last Name</label>
                <input type="text" id="lname" name="lname" value="<%=lname%>"  required><br>
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%=email%>"  required>
                <label for="address">Address</label>
                <input type="text" id="address" name="address" value="<%=address%>"  required><br>
                <label for="country">Country</label>
                <input type="text" id="country" name="country" value="<%=country%>"  required><br>
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" value="<%=phone%>"  required>
                <label for="uname">Username</label>
                <input type="text" id="uname" name="uname" value="<%=uname%>"  required><br>
                <label for="gender">Gender</label>
                <select id="gender" name="gender">
                    <option value="male" <%= gender.equals("male") ? "selected" : "" %>>Male</option>
                    <option value="female"<%= gender.equals("female") ? "selected" : "" %>>Female</option>
                </select><br>
                <input type="hidden" name="sesh" value="<%=sesh%>"/> 
                <input type="submit" value="Update Profile">
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
            </form>
        </div>
    </section>
</body>
</html>
