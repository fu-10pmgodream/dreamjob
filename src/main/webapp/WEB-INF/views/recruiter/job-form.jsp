<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="bg-white rounded-3xl shadow-2xl overflow-hidden border border-gray-100">
        <div class="bg-blue-600 px-8 py-10 text-white">
            <h1 class="text-3xl font-extrabold">${not empty job ? 'Cập nhật tin tuyển dụng' : 'Đăng tin tuyển dụng mới'}</h1>
            <p class="text-blue-100 mt-2">Điền đầy đủ thông tin để thu hút ứng viên tài năng nhất</p>
        </div>

        <%-- Thông báo lỗi từ server --%>
        <c:if test="${not empty error}">
            <div class="mx-8 mt-6 bg-red-50 border-l-4 border-red-500 p-4 text-red-700 text-sm rounded-lg flex items-center gap-2">
                <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                ${error}
            </div>
        </c:if>

        <%-- Thông báo lỗi validation JS --%>
        <div id="validationError" class="mx-8 mt-6 bg-red-50 border-l-4 border-red-500 p-4 text-red-700 text-sm rounded-lg hidden flex items-center gap-2">
            <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <span id="validationMsg"></span>
        </div>

        <form id="jobForm" action="${pageContext.request.contextPath}/jobs/${not empty job ? 'edit' : 'create'}" method="POST"
              class="p-8 space-y-8" onsubmit="return validateForm()">
            <c:if test="${not empty job}">
                <input type="hidden" name="jobId" value="${job.jobId}">
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

                <%-- Tiêu đề công việc --%>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Tiêu đề công việc <span class="text-red-500">*</span></label>
                    <input type="text" name="title" id="title" value="${job.title}" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none transition shadow-sm"
                           placeholder="Ví dụ: Senior Java Developer">
                </div>

                <%-- Loại hình làm việc --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Loại hình làm việc <span class="text-red-500">*</span></label>
                    <select name="employmentType" id="employmentType" required
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white shadow-sm">
                        <option value="">-- Chọn loại hình --</option>
                        <option value="FULL_TIME"   ${job.employmentType == 'FULL_TIME'   ? 'selected' : ''}>Toàn thời gian</option>
                        <option value="PART_TIME"   ${job.employmentType == 'PART_TIME'   ? 'selected' : ''}>Bán thời gian</option>
                        <option value="CONTRACT"    ${job.employmentType == 'CONTRACT'    ? 'selected' : ''}>Hợp đồng</option>
                        <option value="INTERNSHIP"  ${job.employmentType == 'INTERNSHIP'  ? 'selected' : ''}>Thực tập</option>
                        <option value="REMOTE"      ${job.employmentType == 'REMOTE'      ? 'selected' : ''}>Làm việc từ xa</option>
                    </select>
                </div>

                <%-- Danh mục (dropdown) --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Danh mục ngành nghề <span class="text-red-500">*</span></label>
                    <select name="categoryId" id="categoryId" required
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white shadow-sm">
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.categoryId}" ${job.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- Lương tối thiểu --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Lương tối thiểu (VND) <span class="text-red-500">*</span></label>
                    <input type="number" name="salaryMin" id="salaryMin" value="${job.salaryMin}" required
                           min="0" step="500000"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm"
                           placeholder="Ví dụ: 10000000">
                </div>

                <%-- Lương tối đa --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Lương tối đa (VND) <span class="text-red-500">*</span></label>
                    <input type="number" name="salaryMax" id="salaryMax" value="${job.salaryMax}" required
                           min="0" step="500000"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm"
                           placeholder="Ví dụ: 30000000">
                </div>

                <%-- Địa điểm (dropdown) --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Địa điểm làm việc <span class="text-red-500">*</span></label>
                    <select name="locationId" id="locationId" required
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white shadow-sm">
                        <option value="">-- Chọn địa điểm --</option>
                        <c:forEach items="${locations}" var="loc">
                            <option value="${loc.locationId}" ${job.locationId == loc.locationId ? 'selected' : ''}>${loc.city}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- Hạn nộp đơn --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Hạn nộp đơn <span class="text-red-500">*</span></label>
                    <input type="date" name="expiredDateStr" id="expiredDate" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm"
                           value="<c:if test='${not empty job}'><fmt:formatDate value='${job.expiredDate}' pattern='yyyy-MM-dd'/></c:if>">
                    <p class="text-xs text-gray-400 mt-1">Hạn nộp phải sau ngày hôm nay</p>
                </div>

                <%-- Mô tả công việc --%>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả công việc <span class="text-red-500">*</span></label>
                    <textarea name="description" id="description" rows="5" required
                              class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm"
                              placeholder="Chi tiết các nhiệm vụ, trách nhiệm...">${job.description}</textarea>
                </div>

                <%-- Yêu cầu ứng viên --%>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Yêu cầu ứng viên <span class="text-red-500">*</span></label>
                    <textarea name="requirements" id="requirements" rows="5" required
                              class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm"
                              placeholder="Kỹ năng, kinh nghiệm cần thiết...">${job.requirements}</textarea>
                </div>
            </div>

            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/jobs/manage" class="px-6 py-3 text-gray-600 font-bold hover:text-gray-900 transition mt-2">Hủy bỏ</a>
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-10 rounded-xl transition shadow-lg transform hover:-translate-y-1">
                    ${not empty job ? 'Lưu thay đổi' : 'Đăng tin ngay'}
                </button>
            </div>
        </form>
    </div>
</main>

<script>
function validateForm() {
    const errBox = document.getElementById('validationError');
    const errMsg = document.getElementById('validationMsg');

    function showErr(msg) {
        errMsg.textContent = msg;
        errBox.classList.remove('hidden');
        errBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
        return false;
    }
    errBox.classList.add('hidden');

    // Kiểm tra các trường bắt buộc
    const requiredFields = [
        { id: 'title',          label: 'Tiêu đề công việc' },
        { id: 'employmentType', label: 'Loại hình làm việc' },
        { id: 'categoryId',     label: 'Danh mục ngành nghề' },
        { id: 'salaryMin',      label: 'Lương tối thiểu' },
        { id: 'salaryMax',      label: 'Lương tối đa' },
        { id: 'locationId',     label: 'Địa điểm làm việc' },
        { id: 'expiredDate',    label: 'Hạn nộp đơn' },
        { id: 'description',    label: 'Mô tả công việc' },
        { id: 'requirements',   label: 'Yêu cầu ứng viên' },
    ];
    for (const f of requiredFields) {
        const el = document.getElementById(f.id);
        if (!el || !el.value.trim()) {
            return showErr('Vui lòng điền đầy đủ: "' + f.label + '"');
        }
    }

    // Kiểm tra lương phải là số dương
    const salaryMin = parseFloat(document.getElementById('salaryMin').value);
    const salaryMax = parseFloat(document.getElementById('salaryMax').value);
    if (salaryMin < 0) return showErr('Lương tối thiểu phải là số dương!');
    if (salaryMax < 0) return showErr('Lương tối đa phải là số dương!');
    if (salaryMax <= salaryMin) return showErr('Lương tối đa phải lớn hơn lương tối thiểu!');

    // Kiểm tra hạn nộp phải sau ngày hôm nay
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const expired = new Date(document.getElementById('expiredDate').value);
    if (expired <= today) return showErr('Hạn nộp đơn phải là ngày sau ngày hôm nay!');

    return true;
}

// Set min date cho input date = ngày mai
(function() {
    const el = document.getElementById('expiredDate');
    if (el) {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        el.min = tomorrow.toISOString().split('T')[0];
    }
})();
</script>

<c:import url="../layout/footer.jsp" />
