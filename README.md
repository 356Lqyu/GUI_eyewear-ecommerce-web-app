# Four Eyes Collective – Eyewear & Sunglasses E-Commerce System

Four Eyes Collective is a Java-based e-commerce web application.

The system provides an online shopping platform where customers can browse eyewear products, manage shopping carts, make purchases, and submit product ratings and comments. It also includes separate dashboards and management functionalities for staff and managers.

## Project Overview

- **Project Name:** Four Eyes Collective
- **Project Type:** E-Commerce Web Application
- **Product Category:** Eyewear & Sunglasses
- **Architecture:** Model–View–Controller (MVC)
- **Development Language:** Java
- **Database:** Apache Derby

## Technologies Used

| Technology | Purpose |
|---|---|
| Java | Backend application development |
| Java Servlets | Handle HTTP requests and application logic |
| JSP | Generate dynamic web pages |
| HTML & CSS | Website structure and styling |
| Java Persistence API (JPA) | Database persistence and entity management |
| Apache Derby | Relational database management |
| GlassFish Server | Java web application deployment |
| Java Sessions | Manage user sessions and authentication |
| NetBeans IDE | Application development and deployment |

## System Features

### 1. Guest Module
- Browse the home page and featured products.
- View eyewear products and product details.
- Search for products using product IDs.
- Filter products by category.
- View promotions and company information.
- Access customer and management login pages.

### 2. Customer Module
- Register and log in to a customer account.
- Recover forgotten passwords and reset passwords.
- View and update personal profile information.
- Browse and search products.
- Add products to the shopping cart.
- Update product quantities and remove cart items.
- View order summaries, delivery fees, and sales tax.
- Select payment methods and submit orders.
- View order confirmation and purchase history.
- Rate products and submit comments.

### 3. Staff Module
- Access the staff dashboard.
- View customer records and order information.
- Add and modify product categories.
- Add and modify product information.
- Upload and manage promotions.
- View and manage customer feedback and ratings.

### 4. Manager Module
- Access the manager dashboard.
- Add, view, modify, and delete staff accounts.
- Add, view, modify, and delete customer accounts.
- Manage product categories.
- Manage product information.
- Upload promotions.
- View monthly sales reports.
- View product reports and customer order records.

## E-Commerce Business Rules

- Customers must log in before accessing their shopping cart and completing purchases.
- A delivery fee of **RM25** applies to purchases below RM1,000.
- Free delivery is provided for purchases of RM1,000 and above.
- A **6% sales tax** is included during checkout.
- Different user roles have different access permissions.
- Staff and managers have separate management privileges.

## MVC Architecture

The application follows the Model–View–Controller (MVC) design pattern.

| Component | Responsibility |
|---|---|
| Model | Represents application data, database entities, and business operations. |
| View | JSP and HTML pages that display information and provide user interfaces. |
| Controller | Java Servlets that process requests, handle application logic, and communicate with models. |

**Project Structure**

```text
FourEyesCollective/
│
├── src/
│   ├── java/
│   │   ├── controller/       # Java Servlets
│   │   └── model/            # Entity classes and services
│   │
│   └── conf/
│       └── persistence.xml   # JPA configuration
│
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml           # Web application configuration
│   │   └── glassfish-resources.xml
│   │
│   ├── secureCustomer/       # Customer pages
│   ├── secureStaff/          # Staff pages
│   ├── secureManager/        # Manager pages
│   ├── Images/               # Product and website images
│   ├── Promotion/            # Promotion images
│   │
│   ├── home.jsp
│   ├── Product.jsp
│   ├── Promotion.jsp
│   ├── CustomerLogin.jsp
│   └── ManagementLogin.jsp
│
├── nbproject/                # NetBeans project configuration
├── build/                    # Generated build output
├── build.xml                 # Ant build configuration
└── README.md
```

## Installation and Setup

### Prerequisites

Install the following software before running the project:

1. JDK 11
2. NetBeans IDE with Java Web and Enterprise development support.
3. GlassFish Server 6.1 or a compatible Jakarta EE 9.1 server.
4. Apache Derby Network Server.

### Step 1: Clone the Repository

```bash
git clone https://github.com/356Lqyu/FourEyesCollective.git
```

Open the project folder using NetBeans IDE.

### Step 2: Configure Apache Derby

1. Start the Apache Derby Network Server.
2. Ensure that the Derby server is running on port `1527`.
3. Configure the database connection using the following settings:

| Setting | Value |
|---|---|
| Database Name | FourEyesCollectiveDB |
| Host | localhost |
| Port | 1527 |
| Username | nbuser |
| Password | nbuser |
| JDBC URL | jdbc:derby://localhost:1527/FourEyesCollectiveDB |

### Step 3: Configure the JDBC Resource

In GlassFish Server, configure the JDBC connection pool and JDBC resource according to:

- **JDBC Resource Name:** `java:app/jdbc/FourEyesCollectiveDB`
- **Connection Pool:** Derby Network Client
- **Database:** FourEyesCollectiveDB

The project includes `glassfish-resources.xml` under `web/WEB-INF/` as a reference for the database resource configuration.

### Step 4: Configure JPA

The JPA configuration is located at:

```text
src/conf/persistence.xml
```

The persistence unit is named:

```text
FourEyesCollectivePU
```

It uses JTA transactions and the configured GlassFish JDBC resource.

### Step 5: Build and Run

1. Open the project in NetBeans.
2. Set GlassFish Server as the deployment server.
3. Right-click the project.
4. Select **Clean and Build**.
5. Select **Run** to deploy the application.

The application should open at:

```text
http://localhost:8080/FourEyesCollective/
```

The home page is configured as the application's welcome page.

## Database Files

The project includes:

- `web/SQL.sql` – SQL script containing database table definitions and sample records.
- `src/conf/persistence.xml` – JPA persistence configuration.
- `web/WEB-INF/glassfish-resources.xml` – GlassFish JDBC resource configuration.

Review the SQL script and database setup before importing sample data. The JPA configuration also enables database schema generation.

## Security and Access Control

The application implements role-based access control for customers, staff, and managers.

- Customers can access customer-related shopping and profile functions.
- Staff can access staff management functions.
- Managers have administrative access to management functions.
- Unauthorized access to protected management pages is restricted through web container security constraints.
