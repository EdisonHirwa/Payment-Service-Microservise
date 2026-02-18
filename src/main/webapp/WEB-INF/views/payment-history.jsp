<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Payment History — Smart Campus</title>
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
                                    <a class="nav-link" href="${pageContext.request.contextPath}/">
                                        <i class="bi bi-house me-1"></i>Home
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/form">
                                        <i class="bi bi-plus-circle me-1"></i>New Payment
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link active" href="${pageContext.request.contextPath}/pages/history">
                                        <i class="bi bi-clock-history me-1"></i>Payment History
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container my-4">
                    <h2 class="mb-4"><i class="bi bi-clock-history me-2"></i>Payment History</h2>

                    <!-- Search Form -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-body">
                            <form method="get" action="${pageContext.request.contextPath}/pages/history"
                                class="row g-3 align-items-end">
                                <div class="col-md-8">
                                    <label for="studentId" class="form-label fw-semibold">Student ID</label>
                                    <input type="text" class="form-control" id="studentId" name="studentId"
                                        placeholder="e.g., STU-2024-001" value="${studentId}" required>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="bi bi-search me-1"></i>Search
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Balance Summary -->
                    <c:if test="${not empty balance}">
                        <div class="balance-card mb-4
                ${balance.status == 'PAID' ? '' : ''}
                ${balance.status == 'PARTIAL' ? 'partial' : ''}
                ${balance.status == 'PENDING' ? 'pending' : ''}">
                            <div class="row text-center">
                                <div class="col-md-3">
                                    <h6 class="opacity-75">Student ID</h6>
                                    <h4 class="fw-bold">${balance.studentId}</h4>
                                </div>
                                <div class="col-md-3">
                                    <h6 class="opacity-75">Total Fee</h6>
                                    <h4 class="fw-bold">
                                        <fmt:formatNumber value="${balance.totalFee}" type="number"
                                            minFractionDigits="2" /> RWF
                                    </h4>
                                </div>
                                <div class="col-md-3">
                                    <h6 class="opacity-75">Total Paid</h6>
                                    <h4 class="fw-bold">
                                        <fmt:formatNumber value="${balance.totalPaid}" type="number"
                                            minFractionDigits="2" /> RWF
                                    </h4>
                                </div>
                                <div class="col-md-3">
                                    <h6 class="opacity-75">Balance</h6>
                                    <h4 class="fw-bold">
                                        <fmt:formatNumber value="${balance.currentBalance}" type="number"
                                            minFractionDigits="2" /> RWF
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Payment Table -->
                    <c:if test="${not empty payments}">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">
                                    <i class="bi bi-table me-2"></i>Payment Records
                                    <span class="badge bg-secondary ms-2">${payments.size()}</span>
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Receipt Number</th>
                                                <th>Amount Paid</th>
                                                <th>Total Fee</th>
                                                <th>Balance</th>
                                                <th>Date</th>
                                                <th>Method</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${payments}">
                                                <tr>
                                                    <td>${p.id}</td>
                                                    <td><code>${p.receiptNumber}</code></td>
                                                    <td>
                                                        <fmt:formatNumber value="${p.amountPaid}" type="number"
                                                            minFractionDigits="2" /> RWF
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${p.totalFee}" type="number"
                                                            minFractionDigits="2" /> RWF
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${p.balance}" type="number"
                                                            minFractionDigits="2" /> RWF
                                                    </td>
                                                    <td>${p.paymentDate}</td>
                                                    <td>${p.paymentMethod}</td>
                                                    <td>
                                                        <span class="badge
                                                ${p.status == 'PAID' ? 'status-paid' : ''}
                                                ${p.status == 'PARTIAL' ? 'status-partial' : ''}
                                                ${p.status == 'PENDING' ? 'status-pending' : ''}">
                                                            ${p.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/pages/receipt?id=${p.id}"
                                                            class="btn btn-sm btn-outline-primary">
                                                            <i class="bi bi-receipt me-1"></i>Receipt
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty studentId and empty payments}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>No payment records found for student:
                            <strong>${studentId}</strong>
                        </div>
                    </c:if>
                </div>

                <!-- Footer -->
                <footer class="bg-dark text-white text-center py-3 mt-5">
                    <div class="container">
                        <p class="mb-0">Smart Campus — Payment Service &copy; 2026 | Group 8</p>
                    </div>
                </footer>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>