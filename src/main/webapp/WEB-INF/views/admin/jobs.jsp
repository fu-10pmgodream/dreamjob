<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý việc làm - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-100 flex">

<%-- Sidebar --%>
<aside class="w-64 min-h-screen bg-gray-900 text-white flex flex-col fixed top-0 left-0 z-40">
    <div class="p-6 border-b border-gray-700">
        <a href="${pageContext.request.contextPath}/" class="text-2xl font-extrabold text-teal-400">DreamJob</a>
        <p class="text-xs text-gray-400 mt-1">Bảng quản trị hệ thống</p>
    </div>
    <nav class="flex-grow p-4 space-y-2">
        <a href="${pageContext.request.contextPath}/admin"
           class="flex items-center px-4 py-3 rounded-xl text-gray-300 hover:bg-gray-800 hover:text-white transition font-medium">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
            Tổng quan
        </a>
        <a href="${pageContext.request.contextPath}/admin/users"
           class="flex items-center px-4 py-3 rounded-xl text-gray-300 hover:bg-gray-800 hover:text-white transition font-medium">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
            Quản lý người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/jobs"
           class="flex items-center px-4 py-3 rounded-xl text-white bg-teal-600 font-semibold">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
            Quản lý việc làm
        </a>
        <a href="${pageContext.request.contextPath}/logout"
           class="flex items-center px-4 py-3 rounded-xl text-red-400 hover:bg-red-900 hover:text-white transition font-medium mt-8">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
            Đăng xuất
        </a>
    </nav>
</aside>

<%-- Main --%>
<div class="ml-64 flex-grow p-8">

    <%-- Header --%>
    <div class="flex items-center justify-between mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-gray-900">Quản lý việc làm</h1>
            <p class="text-sm text-gray-500 mt-1">Tổng cộng <span class="font-bold text-teal-600">${totalJobs}</span> việc làm</p>
        </div>
    </div>

    <%-- Flash messages --%>
    <c:if test="${not empty param.success}">
        <div class="mb-6 bg-green-50 border-l-4 border-green-500 p-4 text-green-700 rounded-xl">
            <c:choose>
                <c:when test="${param.success == 'updated'}">Cập nhật việc làm thành công!</c:when>
                <c:when test="${param.success == 'deleted'}">Xóa việc làm thành công!</c:when>
                <c:otherwise>Thao tác thành công!</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <%-- Table --%>
    <div class="bg-white shadow-xl rounded-2xl overflow-hidden border border-gray-100">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">ID</th>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">Tiêu đề</th>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">Công ty</th>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">Danh mục</th>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">Loại</th>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">Trạng thái</th>
                    <th class="px-4 py-4 text-left text-xs font-bold text-gray-500 uppercase">Hết hạn</th>
                    <th class="px-4 py-4 text-right text-xs font-bold text-gray-500 uppercase">Thao tác</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-100">
                <c:forEach items="${jobs}" var="j">
                    <tr class="hover:bg-gray-50 transition">
                        <td class="px-4 py-3 text-sm text-gray-400">#${j.jobId}</td>
                        <td class="px-4 py-3">
                            <a href="${pageContext.request.contextPath}/jobs/${j.jobId}"
                               class="font-semibold text-gray-900 hover:text-teal-600 transition text-sm"
                               target="_blank">${j.title}</a>
                        </td>
                        <td class="px-4 py-3 text-sm text-gray-600">${j.companyName}</td>
                        <td class="px-4 py-3 text-sm text-gray-500">${j.categoryName}</td>
                        <td class="px-4 py-3">
                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-indigo-50 text-indigo-700">${j.employmentType}</span>
                        </td>
                        <td class="px-4 py-3">
                            <span class="px-2 py-1 text-xs font-bold rounded-full
                                ${j.status == 'ACTIVE' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}">
                                ${j.status}
                            </span>
                        </td>
                        <td class="px-4 py-3 text-sm text-gray-500">
                            <c:choose>
                                <c:when test="${not empty j.expiredDate}">
                                    <fmt:formatDate value="${j.expiredDate}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise><span class="text-gray-300">—</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-4 py-3 text-right">
                            <div class="flex items-center justify-end gap-2">
                                <%-- Edit --%>
                                <a href="${pageContext.request.contextPath}/admin/jobs/edit/${j.jobId}?page=${currentPage}"
                                   class="text-xs font-bold px-3 py-2 rounded-lg bg-teal-50 text-teal-600 hover:bg-teal-100 transition">
                                    Sửa
                                </a>
                                <%-- Toggle status --%>
                                <form action="${pageContext.request.contextPath}/admin/jobs/toggle-status" method="POST" class="inline">
                                    <input type="hidden" name="jobId" value="${j.jobId}">
                                    <input type="hidden" name="currentStatus" value="${j.status}">
                                    <input type="hidden" name="page" value="${currentPage}">
                                    <button type="submit"
                                        class="text-xs font-bold px-3 py-2 rounded-lg transition
                                               ${j.status == 'ACTIVE' ? 'bg-orange-50 text-orange-600 hover:bg-orange-100' : 'bg-green-50 text-green-600 hover:bg-green-100'}">
                                        ${j.status == 'ACTIVE' ? 'Đóng' : 'Mở'}
                                    </button>
                                </form>
                                <%-- Delete --%>
                                <form action="${pageContext.request.contextPath}/admin/jobs/delete" method="POST" class="inline"
                                      onsubmit="return confirm('Xóa việc làm này? Hành động không thể hoàn tác!')">
                                    <input type="hidden" name="jobId" value="${j.jobId}">
                                    <input type="hidden" name="page" value="${currentPage}">
                                    <button type="submit"
                                        class="text-xs font-bold px-3 py-2 rounded-lg bg-red-50 text-red-600 hover:bg-red-100 transition">
                                        Xóa
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty jobs}">
                    <tr>
                        <td colspan="8" class="px-6 py-12 text-center text-gray-400 text-sm">Không có việc làm nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <div class="flex items-center justify-between px-6 py-4 border-t border-gray-100 bg-gray-50">
                <p class="text-sm text-gray-500">
                    Trang <span class="font-semibold text-gray-800">${currentPage}</span>
                    / <span class="font-semibold text-gray-800">${totalPages}</span>
                </p>
                <div class="flex items-center gap-1">
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="?page=1" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium">«</a>
                            <a href="?page=${currentPage - 1}" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium">‹</a>
                        </c:when>
                        <c:otherwise>
                            <span class="px-3 py-2 text-sm rounded-lg text-gray-300 cursor-not-allowed font-medium">«</span>
                            <span class="px-3 py-2 text-sm rounded-lg text-gray-300 cursor-not-allowed font-medium">‹</span>
                        </c:otherwise>
                    </c:choose>
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
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium">›</a>
                            <a href="?page=${totalPages}" class="px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-200 transition font-medium">»</a>
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
