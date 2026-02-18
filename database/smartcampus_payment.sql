-- ============================================================
-- Database: smartcampus_payment
-- Payment Service — Group 8
-- Distributed University Management System
-- ============================================================

CREATE DATABASE IF NOT EXISTS smartcampus_payment
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE smartcampus_payment;

-- -----------------------------------------------------------
-- Table: payments
-- -----------------------------------------------------------
DROP TABLE IF EXISTS payment_audit_log;
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    student_id      VARCHAR(20)     NOT NULL,
    amount_paid     DECIMAL(12,2)   NOT NULL CHECK (amount_paid >= 0),
    total_fee       DECIMAL(12,2)   NOT NULL CHECK (total_fee >= 0),
    balance         DECIMAL(12,2)   NOT NULL,
    payment_date    DATE            NOT NULL,
    receipt_number  VARCHAR(30)     NOT NULL,
    payment_method  ENUM('CASH','BANK_TRANSFER','MOBILE_MONEY','CHEQUE') NOT NULL DEFAULT 'CASH',
    status          ENUM('PAID','PARTIAL','PENDING') NOT NULL DEFAULT 'PENDING',
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_receipt_number UNIQUE (receipt_number)
) ENGINE=InnoDB;

-- Indexes for fast lookups
CREATE INDEX idx_payments_student   ON payments(student_id);
CREATE INDEX idx_payments_status    ON payments(status);
CREATE INDEX idx_payments_date      ON payments(payment_date);

-- -----------------------------------------------------------
-- Table: payment_audit_log
-- -----------------------------------------------------------
CREATE TABLE payment_audit_log (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    payment_id      INT             NOT NULL,
    action          VARCHAR(20)     NOT NULL,
    details         TEXT,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_payment
        FOREIGN KEY (payment_id) REFERENCES payments(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_audit_payment ON payment_audit_log(payment_id);

-- -----------------------------------------------------------
-- Sample Data (for testing with Student Service dummy data)
-- Matches: curl http://localhost:8080/Group_II_Student_Service_war_exploded/api/students/dummy
-- -----------------------------------------------------------
INSERT INTO payments (student_id, amount_paid, total_fee, balance, payment_date, receipt_number, payment_method, status) VALUES
('STU001', 150000.00, 500000.00, 350000.00, '2026-01-15', 'RCP-20260115-00001', 'BANK_TRANSFER', 'PARTIAL'),
('STU001', 200000.00, 500000.00, 150000.00, '2026-02-10', 'RCP-20260210-00001', 'MOBILE_MONEY', 'PARTIAL'),
('STU002', 500000.00, 500000.00, 0.00, '2026-01-20', 'RCP-20260120-00001', 'CASH', 'PAID'),
('STU003', 0.00, 500000.00, 500000.00, '2026-02-01', 'RCP-20260201-00001', 'CHEQUE', 'PENDING'),
('STU004', 250000.00, 500000.00, 250000.00, '2026-02-05', 'RCP-20260205-00001', 'MOBILE_MONEY', 'PARTIAL'),
('STU005', 500000.00, 500000.00, 0.00, '2026-02-12', 'RCP-20260212-00001', 'BANK_TRANSFER', 'PAID');

INSERT INTO payment_audit_log (payment_id, action, details) VALUES
(1, 'CREATE', 'Initial partial payment recorded via bank transfer'),
(2, 'CREATE', 'Second installment via mobile money'),
(3, 'CREATE', 'Full tuition paid in cash'),
(4, 'CREATE', 'Payment record created, awaiting payment'),
(5, 'CREATE', 'Partial payment via mobile money'),
(6, 'CREATE', 'Full payment via bank transfer');
