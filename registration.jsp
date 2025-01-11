<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/registration.css"/>
        <title>sign up</title>
        
    </head>
    <body>
        
        <section>
            <div class="First">
                <a href="index.jsp" style="text-decoration:none;">
                <image src="pictures/shopping.avif"/>    
                </a>
            </div>
            <div class="Second"> 
                 <h1>Registration</h1>  
                <span style="color: red">${errorMessage}</span> 
                <form action="./registration" method="post">
                    <label>FirstName</label>  
                    <input type="text" name="fname"/>
                     <label>LastName</label>  
                     <input type="text" name="lname"/><br>
                     <label>Email</label>  
                    <input type="text" name="email"/>
                     <label>Address</label>  
                     <input type="text" name="address"/><br>
                      <label>Country</label>  
                     <input type="text" name="country"/><br>
                    <label>Phone Number</label>  
                    <input type="text" name="phone"/>
                    <label>Username</label>  
                    <input type="text" name="uname"/><br>
                    <label>Password</label>  
                    <input type="password" name="pass"/>
                    <label>Confirm Password</label>  
                    <input type="password" name="confirm"/><br>
                    <label>gender</label>  
                    <select name="gender">
                    <option value="male">male</option>
                    <option value="female">female</option>
                    </select>
                   <input type="submit" value="Sign Up"/>
                </form>
            </div>
        </section>
    </body>
</html>
