<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="flex-grow">
    <div class="bg-gradient-to-r from-blue-700 to-indigo-700 py-14">
        <div class="max-w-7xl mx-auto px-4">
            <h1 class="text-4xl font-extrabold text-white mb-6 text-center">Tìm kiếm việc làm</h1>
            
            <form action="${pageContext.request.contextPath}/search" method="GET" class="max-w-4xl mx-auto bg-white p-3 rounded-2xl shadow-2xl flex gap-3">
                <input type="text" name="keyword" value="${keyword}" placeholder="Vị trí, kỹ năng, công ty..." class="flex-grow px-4 py-3 focus:outline-none text-gray-800 text-sm">
                <select name="locationId" class="px-4 py-3 border-l border-gray-100 bg-white text-gray-700 text-sm focus:outline-none">
                    <option value="">Tất cả địa điểm</option>
                    <c:forEach items="${locations}" var="loc">
                        <option value="${loc.locationId}" ${selectedLocation == loc.locationId.toString() ? 'selected' : ''}>${loc.city}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold px-8 py-3 rounded-xl transition">Tìm kiếm</button>
            </form>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Filter Sidebar -->
            <aside class="lg:w-72 flex-shrink-0">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="space-y-6 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <h3 class="text-lg font-bold text-gray-900 border-b border-gray-100 pb-3">Bộ lọc tìm kiếm</h3>
                    
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-3">Danh mục</label>
                        <div class="space-y-2 max-h-48 overflow-y-auto">
                            <label class="flex items-center gap-2 cursor-pointer select-none py-1 px-2 rounded-lg hover:bg-blue-50 transition">
                                <input type="radio" name="categoryId" value="" ${empty selectedCategory ? 'checked' : ''} class="text-blue-600"> <span class="text-sm">Tất cả</span>
                            </label>
                            <c:forEach items="${categories}" var="cat">
                                <label class="flex items-center gap-2 cursor-pointer select-none py-1 px-2 rounded-lg hover:bg-blue-50 transition">
                                    <input type="radio" name="categoryId" value="${cat.categoryId}" ${selectedCategory == cat.categoryId.toString() ? 'checked' : ''} class="text-blue-600"> <span class="text-sm">${cat.categoryName}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-3">Loại hình</label>
                        <div class="space-y-2">
                            <c:set var="types" value="${{'FULL_TIME','PART_TIME','CONTRACT','INTERNSHIP','REMOTE'}}"/>
                            <c:forEach items="${types}" var="t">
                                <label class="flex items-center gap-2 cursor-pointer select-none py-1 px-2 rounded-lg hover:bg-blue-50 transition">
                                    <input type="checkbox" name="employmentType" value="${t}" ${selectedType == t ? 'checked' : ''} class="text-blue-600">
                                    <span class="text-sm">${t == 'FULL_TIME' ? 'Toàn thời gian' : t == 'PART_TIME' ? 'Bán thời gian' : t == 'CONTRACT' ? 'Hợp đồng' : t == 'INTERNSHIP' ? 'Thực tập' : 'Remote'}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-3">Mức lương (VND)</label>
                        <div class="space-y-3">
                            <input type="number" name="salaryMin" value="${salaryMin}" placeholder="Từ (VD: 10000000)" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none">
                            <input type="number" name="salaryMax" value="${salaryMax}" placeholder="Đến (VD: 50000000)" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2">Sắp xếp theo</label>
                        <select name="sortBy" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm bg-white focus:ring-2 focus:ring-blue-500">
                            <option value="newest"      ${sortBy == 'newest'      ? 'selected' : ''}>Mới nhất</option>
                            <option value="salary_desc" ${sortBy == 'salary_desc' ? 'selected' : ''}>Lương cao nhất</option>
                            <option value="salary_asc"  ${sortBy == 'salary_asc'  ? 'selected' : ''}>Lương thấp nhất</option>
                            <option value="oldest"      ${sortBy == 'oldest'      ? 'selected' : ''}>Cũ nhất</option>
                        </select>
                    </div>

                    <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl hover:bg-blue-700 transition">Áp dụng bộ lọc</button>
                    <a href="${pageContext.request.contextPath}/search" class="block text-center text-sm text-gray-500 hover:text-blue-600 transition">Xóa bộ lọc</a>
                </form>
            </aside>

            <!-- Results -->
            <div class="flex-grow">
                <div class="flex justify-between items-center mb-6">
                    <p class="text-gray-600">Tìm thấy <strong class="text-blue-600">${totalJobs}</strong> việc làm phù hợp</p>
                </div>

                <c:choose>
                    <c:when test="${empty jobs}">
                        <div class="text-center py-24 bg-white rounded-2xl border border-gray-100">
                            <svg class="w-24 h-24 mx-auto text-gray-200 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                            <p class="text-xl font-semibold text-gray-500">Không tìm thấy kết quả phù hợp.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-4">
                            <c:forEach items="${jobs}" var="job">
                                <div class="bg-white border border-gray-100 rounded-2xl p-6 hover:shadow-lg transition group">
                                    <div class="flex items-start gap-5">
                                        <div class="w-16 h-16 rounded-xl bg-gray-50 border border-gray-100 flex items-center justify-center p-2 flex-shrink-0">
                                            <img src="${not empty job.logoPath ? job.logoPath : 'https://via.placeholder.com/100'}" alt="logo" class="max-w-full max-h-full object-contain">
                                        </div>
                                        <div class="flex-grow">
                                            <div class="flex justify-between items-start">
                                                <div>
                                                    <h3 class="text-lg font-bold text-gray-900 group-hover:text-blue-600 transition">
                                                        <a href="${pageContext.request.contextPath}/jobs/${job.jobId}">${job.title}</a>
                                                    </h3>
                                                    <p class="text-blue-600 font-semibold text-sm">${job.companyName}</p>
                                                </div>
                                                <div class="text-right">
                                                    <p class="text-green-600 font-bold">
                                                        <fmt:formatNumber value="${job.salaryMin/1000000}" pattern="#.#"/> - <fmt:formatNumber value="${job.salaryMax/1000000}" pattern="#.#"/>tr
                                                    </p>
                                                    <c:if test="${user.role == 'JOBSEEKER'}">
                                                        <c:set var="isSaved" value="${savedJobIds.contains(job.jobId)}"/>
                                                        <button onclick="toggleSave(this, ${job.jobId})"
                                                            class="save-btn mt-1 text-xs px-3 py-1.5 rounded-lg font-bold transition"
                                                            style="${isSaved ? 'background:#fef9c3;color:#b45309' : 'background:#f3f4f6;color:#4b5563'}">
                                                            <c:choose><c:when test="${isSaved}">★ Đã lưu</c:when><c:otherwise>☆ Lưu lại</c:otherwise></c:choose>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="flex flex-wrap gap-2 mt-3">
                                                <span class="bg-gray-50 text-gray-600 text-xs px-3 py-1 rounded-lg">${job.city}</span>
                                                <span class="bg-blue-50 text-blue-600 text-xs font-bold px-3 py-1 rounded-lg uppercase">${job.employmentType}</span>
                                                <span class="bg-purple-50 text-purple-600 text-xs px-3 py-1 rounded-lg">${job.categoryName}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="flex justify-center mt-10 space-x-2">
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="?keyword=${keyword}&categoryId=${selectedCategory}&locationId=${selectedLocation}&salaryMin=${salaryMin}&salaryMax=${salaryMax}&employmentType=${selectedType}&sortBy=${sortBy}&page=${p}"
                                       class="w-10 h-10 flex items-center justify-center rounded-xl ${p == currentPage ? 'bg-blue-600 text-white font-bold' : 'bg-white text-gray-600 border border-gray-200 hover:border-blue-400 hover:text-blue-600'} transition text-sm">
                                        ${p}
                                    </a>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<script>
function toggleSave(btn, jobId) {
    const contextPath = '${pageContext.request.contextPath}';
    fetch(contextPath + '/saved-jobs/toggle', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'jobId=' + jobId
    }).then(r => r.text()).then(res => {
        if (res === 'saved') {
            btn.textContent = '★ Đã lưu';
            btn.classList.remove('bg-gray-100','text-gray-600');
            btn.classList.add('bg-yellow-100','text-yellow-700');
        } else if (res === 'unsaved') {
            btn.textContent = '☆ Lưu lại';
            btn.classList.remove('bg-yellow-100','text-yellow-700');
            btn.classList.add('bg-gray-100','text-gray-600');
        } else if (res === 'error') {
            alert("Lỗi: Không tìm thấy hồ sơ người tìm việc hoặc bạn cấn đăng nhập lại!");
        } else {
            console.log("Server response:", res);
        }
    }).catch(err => {
        console.error('Fetch error:', err);
    });
}
</script>

<c:import url="../layout/footer.jsp" />
