<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa việc làm - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-100 flex">

<%-- Sidebar --%>
<aside class="w-64 min-h-screen bg-gray-900 text-white flex flex-col fixed top-0 left-0 z-40">
    <div class="p-6 border-b border-gray-700">
        <a href="${pageContext.request.contextPath}/" class="text-2xl font-extrabold text-blue-400">DreamJob</a>
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
           class="flex items-center px-4 py-3 rounded-xl text-white bg-blue-600 font-semibold">
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
<div class="ml-64 flex-grow p-8 max-w-4xl">
    <%-- Breadcrumb --%>
    <div class="flex items-center gap-2 text-sm text-gray-500 mb-6">
        <a href="${pageContext.request.contextPath}/admin/jobs" class="hover:text-blue-600 transition">Quản lý việc làm</a>
        <span>›</span>
        <span class="text-gray-800 font-semibold">Sửa: ${job.title}</span>
    </div>

    <div class="bg-white rounded-2xl shadow-xl border border-gray-100 p-8">
        <h1 class="text-2xl font-extrabold text-gray-900 mb-6">Chỉnh sửa việc làm <span class="text-blue-500">#${job.jobId}</span></h1>

        <c:if test="${not empty error}">
            <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 text-red-700 rounded-xl">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/jobs/edit" method="POST" class="space-y-6">
            <input type="hidden" name="jobId" value="${job.jobId}">
            <input type="hidden" name="page"  value="${param.page != null ? param.page : 1}">

            <%-- Title --%>
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Tiêu đề công việc *</label>
                <input type="text" name="title" required value="${job.title}"
                       class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none">
            </div>

            <%-- Company info (read-only) --%>
            <div class="bg-blue-50 rounded-xl p-4 text-sm text-blue-800">
                <span class="font-semibold">Công ty:</span> ${job.companyName}
                &nbsp;|&nbsp; <span class="font-semibold">Recruiter ID:</span> ${job.recruiterId}
            </div>

            <%-- Description --%>
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả công việc</label>
                <textarea name="description" rows="5"
                          class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none">${job.description}</textarea>
            </div>

            <%-- Requirements --%>
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Yêu cầu</label>
                <textarea name="requirements" rows="4"
                          class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none">${job.requirements}</textarea>
            </div>

            <%-- Salary row --%>
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Lương tối thiểu (VNĐ)</label>
                    <input type="number" name="salaryMin" min="0" value="${job.salaryMin}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none"
                           placeholder="Ví dụ: 8000000">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Lương tối đa (VNĐ)</label>
                    <input type="number" name="salaryMax" min="0" value="${job.salaryMax}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none"
                           placeholder="Ví dụ: 15000000">
                </div>
            </div>

            <%-- Category + Location --%>
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Danh mục</label>
                    <select name="categoryId" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 bg-white">
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" ${job.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Địa điểm</label>
                    <select name="locationId" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 bg-white">
                        <option value="">-- Chọn địa điểm --</option>
                        <c:forEach var="loc" items="${locations}">
                            <option value="${loc.locationId}" ${job.locationId == loc.locationId ? 'selected' : ''}>${loc.city}, ${loc.country}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <%-- Employment type + Status --%>
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Loại hình</label>
                    <select name="employmentType" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 bg-white">
                        <option value="">-- Chọn loại --</option>
                        <option value="Full-time"   ${job.employmentType == 'Full-time'   ? 'selected' : ''}>Full-time</option>
                        <option value="Part-time"   ${job.employmentType == 'Part-time'   ? 'selected' : ''}>Part-time</option>
                        <option value="Internship"  ${job.employmentType == 'Internship'  ? 'selected' : ''}>Internship</option>
                        <option value="Freelance"   ${job.employmentType == 'Freelance'   ? 'selected' : ''}>Freelance</option>
                        <option value="Remote"      ${job.employmentType == 'Remote'      ? 'selected' : ''}>Remote</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Trạng thái</label>
                    <select name="status" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 bg-white">
                        <option value="ACTIVE" ${job.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="CLOSED" ${job.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                    </select>
                </div>
            </div>

            <%-- Expired date --%>
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Ngày hết hạn</label>
                <input type="date" name="expiredDateStr"
                       value="<fmt:formatDate value='${job.expiredDate}' pattern='yyyy-MM-dd'/>"
                       class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none">
            </div>

            <%-- Buttons --%>
            <div class="flex justify-end gap-4 pt-4 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/admin/jobs?page=${param.page != null ? param.page : 1}"
                   class="px-6 py-3 text-gray-600 font-bold hover:text-gray-900 transition">Hủy</a>
                <button type="submit"
                        class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-10 rounded-xl transition shadow-lg">
                    Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
