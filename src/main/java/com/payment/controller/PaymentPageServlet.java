package com.payment.controller;

import com.payment.model.Payment;
import com.payment.service.PaymentService;
import com.payment.service.PaymentServiceImpl;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Page controller Servlet for JSP views.
 * Handles browser-based navigation and forwards to JSP pages.
 *
 * URL patterns:
 * GET /pages/history?studentId=... → Payment history page
 * GET /pages/receipt?id=... → Receipt view page
 * GET /pages/form → New payment form
 * POST /pages/form → Submit new payment (form post)
 */
@WebServlet(urlPatterns = "/pages/*")
public class PaymentPageServlet extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        switch (pathInfo) {
            case "/history":
                showHistory(req, resp);
                break;
            case "/receipt":
                showReceipt(req, resp);
                break;
            case "/form":
                req.getRequestDispatcher("/WEB-INF/views/payment-form.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();

        if ("/form".equals(pathInfo)) {
            handleFormSubmit(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    // ── History Page ─────────────────────────────────────────

    private void showHistory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String studentId = req.getParameter("studentId");
        if (studentId != null && !studentId.isBlank()) {
            List<Payment> payments = paymentService.getByStudentId(studentId);
            Map<String, Object> balance = paymentService.getBalance(studentId);
            req.setAttribute("payments", payments);
            req.setAttribute("balance", balance);
            req.setAttribute("studentId", studentId);
        } else {
            // Show all payments by default
            List<Payment> allPayments = paymentService.getAllPayments();
            req.setAttribute("payments", allPayments);
        }

        req.getRequestDispatcher("/WEB-INF/views/payment-history.jsp").forward(req, resp);
    }

    // ── Receipt Page ─────────────────────────────────────────

    private void showReceipt(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Payment payment = paymentService.getById(id);
                req.setAttribute("payment", payment);
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid payment ID");
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/payment-receipt.jsp").forward(req, resp);
    }

    // ── Form Submit ──────────────────────────────────────────

    private void handleFormSubmit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String studentId = req.getParameter("studentId");
            String amountStr = req.getParameter("amountPaid");
            String feeStr = req.getParameter("totalFee");
            String paymentMethod = req.getParameter("paymentMethod");

            Payment payment = new Payment();
            payment.setStudentId(studentId);
            payment.setAmountPaid(new java.math.BigDecimal(amountStr));
            payment.setTotalFee(new java.math.BigDecimal(feeStr));
            payment.setPaymentMethod(paymentMethod != null ? paymentMethod : "CASH");

            Map<String, Object> result = paymentService.createPayment(payment);

            if ((boolean) result.get("success")) {
                Payment saved = (Payment) result.get("data");
                resp.sendRedirect(req.getContextPath() + "/pages/receipt?id=" + saved.getId());
            } else {
                req.setAttribute("error", result.get("message"));
                req.setAttribute("errors", result.get("errors"));
                req.setAttribute("payment", payment);
                req.getRequestDispatcher("/WEB-INF/views/payment-form.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Invalid input: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/payment-form.jsp").forward(req, resp);
        }
    }
}
