<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Service — Smart Campus</title>
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
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/">
                                <i class="bi bi-house me-1"></i>Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/pages/form">
                                <i class="bi bi-plus-circle me-1"></i>New Payment
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/pages/history">
                                <i class="bi bi-clock-history me-1"></i>Payment History
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <div class="hero-section text-center text-white py-5">
            <div class="container">
                <h1 class="display-4 fw-bold mb-3">
                    <i class="bi bi-shield-check me-2"></i>Smart Campus Payment Service
                </h1>
                <p class="lead mb-4">
                    Distributed University Management System — Group 8
                </p>
                <p class="text-light opacity-75">
                    Microservice Architecture &bull; Java Servlet &bull; JDBC &bull; MySQL &bull; REST API
                </p>
            </div>
        </div>

        <!-- Feature Cards -->
        <div class="container my-5">
            <div class="row g-4">
                <!-- Record Payment -->
                <div class="col-md-4">
                    <div class="card feature-card h-100 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon bg-primary text-white rounded-circle mx-auto mb-3">
                                <i class="bi bi-credit-card-2-front fs-3"></i>
                            </div>
                            <h5 class="card-title">Record Payment</h5>
                            <p class="card-text text-muted">
                                Submit tuition payments with auto-generated receipt numbers and real-time balance
                                calculation.
                            </p>
                            <a href="${pageContext.request.contextPath}/pages/form" class="btn btn-primary">
                                <i class="bi bi-plus-circle me-1"></i>New Payment
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Payment History -->
                <div class="col-md-4">
                    <div class="card feature-card h-100 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon bg-success text-white rounded-circle mx-auto mb-3">
                                <i class="bi bi-list-check fs-3"></i>
                            </div>
                            <h5 class="card-title">Payment History</h5>
                            <p class="card-text text-muted">
                                View complete payment history per student with balance summary and status tracking.
                            </p>
                            <a href="${pageContext.request.contextPath}/pages/history" class="btn btn-success">
                                <i class="bi bi-clock-history me-1"></i>View History
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Footer -->
        <footer class="bg-dark text-white text-center py-3 mt-auto">
            <div class="container">
                <p class="mb-0">
                    <i class="bi bi-mortarboard me-1"></i>
                    Smart Campus — Payment Service &copy; 2026 | Group 8
                </p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>