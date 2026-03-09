<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-100 flex">

<aside class="w-64 min-h-screen bg-gray-900 text-white flex flex-col fixed top-0 left-0 z-40">
    <div class="p-6 border-b border-gray-700">
        <a href="${pageContext.request.contextPath}/" class="text-2xl font-extrabold text-teal-400">DreamJob</a>
        <p class="text-xs text-gray-400 mt-1">Bảng quản trị hệ thống</p>
    </div>
    <nav class="flex-grow p-4 space-y-2">
        <a href="${pageContext.request.contextPath}/admin" class="flex items-center px-4 py-3 rounded-xl text-gray-300 hover:bg-gray-800 hover:text-white transition font-medium">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
            Tổng quan
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center px-4 py-3 rounded-xl text-white bg-teal-600 font-semibold">
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

<div class="ml-64 flex-grow p-8">

    <%-- Header row --%>
    <div class="flex items-center justify-between mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-gray-900">Quản lý người dùng</h1>
            <p class="text-sm text-gray-500 mt-1">Tổng cộng <span class="font-bold text-teal-600">${totalUsers}</span> người dùng</p>
        </div>
    </div>

    <%-- Table --%>
    <div class="bg-white shadow-xl rounded-2xl overflow-hidden border border-gray-100">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">ID</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Họ tên</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Email</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Vai trò</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Ngày tạo</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Trạng thái</th>
                    <th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase">Thao tác</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-100">
                <c:forEach items="${users}" var="u">
                    <tr class="hover:bg-gray-50 transition">
                        <td class="px-6 py-4 text-sm text-gray-400">#${u.userId}</td>
                        <td class="px-6 py-4 font-semibold text-gray-900">${u.fullName}</td>
                        <td class="px-6 py-4 text-sm text-gray-600">${u.email}</td>
                        <td class="px-6 py-4">
                            <span class="px-2 py-1 text-xs font-bold rounded-full
                                ${u.role == 'ADMIN'     ? 'bg-red-100 text-red-700' :
                                  u.role == 'RECRUITER' ? 'bg-teal-100 text-teal-700' :
                                  'bg-green-100 text-green-700'}">
                                ${u.role}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-500"><fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/></td>
                        <td class="px-6 py-4">
                            <span class="px-2 py-1 text-xs font-bold rounded-full ${u.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}">
                                ${u.active ? 'Hoạt động' : 'Bị khóa'}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <c:if test="${u.role != 'ADMIN'}">
                                <form action="${pageContext.request.contextPath}/admin/users/toggle" method="POST" class="inline">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <input type="hidden" name="page"   value="${currentPage}">
                                    <button type="submit" class="text-xs font-bold px-3 py-2 rounded-lg transition
                                        ${u.active ? 'bg-red-50 text-red-600 hover:bg-red-100' : 'bg-green-50 text-green-600 hover:bg-green-100'}">
                                        ${u.active ? 'Khóa' : 'Mở khóa'}
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <%-- Pagination bar --%>
        <c:if test="${totalPages > 1}">
            <div class="flex items-center justify-between px-6 py-4 border-t border-gray-100 bg-gray-50">

                <%-- Info --%>
                <p class="text-sm text-gray-500">
                    Trang <span class="font-semibold text-gray-800">${currentPage}</span>
                    / <span class="font-semibold text-gray-800">${totalPages}</span>
                </p>

                <%-- Buttons --%>
                <div class="flex items-center gap-1">

                    <%-- First --%>
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="?page=1" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium" title="Trang đầu">«</a>
                            <a href="?page=${currentPage - 1}" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium">‹</a>
                        </c:when>
                        <c:otherwise>
                            <span class="px-3 py-2 text-sm rounded-lg text-gray-300 cursor-not-allowed font-medium">«</span>
                            <span class="px-3 py-2 text-sm rounded-lg text-gray-300 cursor-not-allowed font-medium">‹</span>
                        </c:otherwise>
                    </c:choose>

                    <%-- Page numbers (show up to 5 around current) --%>
                    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}"/>
                    <c:set var="endPage"   value="${startPage + 4 > totalPages ? totalPages : startPage + 4}"/>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <c:choose>
                            <c:when test="${p == currentPage}">
                                <span class="px-3 py-2 text-sm rounded-lg bg-teal-600 text-white font-bold shadow-sm">${p}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${p}" class="px-3 py-2 text-sm rounded-lg text-gray-700 hover:bg-gray-200 transition font-medium">${p}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Next / Last --%>
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium">›</a>
                            <a href="?page=${totalPages}" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium" title="Trang cuối">»</a>
                        </c:when>
                        <c:otherwise>
                            <span class="px-3 py-2 text-sm rounded-lg text-gray-300 cursor-not-allowed font-medium">›</span>
                            <span class="px-3 py-2 text-sm rounded-lg text-gray-300 cursor-not-allowed font-medium">»</span>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
