<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <h1 class="text-3xl font-extrabold text-gray-900 mb-8">Việc làm đã lưu</h1>

    <c:choose>
        <c:when test="${empty savedJobs}">
            <div class="text-center py-24 bg-white rounded-2xl border border-gray-100">
                <svg class="w-24 h-24 mx-auto text-gray-200 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z"></path>
                </svg>
                <p class="text-xl font-semibold text-gray-500">Bạn chưa lưu việc làm nào.</p>
                <a href="${pageContext.request.contextPath}/search" class="mt-6 inline-block bg-teal-600 text-white font-bold px-8 py-3 rounded-xl hover:bg-teal-700 transition">Tìm việc ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach items="${savedJobs}" var="job">
                    <div class="bg-white border border-gray-100 rounded-2xl p-6 hover:shadow-xl transition group">
                        <div class="flex items-start justify-between mb-4">
                            <div class="w-14 h-14 bg-gray-50 rounded-xl border border-gray-100 flex items-center justify-center p-2">
                                <img src="${not empty job.logoPath ? job.logoPath : 'https://via.placeholder.com/100'}" alt="logo" class="max-w-full max-h-full object-contain">
                            </div>
                            <span class="bg-teal-50 text-teal-600 text-xs font-bold px-3 py-1 rounded-full uppercase">${job.employmentType}</span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/jobs/${job.jobId}">
                            <h3 class="text-lg font-bold text-gray-900 mb-1 group-hover:text-teal-600 transition">${job.title}</h3>
                        </a>
                        <p class="text-teal-600 font-semibold text-sm mb-4">${job.companyName}</p>
                        
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="flex items-center text-gray-500 text-sm bg-gray-50 px-3 py-1 rounded-lg">${job.city}</span>
                            <span class="flex items-center text-green-600 text-sm bg-green-50 px-3 py-1 rounded-lg font-medium">
                                <fmt:formatNumber value="${job.salaryMin/1000000}" pattern="#.#"/>tr - <fmt:formatNumber value="${job.salaryMax/1000000}" pattern="#.#"/>tr
                            </span>
                        </div>
                        
                        <div class="flex gap-2 pt-4 border-t border-gray-50">
                            <a href="${pageContext.request.contextPath}/jobs/${job.jobId}" class="flex-grow text-center bg-teal-600 hover:bg-teal-700 text-white text-sm font-bold py-2 px-4 rounded-xl transition">Xem chi tiết</a>
                            <button onclick="removeSaved(this, ${job.jobId})" class="text-sm text-red-500 hover:text-red-700 border border-red-200 hover:border-red-400 py-2 px-4 rounded-xl transition">Bỏ lưu</button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<script>
function removeSaved(btn, jobId) {
    fetch('/saved-jobs/toggle', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'jobId=' + jobId
    }).then(r => r.text()).then(res => {
        if (res === 'unsaved') {
            btn.closest('.group').remove();
        }
    });
}
</script>

<c:import url="../layout/footer.jsp" />
