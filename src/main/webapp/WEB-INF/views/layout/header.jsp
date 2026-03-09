<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DreamJob - Kết nối sự nghiệp</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">

<nav class="bg-white shadow-sm sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/" class="text-2xl font-bold text-teal-600 flex items-center">
                    <svg class="w-8 h-8 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                    DreamJob
                </a>
            </div>
            
            <div class="hidden md:flex items-center space-x-8">
                <a href="${pageContext.request.contextPath}/" class="text-gray-600 hover:text-teal-600 font-medium transition">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/search" class="text-gray-600 hover:text-teal-600 font-medium transition">Tìm việc làm</a>
                <c:if test="${user.role == 'RECRUITER'}">
                    <a href="${pageContext.request.contextPath}/jobs/manage" class="text-gray-600 font-semibold hover:text-teal-700 transition">Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/applications/manage" class="text-gray-600 hover:text-teal-600 font-medium transition">Đơn ứng tuyển</a>
                </c:if>
                <c:if test="${user.role == 'JOBSEEKER'}">
                    <a href="${pageContext.request.contextPath}/saved-jobs" class="text-gray-600 hover:text-teal-600 font-medium transition">Việc đã lưu</a>
                    <a href="${pageContext.request.contextPath}/applications/my" class="text-gray-600 hover:text-teal-600 font-medium transition">Đơn của tôi</a>
                </c:if>
                <c:if test="${user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin" class="text-red-500 font-semibold hover:text-red-700 transition">Quản trị</a>
                </c:if>
            </div>

            <div class="flex items-center space-x-4">
                <c:choose>
                    <c:when test="${not empty user}">
                        <div class="relative group">
                            <div class="flex items-center space-x-2 text-gray-700 hover:text-teal-600 focus:outline-none">
                                <span class="font-medium hidden sm:block">${user.fullName}</span>
                                <div class="w-9 h-9 rounded-full bg-teal-600 flex items-center justify-center text-white font-bold text-sm">
                                    ${user.fullName.substring(0, 1)}
                                </div>
                            </div>
                            <div class="absolute right-0 w-52 bg-white rounded-xl shadow-xl py-2 border border-gray-100 hidden group-hover:block z-50">
                                <div class="px-4 py-2 border-b border-gray-50">
                                    <p class="text-sm font-bold text-gray-900">${user.fullName}</p>
                                    <p class="text-xs text-gray-500">${user.role}</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50">Hồ sơ cá nhân</a>
                                <c:if test="${user.role == 'JOBSEEKER'}">
                                    <a href="${pageContext.request.contextPath}/applications/my" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50">Đơn ứng tuyển</a>
                                    <a href="${pageContext.request.contextPath}/saved-jobs" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50">Việc đã lưu</a>
                                </c:if>
                                <c:if test="${user.role == 'RECRUITER'}">
                                    <a href="${pageContext.request.contextPath}/jobs/manage" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50">Quản lý tin đăng</a>
                                    <a href="${pageContext.request.contextPath}/applications/manage" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50">Quản lý ứng tuyển</a>
                                </c:if>
                                <c:if test="${user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin" class="block px-4 py-2.5 text-sm text-red-600 hover:bg-red-50">Trang quản trị</a>
                                </c:if>
                                <div class="border-t border-gray-50 my-1"></div>
                                <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2.5 text-sm text-red-600 hover:bg-red-50">Đăng xuất</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="text-gray-600 hover:text-teal-600 font-medium">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="bg-teal-600 hover:bg-teal-700 text-white px-5 py-2 rounded-lg font-medium transition shadow-sm">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
