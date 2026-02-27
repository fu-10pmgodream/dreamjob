<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="bg-white rounded-3xl shadow-2xl overflow-hidden border border-gray-100">
        <div class="bg-blue-600 px-8 py-10 text-white">
            <h1 class="text-3xl font-extrabold">${not empty job ? 'Cập nhật tin tuyển dụng' : 'Đăng tin tuyển dụng mới'}</h1>
            <p class="text-blue-100 mt-2">Điền thông tin chi tiết để thu hút ứng viên tài năng nhất</p>
        </div>

        <form action="${pageContext.request.contextPath}/jobs/${not empty job ? 'edit' : 'create'}" method="POST" class="p-8 space-y-8">
            <c:if test="${not empty job}">
                <input type="hidden" name="jobId" value="${job.jobId}">
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Tiêu đề công việc</label>
                    <input type="text" name="title" value="${job.title}" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none transition shadow-sm" placeholder="Ví dụ: Senior Java Developer">
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Loại hình làm việc</label>
                    <select name="employmentType" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white shadow-sm">
                        <option value="FULL_TIME" ${job.employmentType == 'FULL_TIME' ? 'selected' : ''}>Toàn thời gian</option>
                        <option value="PART_TIME" ${job.employmentType == 'PART_TIME' ? 'selected' : ''}>Bán thời gian</option>
                        <option value="CONTRACT" ${job.employmentType == 'CONTRACT' ? 'selected' : ''}>Hợp đồng</option>
                        <option value="INTERNSHIP" ${job.employmentType == 'INTERNSHIP' ? 'selected' : ''}>Thực tập</option>
                        <option value="REMOTE" ${job.employmentType == 'REMOTE' ? 'selected' : ''}>Làm việc từ xa</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số thứ tự Danh mục (CategoryID)</label>
                    <input type="number" name="categoryId" value="${job.categoryId}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm" placeholder="1, 2, 3...">
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Lương tối đa (VND)</label>
                    <input type="number" name="salaryMax" value="${job.salaryMax}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm" placeholder="50000000">
                </div>
                
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Lương tối thiểu (VND)</label>
                    <input type="number" name="salaryMin" value="${job.salaryMin}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm" placeholder="20000000">
                </div>
                
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mã địa điểm (LocationID)</label>
                    <input type="number" name="locationId" value="${job.locationId}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm" placeholder="1, 2, 3...">
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Trạng thái</label>
                    <select name="status" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm bg-white">
                        <option value="ACTIVE" ${job.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động (Active)</option>
                        <option value="CLOSED" ${job.status == 'CLOSED' ? 'selected' : ''}>Đã đóng (Closed)</option>
                        <option value="DRAFT" ${job.status == 'DRAFT' ? 'selected' : ''}>Lưu nháp (Draft)</option>
                    </select>
                </div>

                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả công việc</label>
                    <textarea name="description" rows="5" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm" placeholder="Chi tiết các nhiệm vụ...">${job.description}</textarea>
                </div>

                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Yêu cầu ứng viên</label>
                    <textarea name="requirements" rows="5" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 shadow-sm" placeholder="Kỹ năng, kinh nghiệm cần thiết...">${job.requirements}</textarea>
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

<c:import url="../layout/footer.jsp" />
