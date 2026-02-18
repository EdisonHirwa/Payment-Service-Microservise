# 💳 Payment Service Microservice

> **Smart Campus — Distributed University Management System**  
> **Group 8** | Backend Development with Java

A RESTful Payment Service built with **Java Servlet**, **JSP**, **JDBC**, and **MySQL**, following the **MVC architecture** pattern. Part of the Smart Campus microservice ecosystem for managing student tuition payments.

---

## 📋 Table of Contents

- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [Database Schema](#-database-schema)
- [API Endpoints](#-api-endpoints)
- [Setup & Deployment](#-setup--deployment)
- [Inter-Service Communication](#-inter-service-communication)
- [Testing](#-testing)
- [Screenshots](#-screenshots)

---

## ✨ Features

| Feature | Description |
|---|---|
| **Record Payments** | Create payment records with student ID, amount, fee, and payment method |
| **Payment Methods** | Supports Cash, Bank Transfer, Mobile Money, and Cheque |
| **Auto Receipt Generation** | Unique receipt numbers in format `RCP-YYYYMMDD-NNNNN` |
| **Balance Calculation** | Automatic balance and status (PAID / PARTIAL / PENDING) computation |
| **Payment History** | View all payments or filter by student ID |
| **Receipt View** | Printable receipt page for each payment |
| **REST API** | Full CRUD API with JSON responses |
| **Inter-Service Communication** | Validates student IDs via the Student Service |
| **Audit Logging** | All payment actions are logged in the audit table |
| **Input Validation** | Server-side validation with detailed error messages |
| **SQL Injection Prevention** | All queries use `PreparedStatement` |

---

## 🛠 Technology Stack

| Layer | Technology |
|---|---|
| **Language** | Java 25 |
| **Web Framework** | Jakarta Servlet 6.1 |
| **View Engine** | JSP + JSTL |
| **Database** | MySQL 8.x |
| **Data Access** | JDBC (PreparedStatement) |
| **JSON Handling** | Gson 2.11 |
| **Frontend** | Bootstrap 5.3 + Bootstrap Icons |
| **Build Tool** | Maven (with Maven Wrapper) |
| **Server** | Apache Tomcat 10.1+ |

---

## 📁 Project Structure

```
Payment-Service-Microservise/
├── database/
│   └── smartcampus_payment.sql          # Database schema + sample data
├── src/main/
│   ├── java/com/payment/
│   │   ├── model/
│   │   │   └── Payment.java             # Payment POJO (entity)
│   │   ├── dao/
│   │   │   ├── PaymentDAO.java          # DAO interface
│   │   │   └── PaymentDAOImpl.java      # JDBC implementation
│   │   ├── service/
│   │   │   ├── PaymentService.java      # Service interface
│   │   │   └── PaymentServiceImpl.java  # Business logic
│   │   ├── controller/
│   │   │   ├── PaymentApiServlet.java   # REST API controller
│   │   │   └── PaymentPageServlet.java  # JSP page controller
│   │   └── utils/
│   │       ├── DBConnection.java        # JDBC connection utility
│   │       ├── JsonUtil.java            # Gson JSON helper
│   │       └── HttpClientUtil.java      # HTTP client for inter-service calls
│   ├── resources/
│   │   └── db.properties                # Database credentials
│   └── webapp/
│       ├── index.jsp                    # Landing page
│       ├── css/style.css                # Custom styles
│       ├── WEB-INF/
│       │   ├── web.xml                  # Deployment descriptor
│       │   └── views/
│       │       ├── payment-form.jsp     # New payment form
│       │       ├── payment-history.jsp  # Payment history table
│       │       └── payment-receipt.jsp  # Receipt view
├── API_TESTING_GUIDE.md                 # Detailed API testing documentation
├── pom.xml                              # Maven configuration
└── README.md                            # This file
```

---

## 🏗 Architecture

The project follows the **MVC (Model-View-Controller)** pattern:

```
┌─────────────────────────────────────────────────────────┐
│                      CLIENT                             │
│              (Browser / curl / Postman)                  │
└──────────────┬──────────────────────┬───────────────────┘
               │                      │
        JSP Pages (HTML)        REST API (JSON)
               │                      │
┌──────────────▼──────────────────────▼───────────────────┐
│                   CONTROLLER LAYER                       │
│   PaymentPageServlet          PaymentApiServlet          │
│   (JSP navigation)           (REST endpoints)           │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│                    SERVICE LAYER                         │
│              PaymentServiceImpl                          │
│   • Validation    • Balance calculation                  │
│   • Receipt gen   • Status determination                 │
│   • Student validation (inter-service)                   │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│                      DAO LAYER                           │
│              PaymentDAOImpl (JDBC)                        │
│   • PreparedStatement for all queries                    │
│   • try-with-resources for connection management         │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│                    MySQL DATABASE                         │
│   payments  │  payment_audit_log                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🗄 Database Schema

### `payments` Table

| Column | Type | Description |
|---|---|---|
| `id` | INT (PK, AUTO_INCREMENT) | Unique payment ID |
| `student_id` | VARCHAR(20) | Student identifier |
| `amount_paid` | DECIMAL(12,2) | Amount paid in this transaction |
| `total_fee` | DECIMAL(12,2) | Total tuition fee |
| `balance` | DECIMAL(12,2) | Remaining balance |
| `payment_date` | DATE | Date of payment |
| `receipt_number` | VARCHAR(30) UNIQUE | Auto-generated receipt |
| `payment_method` | ENUM | CASH, BANK_TRANSFER, MOBILE_MONEY, CHEQUE |
| `status` | ENUM | PAID, PARTIAL, PENDING |
| `created_at` | TIMESTAMP | Record creation time |

### `payment_audit_log` Table

| Column | Type | Description |
|---|---|---|
| `id` | INT (PK) | Audit log ID |
| `payment_id` | INT (FK) | Reference to payments table |
| `action` | VARCHAR(20) | CREATE, UPDATE, DELETE |
| `details` | TEXT | Action description |
| `created_at` | TIMESTAMP | Log timestamp |

---

## 🔌 API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/payments` | List all payments |
| `GET` | `/api/payments/{id}` | Get payment by ID |
| `GET` | `/api/payments/student/{studentId}` | Get payments by student |
| `GET` | `/api/payments/balance/{studentId}` | Get balance summary |
| `GET` | `/api/payments/dummy-validate` | Health check |
| `POST` | `/api/payments` | Create new payment |
| `PUT` | `/api/payments/{id}` | Update a payment |
| `DELETE` | `/api/payments/{id}` | Delete a payment |

> 📖 For detailed curl examples and expected responses, see [API_TESTING_GUIDE.md](API_TESTING_GUIDE.md)

---

## 🚀 Setup & Deployment

### Prerequisites

- **Java JDK 25** (or compatible version)
- **MySQL 8.x**
- **Apache Tomcat 10.1+**
- **Maven** (or use the included Maven Wrapper `mvnw.cmd`)

### Step 1 — Create the Database

```bash
mysql -u root -p < database/smartcampus_payment.sql
```

This creates the `smartcampus_payment` database with tables, indexes, and sample data.

### Step 2 — Configure Database Credentials

Edit `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/smartcampus_payment
db.user=root
db.password=YOUR_PASSWORD
db.driver=com.mysql.cj.jdbc.Driver
```

### Step 3 — Build the Project

```bash
# Using Maven Wrapper (Windows)
.\mvnw.cmd clean package

# Using system Maven
mvn clean package
```

The WAR file will be generated at: `target/Payment-Service.war`

### Step 4 — Deploy to Tomcat

1. Copy `target/Payment-Service.war` to Tomcat's `webapps/` directory
2. Configure Tomcat to run on port `8088` in `conf/server.xml`:
   ```xml
   <Connector port="8088" protocol="HTTP/1.1" ... />
   ```
3. Start Tomcat

### Step 5 — Access the Application

| Resource | URL |
|---|---|
| **Landing Page** | `http://localhost:8088/Payment-Service/` |
| **New Payment** | `http://localhost:8088/Payment-Service/pages/form` |
| **Payment History** | `http://localhost:8088/Payment-Service/pages/history` |
| **API Health Check** | `http://localhost:8088/Payment-Service/api/payments/dummy-validate` |

---

## 🔗 Inter-Service Communication

The Payment Service communicates with the **Student Service** to validate student IDs before recording payments.

```
Payment Service  ──HTTP GET──▸  Student Service
(port 8088)                     (port 8080)
```

**Student Service URL:**
```
http://localhost:8080/Group_II_Student_Service_war_exploded/api/students/dummy/{studentId}
```

### Fail-Open Strategy

If the Student Service is **unavailable** (down, timeout, or network error), the Payment Service will still accept the payment. This ensures payments can always be recorded even during Student Service outages.

---

## 🧪 Testing

### Quick API Test

```bash
# Health check
curl http://localhost:8088/Payment-Service/api/payments/dummy-validate

# Create a payment
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"STU001\", \"amountPaid\": 150000, \"totalFee\": 500000, \"paymentMethod\": \"CASH\"}"

# Get all payments
curl http://localhost:8088/Payment-Service/api/payments

# Get balance summary
curl http://localhost:8088/Payment-Service/api/payments/balance/STU001
```

### Sample Student IDs

| Student ID | Status | Payments |
|---|---|---|
| `STU001` | PARTIAL | 2 installments |
| `STU002` | PAID | Full payment |
| `STU003` | PENDING | No payment made |
| `STU004` | PARTIAL | 1 installment |
| `STU005` | PAID | Full payment |

> 📖 For the complete testing guide with all endpoints, see [API_TESTING_GUIDE.md](API_TESTING_GUIDE.md)

---

## 🔒 Security

- **SQL Injection Prevention** — All database queries use `PreparedStatement`
- **Input Validation** — Server-side validation at the service layer
- **CORS Headers** — Configured for cross-origin API requests
- **Error Handling** — Consistent JSON error responses (no stack traces exposed)

---

## 👥 Group 8 — Contributors

| Role | Responsibility |
|---|---|
| Backend Development | Java Servlet, JDBC, REST API |
| Database Design | MySQL schema, indexes, constraints |
| Frontend | JSP views with Bootstrap 5 |
| Testing | API testing with curl |

---

## 📄 License

This project is developed as part of the **Backend Development using Java** course 

---

> **Smart Campus — Payment Service** © 2026 | Group 8
