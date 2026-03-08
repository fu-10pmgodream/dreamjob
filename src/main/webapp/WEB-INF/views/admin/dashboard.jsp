<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DreamJob</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-100 flex">

<!-- Sidebar -->
<aside class="w-64 min-h-screen bg-gray-900 text-white flex flex-col fixed top-0 left-0 z-40">
    <div class="p-6 border-b border-gray-700">
        <a href="${pageContext.request.contextPath}/" class="text-2xl font-extrabold text-blue-400">DreamJob</a>
        <p class="text-xs text-gray-400 mt-1">Bảng quản trị hệ thống</p>
    </div>
    <nav class="flex-grow p-4 space-y-2">
        <a href="${pageContext.request.contextPath}/admin" class="flex items-center px-4 py-3 rounded-xl text-white bg-blue-600 font-semibold">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
            Tổng quan
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center px-4 py-3 rounded-xl text-gray-300 hover:bg-gray-800 hover:text-white transition font-medium">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
            Quản lý người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/jobs" class="flex items-center px-4 py-3 rounded-xl text-gray-300 hover:bg-gray-800 hover:text-white transition font-medium">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
            Quản lý việc làm
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-3 rounded-xl text-red-400 hover:bg-red-900 hover:text-white transition font-medium mt-8">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
            Đăng xuất
        </a>
    </nav>
</aside>

<!-- Main Content -->
<div class="ml-64 flex-grow p-8">
    <h1 class="text-3xl font-extrabold text-gray-900 mb-8">Tổng quan hệ thống</h1>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 mb-10">
        <div class="bg-blue-600 text-white p-6 rounded-2xl shadow-lg">
            <p class="text-blue-100 text-sm font-medium">Tổng người dùng</p>
            <p class="text-4xl font-extrabold mt-2">${totalUsers}</p>
        </div>
        <div class="bg-green-600 text-white p-6 rounded-2xl shadow-lg">
            <p class="text-green-100 text-sm font-medium">Việc làm đang tuyển</p>
            <p class="text-4xl font-extrabold mt-2">${totalJobs}</p>
        </div>
        <div class="bg-purple-600 text-white p-6 rounded-2xl shadow-lg">
            <p class="text-purple-100 text-sm font-medium">Tổng đơn ứng tuyển</p>
            <p class="text-4xl font-extrabold mt-2">${totalApplications}</p>
        </div>
        <div class="bg-orange-500 text-white p-6 rounded-2xl shadow-lg">
            <p class="text-orange-100 text-sm font-medium">Công ty đang tuyển</p>
            <p class="text-4xl font-extrabold mt-2">${totalCompanies}</p>
        </div>
    </div>

    <!-- Salary Stats -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm text-center">
            <p class="text-gray-500 text-sm mb-2">Lương trung bình</p>
            <p class="text-2xl font-extrabold text-blue-600"><fmt:formatNumber value="${avgSalary/1000000}" pattern="#,##0.#"/> triệu</p>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm text-center">
            <p class="text-gray-500 text-sm mb-2">Lương cao nhất</p>
            <p class="text-2xl font-extrabold text-green-600"><fmt:formatNumber value="${maxSalary/1000000}" pattern="#,##0.#"/> triệu</p>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm text-center">
            <p class="text-gray-500 text-sm mb-2">Lương thấp nhất</p>
            <p class="text-2xl font-extrabold text-orange-500"><fmt:formatNumber value="${minSalary/1000000}" pattern="#,##0.#"/> triệu</p>
        </div>
    </div>

    <!-- Charts -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Việc làm theo danh mục</h3>
            <canvas id="categoryChart" height="250"></canvas>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Đơn ứng tuyển theo trạng thái</h3>
            <canvas id="statusChart" height="250"></canvas>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Người dùng theo vai trò</h3>
            <canvas id="roleChart" height="250"></canvas>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Loại hình công việc</h3>
            <canvas id="typeChart" height="250"></canvas>
        </div>
    </div>
</div>

<script>
    const blue = ['#3B82F6','#6366F1','#8B5CF6','#EC4899','#F59E0B','#10B981','#EF4444','#14B8A6'];

    function makeChart(id, type, labels, data, colors) {
        new Chart(document.getElementById(id), {
            type: type,
            data: { labels: labels, datasets: [{ data: data, backgroundColor: colors || blue, borderWidth: 0 }] },
            options: { plugins: { legend: { position: 'bottom' } }, responsive: true }
        });
    }

    // Category Chart
    makeChart('categoryChart', 'bar',
        [<c:forEach items="${jobsByCategory}" var="e">'${e.key}',</c:forEach>],
        [<c:forEach items="${jobsByCategory}" var="e">${e.value},</c:forEach>],
        null);

    // Application Status Chart
    makeChart('statusChart', 'doughnut',
        [<c:forEach items="${applicationsByStatus}" var="e">'${e.key}',</c:forEach>],
        [<c:forEach items="${applicationsByStatus}" var="e">${e.value},</c:forEach>],
        ['#3B82F6','#F59E0B','#10B981','#EF4444']);

    // User Role Chart
    makeChart('roleChart', 'pie',
        [<c:forEach items="${usersByRole}" var="e">'${e.key}',</c:forEach>],
        [<c:forEach items="${usersByRole}" var="e">${e.value},</c:forEach>],
        ['#6366F1','#10B981','#F59E0B']);

    // Employment Type Chart
    makeChart('typeChart', 'bar',
        [<c:forEach items="${jobsByType}" var="e">'${e.key}',</c:forEach>],
        [<c:forEach items="${jobsByType}" var="e">${e.value},</c:forEach>],
        null);
</script>

</body>
</html>
