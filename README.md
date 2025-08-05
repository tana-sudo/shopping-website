# Shopping Website

A simple Java-based shopping website built with JSP and Servlets. This project allows users to browse products, manage their cart, register/login, and place orders. Admin functionality is included for product management.

## Features

- User registration and login
- Product browsing (apparel, jewelry, shoes)
- Shopping cart management
- Order checkout and order history
- Profile update functionality
- Admin panel for product management (add, update, delete)
- File upload support for product images

## Project Structure


## Setup & Running

1. **Requirements**
   - Java Development Kit (JDK) 8 or higher
   - Apache Tomcat or any compatible servlet container
   - MySQL or another supported database (configure DB connection in servlets)

2. **Build & Deploy**
   - Import the project into your IDE (e.g., Eclipse, IntelliJ)
   - Configure your servlet container (Tomcat) and database connection
   - Deploy the project to the server
   - Access the website at `http://localhost:8080/shopping-website-main/`

3. **Database**
   - Create the necessary tables for users, products, orders, and cart
   - Update database connection details in the servlet files as needed

## Usage

- **Users:** Register, log in, browse products, add to cart, and place orders.
- **Admin:** Log in via the admin panel to add, update, or delete products.

## Notes

- File upload for product images is supported in the admin panel.
- Session management is used for user authentication and cart tracking.

## License

This project is for educational
