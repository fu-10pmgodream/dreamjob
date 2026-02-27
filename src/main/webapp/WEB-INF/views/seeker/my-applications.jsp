<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <h1 class="text-3xl font-extrabold text-gray-900 mb-8">Đơn ứng tuyển của tôi</h1>

    <c:choose>
        <c:when test="${empty applications}">
            <div class="text-center py-24">
                <svg class="w-24 h-24 mx-auto text-gray-200 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                <p class="text-xl font-semibold text-gray-500">Bạn chưa ứng tuyển công việc nào.</p>
                <a href="${pageContext.request.contextPath}/search" class="mt-6 inline-block bg-blue-600 text-white font-bold px-8 py-3 rounded-xl hover:bg-blue-700 transition">Khám phá việc làm</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach items="${applications}" var="app">
                    <div class="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm hover:shadow-lg transition">
                        <div class="flex items-center mb-4">
                            <div class="w-14 h-14 rounded-xl bg-gray-50 border border-gray-100 flex items-center justify-center mr-4 p-2">
                                <img src="${not empty app.companyLogo ? app.companyLogo : 'https://via.placeholder.com/100'}" alt="logo" class="max-w-full max-h-full object-contain">
                            </div>
                            <div>
                                <h3 class="font-bold text-gray-900">${app.jobTitle}</h3>
                                <p class="text-sm text-blue-600">${app.companyName}</p>
                            </div>
                        </div>
                        <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-50">
                            <span class="text-xs text-gray-400">Nộp <fmt:formatDate value="${app.appliedDate}" pattern="dd/MM/yyyy"/></span>
                            <span class="px-3 py-1 text-xs font-bold rounded-full 
                                ${app.status == 'ACCEPTED'  ? 'bg-green-100 text-green-700' : 
                                  app.status == 'REJECTED'  ? 'bg-red-100 text-red-700' :
                                  app.status == 'REVIEWING' ? 'bg-yellow-100 text-yellow-700' :
                                  'bg-gray-100 text-gray-600'}">
                                ${app.status == 'PENDING'   ? 'Chờ xét duyệt' :
                                  app.status == 'REVIEWING' ? 'Đang xem xét' :
                                  app.status == 'ACCEPTED'  ? 'Đã chấp nhận' : 'Đã từ chối'}
                            </span>
                        </div>
                        <c:if test="${not empty app.cvPath}">
                            <a href="${app.cvPath}" target="_blank" class="text-xs text-blue-500 hover:underline mt-3 block">Xem CV đã nộp ↗</a>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<c:import url="../layout/footer.jsp" />
