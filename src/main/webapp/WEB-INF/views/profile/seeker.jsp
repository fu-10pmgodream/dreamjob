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

        <form id="seekerForm"
              action="${pageContext.request.contextPath}/profile/seeker/update"
              method="POST" enctype="multipart/form-data"
              class="p-8 pt-24 space-y-8">

            <c:if test="${not empty param.success}">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 text-green-700 rounded-xl">Cập nhật hồ sơ thành công!</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 text-red-700 rounded-xl">${error}</div>
            </c:if>

            <%-- Hidden fields: store original DB values for JS validation --%>
            <input type="hidden" id="orig_fullName"   value="${user.fullName}">
            <input type="hidden" id="orig_phone"      value="${user.phone}">
            <input type="hidden" id="orig_title"      value="${profile.title}">
            <input type="hidden" id="orig_skills"     value="${profile.skills}">
            <input type="hidden" id="orig_education"  value="${profile.education}">
            <input type="hidden" id="orig_locationId" value="${profile.locationId > 0 ? profile.locationId : ''}">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Họ và tên *</label>
                    <input type="text" name="fullName" id="fullName"
                           value="${user.fullName}" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số điện thoại</label>
                    <input type="text" name="phone" id="phone"
                           value="${user.phone}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Chức danh hiện tại</label>
                    <input type="text" name="title" id="title"
                           value="${profile.title}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none"
                           placeholder="Ví dụ: Senior Java Developer">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số năm kinh nghiệm</label>
                    <input type="number" name="experienceYears"
                           value="${profile.experienceYears}" min="0" max="50"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Địa điểm</label>
                    <select name="locationId" id="locationId"
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 bg-white">
                        <option value="">-- Chọn địa điểm --</option>
                        <c:forEach var="loc" items="${locations}">
                            <option value="${loc.locationId}" ${profile.locationId == loc.locationId ? 'selected' : ''}>
                                ${loc.city}, ${loc.country}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Tải lên CV mới (PDF/Ảnh)</label>
                    <input type="file" name="cvFile" accept=".pdf,image/*"
                           class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                    <c:if test="${not empty profile.cvPath}">
                        <a href="${profile.cvPath}" target="_blank" class="text-xs text-indigo-600 mt-1 block hover:underline">Xem CV hiện tại ↗</a>
                    </c:if>
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Kỹ năng (cách nhau bởi dấu phẩy)</label>
                    <input type="text" name="skills" id="skills"
                           value="${profile.skills}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none"
                           placeholder="Java, Spring Boot, SQL, ReactJS...">
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Học vấn</label>
                    <textarea name="education" id="education" rows="3"
                              class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:outline-none"
                              placeholder="Đại học, chuyên ngành, năm tốt nghiệp...">${profile.education}</textarea>
                </div>
            </div>

            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/" class="px-6 py-3 text-gray-600 font-bold hover:text-gray-900 mt-1">Hủy</a>
                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-10 rounded-xl transition shadow-lg">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</main>

<script>
(function () {
    // Map: { fieldId, origId, label, isSelect }
    var fields = [
        { id: 'fullName',  origId: 'orig_fullName',  label: 'Họ và tên' },
        { id: 'phone',     origId: 'orig_phone',     label: 'Số điện thoại' },
        { id: 'title',     origId: 'orig_title',     label: 'Chức danh' },
        { id: 'skills',    origId: 'orig_skills',    label: 'Kỹ năng' },
        { id: 'education', origId: 'orig_education', label: 'Học vấn' },
        { id: 'locationId',origId: 'orig_locationId',label: 'Địa điểm', isSelect: true }
    ];

    document.getElementById('seekerForm').addEventListener('submit', function (e) {
        for (var i = 0; i < fields.length; i++) {
            var f = fields[i];
            var origEl = document.getElementById(f.origId);
            var newEl  = document.getElementById(f.id);
            if (!origEl || !newEl) continue;

            var origVal = origEl.value.trim();
            var newVal  = f.isSelect ? newEl.value : newEl.value.trim();

            if (origVal && !newVal) {
                e.preventDefault();
                alert(f.label + ' đã được điền, không được phép xóa!');
                newEl.focus();
                return;
            }
        }
    });
})();
</script>

<c:import url="../layout/footer.jsp" />
