<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <h1 class="text-3xl font-extrabold text-gray-900 mb-8">Quản lý Đơn Ứng Tuyển</h1>
    
    <c:choose>
        <c:when test="${empty applications}">
            <div class="text-center py-24 text-gray-500">
                <p class="text-xl font-semibold">Chưa có ứng viên nào nộp đơn.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white shadow-xl rounded-2xl overflow-hidden border border-gray-100">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Ứng viên</th>
                            <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Vị trí</th>
                            <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Ngày nộp</th>
                            <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">CV</th>
                            <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Trạng thái</th>
                            <th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <c:forEach items="${applications}" var="app">
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4">
                                    <div class="font-bold text-gray-900">${app.seekerName}</div>
                                    <div class="text-xs text-gray-500">${app.seekerEmail}</div>
                                    <div class="text-xs text-gray-400">${app.seekerPhone}</div>
                                </td>
                                <td class="px-6 py-4 text-sm font-semibold text-gray-700">${app.jobTitle}</td>
                                <td class="px-6 py-4 text-sm text-gray-500">
                                    <fmt:formatDate value="${app.appliedDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td class="px-6 py-4">
                                    <c:if test="${not empty app.cvPath}">
                                        <a href="${app.cvPath}" target="_blank" class="text-blue-600 hover:underline text-sm">Xem CV ↗</a>
                                    </c:if>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="px-3 py-1 text-xs font-bold rounded-full 
                                        ${app.status == 'ACCEPTED'  ? 'bg-green-100 text-green-700' : 
                                          app.status == 'REJECTED'  ? 'bg-red-100 text-red-700' :
                                          app.status == 'REVIEWING' ? 'bg-yellow-100 text-yellow-700' :
                                          'bg-gray-100 text-gray-600'}">
                                        ${app.status}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <div class="flex justify-end items-center space-x-2">
                                        <form action="${pageContext.request.contextPath}/applications/status" method="POST" class="flex space-x-2">
                                            <input type="hidden" name="applicationId" value="${app.applicationId}">
                                            <button name="status" value="REVIEWING" class="text-xs bg-yellow-50 text-yellow-700 font-bold px-3 py-2 rounded-lg hover:bg-yellow-100 transition">Đang xem</button>
                                            <button name="status" value="ACCEPTED"  class="text-xs bg-green-50 text-green-700 font-bold px-3 py-2 rounded-lg hover:bg-green-100 transition">Chấp nhận</button>
                                            <button name="status" value="REJECTED"  class="text-xs bg-red-50 text-red-700 font-bold px-3 py-2 rounded-lg hover:bg-red-100 transition">Từ chối</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<c:import url="../layout/footer.jsp" />
