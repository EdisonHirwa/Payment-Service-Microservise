<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>New Payment — Smart Campus</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
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
                                <a class="nav-link active" href="${pageContext.request.contextPath}/pages/form">
                                    <i class="bi bi-plus-circle me-1"></i>New Payment
                                </a>
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
                <div class="row justify-content-center">
                    <div class="col-md-7">
                        <div class="card form-card">
                            <div class="card-header bg-primary text-white">
                                <h4 class="mb-0">
                                    <i class="bi bi-credit-card-2-front me-2"></i>Record New Payment
                                </h4>
                            </div>
                            <div class="card-body p-4">

                                <!-- Error Messages -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show">
                                        <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty errors}">
                                    <div class="alert alert-danger">
                                        <ul class="mb-0">
                                            <c:forEach var="err" items="${errors}">
                                                <li>${err}</li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>

                                <!-- Payment Form -->
                                <form method="post" action="${pageContext.request.contextPath}/pages/form"
                                    id="paymentForm">
                                    <!-- Student ID -->
                                    <div class="mb-3">
                                        <label for="studentId" class="form-label fw-semibold">
                                            <i class="bi bi-person me-1"></i>Student ID
                                        </label>
                                        <input type="text" class="form-control" id="studentId" name="studentId"
                                            placeholder="e.g., STU-2024-001"
                                            value="${payment != null ? payment.studentId : ''}" required maxlength="20">
                                        <div class="form-text">Enter the student's unique ID</div>
                                    </div>

                                    <!-- Total Fee -->
                                    <div class="mb-3">
                                        <label for="totalFee" class="form-label fw-semibold">
                                            <i class="bi bi-currency-exchange me-1"></i>Total Fee (RWF)
                                        </label>
                                        <input type="number" class="form-control" id="totalFee" name="totalFee"
                                            placeholder="e.g., 500000"
                                            value="${payment != null ? payment.totalFee : ''}" required min="1"
                                            step="0.01">
                                        <div class="form-text">Total tuition fee amount</div>
                                    </div>

                                    <!-- Amount Paid -->
                                    <div class="mb-3">
                                        <label for="amountPaid" class="form-label fw-semibold">
                                            <i class="bi bi-cash me-1"></i>Amount Paid (RWF)
                                        </label>
                                        <input type="number" class="form-control" id="amountPaid" name="amountPaid"
                                            placeholder="e.g., 150000"
                                            value="${payment != null ? payment.amountPaid : ''}" required min="0"
                                            step="0.01">
                                        <div class="form-text">Amount being paid now</div>
                                    </div>

                                    <!-- Payment Method -->
                                    <div class="mb-3">
                                        <label for="paymentMethod" class="form-label fw-semibold">
                                            <i class="bi bi-wallet2 me-1"></i>Payment Method
                                        </label>
                                        <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                            <option value="CASH" ${payment !=null && payment.paymentMethod=='CASH'
                                                ? 'selected' : '' }>Cash</option>
                                            <option value="BANK_TRANSFER" ${payment !=null &&
                                                payment.paymentMethod=='BANK_TRANSFER' ? 'selected' : '' }>Bank Transfer
                                            </option>
                                            <option value="MOBILE_MONEY" ${payment !=null &&
                                                payment.paymentMethod=='MOBILE_MONEY' ? 'selected' : '' }>Mobile Money
                                            </option>
                                            <option value="CHEQUE" ${payment !=null && payment.paymentMethod=='CHEQUE'
                                                ? 'selected' : '' }>Cheque</option>
                                        </select>
                                        <div class="form-text">Select how the payment is being made</div>
                                    </div>

                                    <!-- Live Balance Preview -->
                                    <div class="alert alert-info" id="balancePreview" style="display:none;">
                                        <div class="row text-center">
                                            <div class="col-4">
                                                <small class="text-muted">Balance</small>
                                                <h5 class="mb-0" id="previewBalance">—</h5>
                                            </div>
                                            <div class="col-4">
                                                <small class="text-muted">Status</small>
                                                <h5 class="mb-0" id="previewStatus">—</h5>
                                            </div>
                                            <div class="col-4">
                                                <small class="text-muted">Receipt</small>
                                                <h5 class="mb-0"><i class="bi bi-check-circle text-success"></i> Auto
                                                </h5>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Submit -->
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-lg">
                                            <i class="bi bi-check-circle me-2"></i>Submit Payment
                                        </button>
                                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left me-1"></i>Cancel
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <footer class="bg-dark text-white text-center py-3 mt-5">
                <div class="container">
                    <p class="mb-0">Smart Campus — Payment Service &copy; 2026 | Group 8</p>
                </div>
            </footer>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Live balance preview
                const totalFee = document.getElementById('totalFee');
                const amountPaid = document.getElementById('amountPaid');
                const preview = document.getElementById('balancePreview');
                const balanceEl = document.getElementById('previewBalance');
                const statusEl = document.getElementById('previewStatus');

                function updatePreview() {
                    const fee = parseFloat(totalFee.value) || 0;
                    const paid = parseFloat(amountPaid.value) || 0;

                    if (fee > 0) {
                        preview.style.display = 'block';
                        const balance = fee - paid;
                        balanceEl.textContent = balance.toLocaleString() + ' RWF';

                        if (paid <= 0) {
                            statusEl.textContent = 'PENDING';
                            statusEl.className = 'mb-0 text-danger';
                        } else if (paid >= fee) {
                            statusEl.textContent = 'PAID';
                            statusEl.className = 'mb-0 text-success';
                        } else {
                            statusEl.textContent = 'PARTIAL';
                            statusEl.className = 'mb-0 text-warning';
                        }
                    } else {
                        preview.style.display = 'none';
                    }
                }

                totalFee.addEventListener('input', updatePreview);
                amountPaid.addEventListener('input', updatePreview);
                updatePreview();
            </script>
        </body>

        </html>