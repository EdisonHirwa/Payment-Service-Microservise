# Payment Service — API Testing Guide

> **Base URL:** `http://localhost:8088/Payment-Service`  
> **Student Service (Dummy Data):** `http://localhost:8080/Group_II_Student_Service_war_exploded/api/students/dummy`

---

## Prerequisites

1. **MySQL** is running with the `smartcampus_payment` database created:
   ```bash
   mysql -u root -p < database/smartcampus_payment.sql
   ```

2. **Tomcat** is running on port `8088` with the `Payment-Service.war` deployed.

3. **Student Service** is running on port `8080` (for student validation):
   ```bash
   curl http://localhost:8080/Group_II_Student_Service_war_exploded/api/students/dummy
   ```

---

## 1. Health Check

Verify the Payment Service is running:

```bash
curl http://localhost:8088/Payment-Service/api/payments/dummy-validate
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Payment Service is running",
  "service": "Payment Service",
  "version": "1.0",
  "timestamp": "2026-02-18T14:30:00"
}
```

---

## 2. Create a New Payment (POST)

Record a payment using a student ID from the Student Service dummy data:

```bash
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"STU001\", \"amountPaid\": 150000, \"totalFee\": 500000, \"paymentMethod\": \"CASH\"}"
```

### With Different Payment Methods:

**Bank Transfer:**
```bash
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"STU002\", \"amountPaid\": 500000, \"totalFee\": 500000, \"paymentMethod\": \"BANK_TRANSFER\"}"
```

**Mobile Money:**
```bash
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"STU003\", \"amountPaid\": 250000, \"totalFee\": 500000, \"paymentMethod\": \"MOBILE_MONEY\"}"
```

**Cheque:**
```bash
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"STU004\", \"amountPaid\": 0, \"totalFee\": 500000, \"paymentMethod\": \"CHEQUE\"}"
```

**Expected Response (201 Created):**
```json
{
  "success": true,
  "message": "Payment recorded successfully",
  "data": {
    "id": 7,
    "studentId": "STU001",
    "amountPaid": 150000.00,
    "totalFee": 500000.00,
    "balance": 350000.00,
    "paymentDate": "2026-02-18",
    "receiptNumber": "RCP-20260218-00001",
    "paymentMethod": "CASH",
    "status": "PARTIAL"
  }
}
```

---

## 3. Get All Payments (GET)

```bash
curl http://localhost:8088/Payment-Service/api/payments
```

**Expected Response:**
```json
{
  "success": true,
  "count": 6,
  "data": [ ... array of all payment records ... ]
}
```

---

## 4. Get Payment by ID (GET)

```bash
curl http://localhost:8088/Payment-Service/api/payments/1
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "studentId": "STU001",
    "amountPaid": 150000.00,
    "totalFee": 500000.00,
    "balance": 350000.00,
    "paymentDate": "2026-01-15",
    "receiptNumber": "RCP-20260115-00001",
    "paymentMethod": "BANK_TRANSFER",
    "status": "PARTIAL"
  }
}
```

---

## 5. Get Payments by Student ID (GET)

Use a student ID from the Student Service dummy data:

```bash
curl http://localhost:8088/Payment-Service/api/payments/student/STU001
```

**Expected Response (STU001 has 2 payments):**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "id": 2,
      "studentId": "STU001",
      "amountPaid": 200000.00,
      "paymentMethod": "MOBILE_MONEY",
      "status": "PARTIAL"
    },
    {
      "id": 1,
      "studentId": "STU001",
      "amountPaid": 150000.00,
      "paymentMethod": "BANK_TRANSFER",
      "status": "PARTIAL"
    }
  ]
}
```

---

## 6. Get Balance Summary by Student ID (GET)

```bash
curl http://localhost:8088/Payment-Service/api/payments/balance/STU001
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "studentId": "STU001",
    "totalFee": 500000.00,
    "totalPaid": 350000.00,
    "currentBalance": 150000.00,
    "status": "PARTIAL",
    "paymentCount": 2
  }
}
```

---

## 7. Update a Payment (PUT)

```bash
curl -X PUT http://localhost:8088/Payment-Service/api/payments/1 ^
  -H "Content-Type: application/json" ^
  -d "{\"amountPaid\": 500000, \"totalFee\": 500000, \"paymentMethod\": \"BANK_TRANSFER\"}"
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Payment updated successfully",
  "data": {
    "id": 1,
    "amountPaid": 500000.00,
    "balance": 0.00,
    "paymentMethod": "BANK_TRANSFER",
    "status": "PAID"
  }
}
```

---

## 8. Delete a Payment (DELETE)

```bash
curl -X DELETE http://localhost:8088/Payment-Service/api/payments/1
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Payment deleted successfully"
}
```

---

## Inter-Service Communication Test

The Payment Service validates student IDs by calling the Student Service. To test:

### Step 1 — Verify Student Service is running:
```bash
curl http://localhost:8080/Group_II_Student_Service_war_exploded/api/students/dummy
```

### Step 2 — Create a payment with a student ID from the Student Service:
```bash
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"STU001\", \"amountPaid\": 100000, \"totalFee\": 500000, \"paymentMethod\": \"MOBILE_MONEY\"}"
```

### Fail-Open Behavior:
If the Student Service is **not running**, the Payment Service will still accept the payment (fail-open strategy). This ensures payments can be recorded even when the Student Service is temporarily unavailable.

---

## Sample Student IDs (from Dummy Data)

| Student ID | Description |
|---|---|
| `STU001` | Student with 2 partial payments |
| `STU002` | Student fully paid |
| `STU003` | Student with pending payment |
| `STU004` | Student with partial payment |
| `STU005` | Student fully paid |

## Payment Methods

| Value | Display Name |
|---|---|
| `CASH` | Cash |
| `BANK_TRANSFER` | Bank Transfer |
| `MOBILE_MONEY` | Mobile Money |
| `CHEQUE` | Cheque |

---

## Error Responses

### Validation Error (400):
```bash
curl -X POST http://localhost:8088/Payment-Service/api/payments ^
  -H "Content-Type: application/json" ^
  -d "{\"studentId\": \"\", \"amountPaid\": -100, \"totalFee\": 0}"
```

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    "studentId is required",
    "amountPaid must be >= 0",
    "totalFee must be > 0"
  ]
}
```

### Not Found (404):
```bash
curl http://localhost:8088/Payment-Service/api/payments/9999
```

```json
{
  "success": false,
  "message": "Payment not found with id: 9999"
}
```
