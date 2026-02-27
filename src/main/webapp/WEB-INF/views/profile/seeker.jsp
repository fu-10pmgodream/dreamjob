<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden">
        <!-- Header Banner -->
        <div class="relative h-40 bg-gradient-to-r from-indigo-600 to-purple-700 flex items-end px-10 pb-0">
            <div class="absolute -bottom-16 left-10 w-32 h-32 rounded-full border-4 border-white shadow-xl bg-indigo-100 flex items-center justify-center text-5xl font-bold text-indigo-600">
                ${user.fullName.substring(0,1)}
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/profile/seeker/update" method="POST" enctype="multipart/form-data" class="p-8 pt-24 space-y-8">
            <c:if test="${not empty param.success}">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 text-green-700 rounded-xl">Cập nhật hồ sơ thành công!</div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Họ và tên</label>
                    <input type="text" name="fullName" value="${user.fullName}" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số điện thoại</label>
                    <input type="text" name="phone" value="${user.phone}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Chức danh hiện tại</label>
                    <input type="text" name="title" value="${profile.title}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none" placeholder="Ví dụ: Senior Java Developer">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số năm kinh nghiệm</label>
                    <input type="number" name="experienceYears" value="${profile.experienceYears}" min="0" max="50" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mã địa điểm (LocationID)</label>
                    <input type="number" name="locationId" value="${profile.locationId > 0 ? profile.locationId : ''}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Tải lên CV mới (PDF/Ảnh)</label>
                    <input type="file" name="cvFile" accept=".pdf,image/*" class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                    <c:if test="${not empty profile.cvPath}">
                        <a href="${profile.cvPath}" target="_blank" class="text-xs text-indigo-600 mt-1 block hover:underline">Xem CV hiện tại ↗</a>
                    </c:if>
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Kỹ năng (cách nhau bởi dấu phẩy)</label>
                    <input type="text" name="skills" value="${profile.skills}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none" placeholder="Java, Spring Boot, SQL, ReactJS...">
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Học vấn</label>
                    <textarea name="education" rows="3" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none" placeholder="Đại học, chuyên ngành, năm tốt nghiệp...">${profile.education}</textarea>
                </div>
            </div>

            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/" class="px-6 py-3 text-gray-600 font-bold hover:text-gray-900 mt-1">Hủy</a>
                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-10 rounded-xl transition shadow-lg">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</main>

<c:import url="../layout/footer.jsp" />
