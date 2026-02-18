package com.payment.dao;

import com.payment.model.Payment;

import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for Payment entity.
 * Defines all database operations.
 */
public interface PaymentDAO {

    /**
     * Insert a new payment record.
     * 
     * @return the generated payment ID
     */
    int create(Payment payment) throws SQLException;

    /**
     * Find a payment by its ID.
     * 
     * @return Payment or null if not found
     */
    Payment findById(int id) throws SQLException;

    /**
     * Find all payments for a specific student.
     */
    List<Payment> findByStudentId(String studentId) throws SQLException;

    /**
     * Get all payments.
     */
    List<Payment> findAll() throws SQLException;

    /**
     * Update an existing payment.
     * 
     * @return true if a row was updated
     */
    boolean update(Payment payment) throws SQLException;

    /**
     * Delete a payment by ID.
     * 
     * @return true if a row was deleted
     */
    boolean delete(int id) throws SQLException;

    /**
     * Count the number of payments created today.
     * Used for receipt number generation.
     */
    int countPaymentsToday() throws SQLException;

    /**
     * Insert an audit log entry.
     */
    void createAuditLog(int paymentId, String action, String details) throws SQLException;
}
