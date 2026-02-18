<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Payment Receipt — Smart Campus</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
            </head>

            <body>
                <!-- Navbar -->
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
                            <i class="bi bi-cash-stack me-2"></i>Payment Service
                        </a>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav ms-auto">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/form">New
                                        Payment</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/history">Payment
                                        History</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container my-5">
                    <c:choose>
                        <c:when test="${not empty payment}">
                            <!-- Receipt Card -->
                            <div class="row justify-content-center">
                                <div class="col-md-8">
                                    <div class="receipt-card">
                                        <!-- Header -->
                                        <div class="receipt-header text-center">
                                            <h3 class="text-primary fw-bold">
                                                <i class="bi bi-mortarboard me-2"></i>Smart Campus University
                                            </h3>
                                            <p class="text-muted mb-0">Payment Receipt</p>
                                        </div>

                                        <!-- Receipt Details -->
                                        <div class="row mb-3">
                                            <div class="col-6">
                                                <p class="text-muted mb-1">Receipt Number</p>
                                                <h5 class="fw-bold text-primary">${payment.receiptNumber}</h5>
                                            </div>
                                            <div class="col-6 text-end">
                                                <p class="text-muted mb-1">Date</p>
                                                <h5 class="fw-bold">${payment.paymentDate}</h5>
                                            </div>
                                        </div>

                                        <hr>

                                        <div class="row mb-3">
                                            <div class="col-6">
                                                <p class="text-muted mb-1">Student ID</p>
                                                <p class="fw-semibold">${payment.studentId}</p>
                                            </div>
                                            <div class="col-6 text-end">
                                                <p class="text-muted mb-1">Status</p>
                                                <span class="badge fs-6
                                        ${payment.status == 'PAID' ? 'status-paid' : ''}
                                        ${payment.status == 'PARTIAL' ? 'status-partial' : ''}
                                        ${payment.status == 'PENDING' ? 'status-pending' : ''}">
                                                    ${payment.status}
                                                </span>
                                            </div>
                                        </div>

                                        <hr>

                                        <!-- Financial Details -->
                                        <table class="table table-borderless">
                                            <tbody>
                                                <tr>
                                                    <td class="text-muted">Total Fee</td>
                                                    <td class="text-end fw-semibold">
                                                        <fmt:formatNumber value="${payment.totalFee}" type="number"
                                                            minFractionDigits="2" /> RWF
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="text-muted">Payment Method</td>
                                                    <td class="text-end fw-semibold">${payment.paymentMethod}</td>
                                                </tr>
                                                <tr>
                                                    <td class="text-muted">Amount Paid</td>
                                                    <td class="text-end fw-semibold text-success">
                                                        <fmt:formatNumber value="${payment.amountPaid}" type="number"
                                                            minFractionDigits="2" /> RWF
                                                    </td>
                                                </tr>
                                                <tr class="border-top">
                                                    <td class="fw-bold fs-5">Remaining Balance</td>
                                                    <td class="text-end fw-bold fs-5 text-danger">
                                                        <fmt:formatNumber value="${payment.balance}" type="number"
                                                            minFractionDigits="2" /> RWF
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <hr>

                                        <!-- Footer -->
                                        <div class="text-center text-muted mt-3">
                                            <small>
                                                <i class="bi bi-info-circle me-1"></i>
                                                This is a computer-generated receipt. Payment Service — Group 8
                                            </small>
                                        </div>

                                        <!-- Actions -->
                                        <div class="text-center mt-4">
                                            <button onclick="window.print()" class="btn btn-outline-primary me-2">
                                                <i class="bi bi-printer me-1"></i>Print Receipt
                                            </button>
                                            <a href="${pageContext.request.contextPath}/pages/history?studentId=${payment.studentId}"
                                                class="btn btn-primary">
                                                <i class="bi bi-arrow-left me-1"></i>Back to History
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning text-center">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty error}">${error}</c:when>
                                    <c:otherwise>No payment found. Please provide a valid payment ID.</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/pages/history" class="btn btn-primary">
                                    <i class="bi bi-arrow-left me-1"></i>Go to Payment History
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <footer class="bg-dark text-white text-center py-3 mt-5">
                    <div class="container">
                        <p class="mb-0">Smart Campus — Payment Service &copy; 2026 | Group 8</p>
                    </div>
                </footer>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>