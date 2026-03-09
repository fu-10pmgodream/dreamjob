<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<div class="bg-teal-50 py-10">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 flex flex-col md:flex-row items-center justify-between gap-6">
            <div class="flex items-center gap-6">
                <div class="w-24 h-24 bg-white rounded-2xl shadow-md border border-gray-100 flex items-center justify-center p-3">
                    <img src="${not empty job.logoPath ? job.logoPath : 'https://via.placeholder.com/200'}" alt="logo" class="max-w-full max-h-full object-contain">
                </div>
                <div>
                    <h1 class="text-3xl font-extrabold text-gray-900 mb-2">${job.title}</h1>
                    <div class="flex flex-wrap items-center gap-4 text-gray-600">
                        <span class="flex items-center font-semibold text-teal-600">
                            <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                            ${job.companyName}
                        </span>
                        <span class="flex items-center">
                            <svg class="w-5 h-5 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path></svg>
                            ${job.city}
                        </span>
                        <span class="bg-teal-50 text-teal-600 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider">${job.employmentType}</span>
                    </div>
                </div>
            </div>
            
            <div class="text-right">
                <p class="text-2xl font-bold text-green-600 mb-4">
                    <fmt:formatNumber value="${job.salaryMin / 1000000}" pattern="#.#"/> - <fmt:formatNumber value="${job.salaryMax / 1000000}" pattern="#.#"/> triệu VND
                </p>
                <c:choose>
                    <c:when test="${user.role == 'JOBSEEKER'}">
                        <div class="flex flex-col sm:flex-row gap-3 justify-end">
                            <%-- Nút Lưu lại --%>
                            <button id="saveBtn" onclick="toggleSave(${job.jobId})"
                                class="flex items-center gap-2 font-bold py-4 px-6 rounded-2xl transition border-2
                                       ${isSaved ? 'bg-yellow-50 border-yellow-400 text-yellow-700 hover:bg-yellow-100' : 'bg-white border-gray-200 text-gray-600 hover:border-teal-400 hover:text-teal-600'}">
                                <span id="saveBtnIcon">${isSaved ? '★' : '☆'}</span>
                                <span id="saveBtnText">${isSaved ? 'Đã lưu' : 'Lưu việc'}</span>
                            </button>
                            <%-- Nút Ứng tuyển --%>
                            <c:choose>
                                <c:when test="${hasApplied}">
                                    <button disabled class="bg-gray-400 text-white font-bold py-4 px-10 rounded-2xl cursor-not-allowed">Đã ứng tuyển</button>
                                </c:when>
                                <c:otherwise>
                                    <button onclick="document.getElementById('applyModal').classList.remove('hidden')" class="bg-teal-600 hover:bg-teal-700 text-white font-bold py-4 px-10 rounded-2xl transition shadow-xl transform hover:-translate-y-1">Ứng tuyển ngay</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:when test="${empty user}">
                        <a href="${pageContext.request.contextPath}/login" class="bg-gray-800 hover:bg-gray-900 text-white font-bold py-4 px-10 rounded-2xl transition shadow-xl block text-center">Đăng nhập để ứng tuyển</a>
                    </c:when>
                </c:choose>
            </div>
        </div>

        <c:if test="${param.applied == 'success'}">
            <div class="mt-6 bg-green-50 border-l-4 border-green-500 p-4 text-green-700 rounded-lg">Chúc mừng! Bạn đã ứng tuyển thành công. Nhà tuyển dụng sẽ sớm liên hệ với bạn.</div>
        </c:if>
        <c:if test="${param.applied == 'error'}">
            <div class="mt-6 bg-red-50 border-l-4 border-red-500 p-4 text-red-700 rounded-lg">Đã có lỗi xảy ra khi ứng tuyển. Vui lòng thử lại sau.</div>
        </c:if>
    </div>
</div>

<!-- Apply Modal -->
<div id="applyModal" class="fixed inset-0 bg-black bg-opacity-50 z-[100] flex items-center justify-center p-4 hidden">
    <div class="bg-white rounded-3xl max-w-lg w-full overflow-hidden shadow-2xl">
        <div class="bg-teal-600 p-6 text-white flex justify-between items-center">
            <h3 class="text-xl font-bold">Ứng tuyển: ${job.title}</h3>
            <button onclick="document.getElementById('applyModal').classList.add('hidden')" class="text-white hover:text-teal-200">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/jobs/apply" method="POST" enctype="multipart/form-data" class="p-8 space-y-6">
            <input type="hidden" name="jobId" value="${job.jobId}">
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Lời nhắn gửi nhà tuyển dụng (Cover Letter)</label>
                <textarea name="coverLetter" rows="4" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none" placeholder="Giới thiệu ngắn gọn kinh nghiệm của bạn..."></textarea>
            </div>
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Tải lên CV (PDF/Ảnh)</label>
                <input type="file" name="cvFile" required class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-teal-50 file:text-teal-700 hover:file:bg-teal-100">
            </div>
            <button type="submit" class="w-full bg-teal-600 hover:bg-teal-700 text-white font-bold py-4 rounded-xl transition shadow-lg">Gửi hồ sơ ứng tuyển</button>
        </form>
    </div>
</div>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 grid grid-cols-1 lg:grid-cols-3 gap-10">
    <!-- Left Column: Content -->
    <div class="lg:col-span-2 space-y-10">
        <section class="bg-white rounded-3xl p-8 border border-gray-100 shadow-sm">
            <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                <span class="w-2 h-8 bg-teal-600 rounded-full mr-3"></span> MÔ TẢ CÔNG VIỆC
            </h2>
            <div class="text-gray-700 leading-relaxed whitespace-pre-line">${job.description}</div>
        </section>

        <section class="bg-white rounded-3xl p-8 border border-gray-100 shadow-sm">
            <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                <span class="w-2 h-8 bg-teal-600 rounded-full mr-3"></span> YÊU CẦU CÔNG VIỆC
            </h2>
            <div class="text-gray-700 leading-relaxed whitespace-pre-line">${job.requirements}</div>
        </section>
    </div>

    <!-- Right Column: Sidebar -->
    <div class="space-y-8">
        <div class="bg-white rounded-3xl p-8 border border-gray-100 shadow-sm">
            <h3 class="text-xl font-bold text-gray-900 mb-6 border-b border-gray-50 pb-4">Thông tin chung</h3>
            <ul class="space-y-4">
                <li class="flex justify-between">
                    <span class="text-gray-500">Lĩnh vực:</span>
                    <span class="font-bold text-gray-900">${job.categoryName}</span>
                </li>
                <li class="flex justify-between">
                    <span class="text-gray-500">Ngày đăng:</span>
                    <span class="font-bold text-gray-900"><fmt:formatDate value="${job.postedDate}" pattern="dd/MM/yyyy"/></span>
                </li>
                <li class="flex justify-between">
                    <span class="text-gray-500">Hạn nộp:</span>
                    <span class="font-bold text-red-500"><fmt:formatDate value="${job.expiredDate}" pattern="dd/MM/yyyy"/></span>
                </li>
            </ul>
        </div>

        <div>
            <h3 class="text-xl font-bold text-gray-900 mb-6">Việc làm tương tự</h3>
            <div class="space-y-4">
                <c:forEach items="${similarJobs}" var="sj">
                    <div class="bg-white p-4 rounded-2xl border border-gray-50 hover:shadow-md transition cursor-pointer" onclick="location.href='${pageContext.request.contextPath}/jobs/${sj.jobId}'">
                        <h4 class="font-bold text-gray-900 truncate">${sj.title}</h4>
                        <p class="text-sm text-teal-600 mb-2">${sj.companyName}</p>
                        <div class="flex justify-between text-xs text-gray-500">
                            <span>${sj.city}</span>
                            <span class="text-green-600 font-bold"><fmt:formatNumber value="${sj.salaryMax / 1000000}" pattern="#.#"/>tr</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<c:if test="${user.role == 'JOBSEEKER'}">
<script>
function toggleSave(jobId) {
    const contextPath = '${pageContext.request.contextPath}';
    const btn = document.getElementById('saveBtn');
    const icon = document.getElementById('saveBtnIcon');
    const text = document.getElementById('saveBtnText');
    btn.disabled = true;
    fetch(contextPath + '/saved-jobs/toggle', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'jobId=' + jobId
    }).then(r => r.text()).then(res => {
        if (res === 'saved') {
            icon.textContent = '★';
            text.textContent = 'Đã lưu';
            btn.className = btn.className
                .replace('bg-white border-gray-200 text-gray-600 hover:border-teal-400 hover:text-teal-600',
                         'bg-yellow-50 border-yellow-400 text-yellow-700 hover:bg-yellow-100');
        } else if (res === 'unsaved') {
            icon.textContent = '☆';
            text.textContent = 'Lưu việc';
            btn.className = btn.className
                .replace('bg-yellow-50 border-yellow-400 text-yellow-700 hover:bg-yellow-100',
                         'bg-white border-gray-200 text-gray-600 hover:border-teal-400 hover:text-teal-600');
        } else {
            alert('Có lỗi xảy ra, vui lòng đăng nhập lại!');
        }
        btn.disabled = false;
    }).catch(() => { btn.disabled = false; });
}
</script>
</c:if>

<c:import url="../layout/footer.jsp" />
