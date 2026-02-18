package com.payment.dao;

import com.payment.model.Payment;
import com.payment.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of PaymentDAO.
 * Uses PreparedStatement for all queries (SQL injection prevention).
 */
public class PaymentDAOImpl implements PaymentDAO {

    // ── SQL Queries ──────────────────────────────────────────

    private static final String INSERT_PAYMENT = "INSERT INTO payments (student_id, amount_paid, total_fee, balance, payment_date, receipt_number, payment_method, status) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_BY_ID = "SELECT * FROM payments WHERE id = ?";

    private static final String SELECT_BY_STUDENT = "SELECT * FROM payments WHERE student_id = ? ORDER BY payment_date DESC";

    private static final String SELECT_ALL = "SELECT * FROM payments ORDER BY created_at DESC";

    private static final String UPDATE_PAYMENT = "UPDATE payments SET amount_paid = ?, total_fee = ?, balance = ?, " +
            "payment_date = ?, payment_method = ?, status = ? WHERE id = ?";

    private static final String DELETE_PAYMENT = "DELETE FROM payments WHERE id = ?";

    private static final String COUNT_TODAY = "SELECT COUNT(*) FROM payments WHERE DATE(created_at) = CURDATE()";

    private static final String INSERT_AUDIT = "INSERT INTO payment_audit_log (payment_id, action, details) VALUES (?, ?, ?)";

    // ── Implementation ───────────────────────────────────────

    @Override
    public int create(Payment payment) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INSERT_PAYMENT, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, payment.getStudentId());
            ps.setBigDecimal(2, payment.getAmountPaid());
            ps.setBigDecimal(3, payment.getTotalFee());
            ps.setBigDecimal(4, payment.getBalance());
            ps.setDate(5, Date.valueOf(payment.getPaymentDate()));
            ps.setString(6, payment.getReceiptNumber());
            ps.setString(7, payment.getPaymentMethod());
            ps.setString(8, payment.getStatus());

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            throw new SQLException("Failed to retrieve generated payment ID");
        }
    }

    @Override
    public Payment findById(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
            return null;
        }
    }

    @Override
    public List<Payment> findByStudentId(String studentId) throws SQLException {
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_STUDENT)) {

            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    @Override
    public List<Payment> findAll() throws SQLException {
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    @Override
    public boolean update(Payment payment) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_PAYMENT)) {

            ps.setBigDecimal(1, payment.getAmountPaid());
            ps.setBigDecimal(2, payment.getTotalFee());
            ps.setBigDecimal(3, payment.getBalance());
            ps.setDate(4, Date.valueOf(payment.getPaymentDate()));
            ps.setString(5, payment.getPaymentMethod());
            ps.setString(6, payment.getStatus());
            ps.setInt(7, payment.getId());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(DELETE_PAYMENT)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public int countPaymentsToday() throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(COUNT_TODAY);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    @Override
    public void createAuditLog(int paymentId, String action, String details) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INSERT_AUDIT)) {

            ps.setInt(1, paymentId);
            ps.setString(2, action);
            ps.setString(3, details);
            ps.executeUpdate();
        }
    }

    // ── Row Mapper ───────────────────────────────────────────

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setStudentId(rs.getString("student_id"));
        p.setAmountPaid(rs.getBigDecimal("amount_paid"));
        p.setTotalFee(rs.getBigDecimal("total_fee"));
        p.setBalance(rs.getBigDecimal("balance"));

        Date sqlDate = rs.getDate("payment_date");
        if (sqlDate != null) {
            p.setPaymentDate(sqlDate.toLocalDate());
        }

        p.setReceiptNumber(rs.getString("receipt_number"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setStatus(rs.getString("status"));

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            p.setCreatedAt(ts.toLocalDateTime());
        }

        return p;
    }
}
