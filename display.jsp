<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Image Show</title>
</head>
<body>
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
            String filename = rs.getString("picture");
%>

<table style="width:100%">
    <tr>
        <th>Id</th>
        <th>Image</th>
    </tr>
    <tr>
        <td></td>
        <td><image src="<%=filename%>" width="200" height="200"/></td>
    </tr>
</table>

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
%>
<br>
<center><a href="viewAll.jsp">View All </a></center>
</body>
</html>
