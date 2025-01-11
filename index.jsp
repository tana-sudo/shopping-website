<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <title>login</title>
     <script>       
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
    </script>
</head>
<body>
    <div class="container" id="container">
        <div class="form-container sign-in">
            <form action="login" method="post">
                <h1>Sign In</h1>
               <span style="color: red">${errorMessage}</span> 
                <input type="email" placeholder="Email" name="email">
                <input type="password" placeholder="Password" name="password">
                <a href="registration.jsp">Don't have an account</a>
                <button type="submit" class="submit" name="submit">Sign In</button>
            </form>
        </div>
        <div class="toggle-container">
            <div class="toggle">
                <image src="icons/main.jpg"/>
             </div>
        </div>
    </div>
  </body>
</html>
