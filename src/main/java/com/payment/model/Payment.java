package com.payment.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Payment model — maps to the 'payments' table.
 * Pure POJO with no business logic.
 */
public class Payment {

    private int id;
    private String studentId;
    private BigDecimal amountPaid;
    private BigDecimal totalFee;
    private BigDecimal balance;
    private LocalDate paymentDate;
    private String receiptNumber;
    private String paymentMethod; // CASH, BANK_TRANSFER, MOBILE_MONEY, CHEQUE
    private String status; // PAID, PARTIAL, PENDING
    private LocalDateTime createdAt;

    // ── Constructors ──────────────────────────────────────────

    public Payment() {
    }

    public Payment(String studentId, BigDecimal amountPaid, BigDecimal totalFee) {
        this.studentId = studentId;
        this.amountPaid = amountPaid;
        this.totalFee = totalFee;
    }

    // ── Getters & Setters ─────────────────────────────────────

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public BigDecimal getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(BigDecimal amountPaid) {
        this.amountPaid = amountPaid;
    }

    public BigDecimal getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(BigDecimal totalFee) {
        this.totalFee = totalFee;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public LocalDate getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDate paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getReceiptNumber() {
        return receiptNumber;
    }

    public void setReceiptNumber(String receiptNumber) {
        this.receiptNumber = receiptNumber;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "id=" + id +
                ", studentId='" + studentId + '\'' +
                ", amountPaid=" + amountPaid +
                ", totalFee=" + totalFee +
                ", balance=" + balance +
                ", receiptNumber='" + receiptNumber + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
