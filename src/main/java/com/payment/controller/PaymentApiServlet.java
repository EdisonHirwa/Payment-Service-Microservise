package com.payment.controller;

import com.payment.model.Payment;
import com.payment.service.PaymentService;
import com.payment.service.PaymentServiceImpl;
import com.payment.utils.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * REST-style API Servlet for Payment operations.
 * Handles all /api/payments/* requests and returns JSON.
 *
 * URL patterns:
 * POST /api/payments → Create payment
 * GET /api/payments/{id} → Get by ID
 * GET /api/payments/student/{sid} → Payment history
 * GET /api/payments/balance/{sid} → Balance summary
 * GET /api/payments/dummy-validate → Health check
 * PUT /api/payments/{id} → Update payment
 * DELETE /api/payments/{id} → Delete payment
 */
@WebServlet(urlPatterns = "/api/payments/*")
public class PaymentApiServlet extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentServiceImpl();
    }

    // ── CORS ─────────────────────────────────────────────────

    private void setCorsHeaders(HttpServletResponse resp) {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setCorsHeaders(resp);
        resp.setStatus(200);
    }

    // ══════════════════════════════════════════════════════════
    // GET
    // ══════════════════════════════════════════════════════════

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setCorsHeaders(resp);

        String pathInfo = req.getPathInfo(); // e.g., "/5", "/student/STU-001", "/dummy-validate"

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/payments — list all
                handleGetAll(resp);

            } else if (pathInfo.equals("/dummy-validate")) {
                // GET /api/payments/dummy-validate
                handleDummyValidate(resp);

            } else if (pathInfo.startsWith("/student/")) {
                // GET /api/payments/student/{studentId}
                String studentId = pathInfo.substring("/student/".length());
                handleGetByStudent(resp, studentId);

            } else if (pathInfo.startsWith("/balance/")) {
                // GET /api/payments/balance/{studentId}
                String studentId = pathInfo.substring("/balance/".length());
                handleGetBalance(resp, studentId);

            } else {
                // GET /api/payments/{id}
                handleGetById(resp, pathInfo.substring(1));
            }

        } catch (Exception e) {
            sendError(resp, 500, "Internal server error: " + e.getMessage());
        }
    }

    private void handleGetAll(HttpServletResponse resp) throws IOException {
        List<Payment> payments = paymentService.getAllPayments();
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("count", payments.size());
        result.put("data", payments);
        JsonUtil.toResponse(resp, 200, result);
    }

    private void handleDummyValidate(HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("message", "Payment Service is running");
        result.put("service", "Payment Service");
        result.put("version", "1.0");
        result.put("timestamp", LocalDateTime.now().toString());
        JsonUtil.toResponse(resp, 200, result);
    }

    private void handleGetByStudent(HttpServletResponse resp, String studentId) throws IOException {
        List<Payment> payments = paymentService.getByStudentId(studentId);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("count", payments.size());
        result.put("data", payments);
        JsonUtil.toResponse(resp, 200, result);
    }

    private void handleGetBalance(HttpServletResponse resp, String studentId) throws IOException {
        Map<String, Object> balance = paymentService.getBalance(studentId);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("data", balance);
        JsonUtil.toResponse(resp, 200, result);
    }

    private void handleGetById(HttpServletResponse resp, String idStr) throws IOException {
        try {
            int id = Integer.parseInt(idStr);
            Payment payment = paymentService.getById(id);
            if (payment != null) {
                Map<String, Object> result = new LinkedHashMap<>();
                result.put("success", true);
                result.put("data", payment);
                JsonUtil.toResponse(resp, 200, result);
            } else {
                sendError(resp, 404, "Payment not found with id: " + id);
            }
        } catch (NumberFormatException e) {
            sendError(resp, 400, "Invalid payment id: " + idStr);
        }
    }

    // ══════════════════════════════════════════════════════════
    // POST
    // ══════════════════════════════════════════════════════════

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setCorsHeaders(resp);

        try {
            Payment payment = JsonUtil.fromRequest(req, Payment.class);
            if (payment == null) {
                sendError(resp, 400, "Invalid JSON body");
                return;
            }

            Map<String, Object> result = paymentService.createPayment(payment);
            boolean success = (boolean) result.get("success");
            JsonUtil.toResponse(resp, success ? 201 : 400, result);

        } catch (Exception e) {
            sendError(resp, 400, "Invalid request: " + e.getMessage());
        }
    }

    // ══════════════════════════════════════════════════════════
    // PUT
    // ══════════════════════════════════════════════════════════

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setCorsHeaders(resp);

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            sendError(resp, 400, "Payment ID is required in URL");
            return;
        }

        try {
            int id = Integer.parseInt(pathInfo.substring(1));
            Payment updated = JsonUtil.fromRequest(req, Payment.class);
            if (updated == null) {
                sendError(resp, 400, "Invalid JSON body");
                return;
            }

            Map<String, Object> result = paymentService.updatePayment(id, updated);
            boolean success = (boolean) result.get("success");
            int status = success ? 200 : (result.get("message").toString().contains("not found") ? 404 : 400);
            JsonUtil.toResponse(resp, status, result);

        } catch (NumberFormatException e) {
            sendError(resp, 400, "Invalid payment id");
        } catch (Exception e) {
            sendError(resp, 500, "Internal server error: " + e.getMessage());
        }
    }

    // ══════════════════════════════════════════════════════════
    // DELETE
    // ══════════════════════════════════════════════════════════

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setCorsHeaders(resp);

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            sendError(resp, 400, "Payment ID is required in URL");
            return;
        }

        try {
            int id = Integer.parseInt(pathInfo.substring(1));
            Map<String, Object> result = paymentService.deletePayment(id);
            boolean success = (boolean) result.get("success");
            int status = success ? 200 : 404;
            JsonUtil.toResponse(resp, status, result);

        } catch (NumberFormatException e) {
            sendError(resp, 400, "Invalid payment id");
        } catch (Exception e) {
            sendError(resp, 500, "Internal server error: " + e.getMessage());
        }
    }

    // ── Error Helper ─────────────────────────────────────────

    private void sendError(HttpServletResponse resp, int statusCode, String message) throws IOException {
        Map<String, Object> error = new LinkedHashMap<>();
        error.put("success", false);
        error.put("message", message);
        JsonUtil.toResponse(resp, statusCode, error);
    }
}
