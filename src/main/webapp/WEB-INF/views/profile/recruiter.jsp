<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden">
        <!-- Header -->
        <div class="relative h-48 bg-gradient-to-r from-blue-600 to-indigo-700">
            <div class="absolute -bottom-16 left-10">
                <div class="w-32 h-32 rounded-2xl border-4 border-white shadow-xl bg-white flex items-center justify-center overflow-hidden">
                    <c:choose>
                        <c:when test="${not empty profile.logoPath}">
                            <img src="${profile.logoPath}" alt="logo" class="max-w-full max-h-full object-contain">
                        </c:when>
                        <c:otherwise>
                            <svg class="w-16 h-16 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Form -->
        <form id="recruiterForm"
              action="${pageContext.request.contextPath}/profile/recruiter/update"
              method="POST" enctype="multipart/form-data"
              class="p-8 pt-24 space-y-8">

            <c:if test="${not empty param.success}">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 text-green-700 rounded-xl">Cập nhật hồ sơ thành công!</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 text-red-700 rounded-xl">${error}</div>
            </c:if>

            <%-- Hidden fields: store original DB values for JS validation --%>
            <input type="hidden" id="orig_companyName"        value="${profile.companyName}">
            <input type="hidden" id="orig_website"            value="${profile.website}">
            <input type="hidden" id="orig_companySize"        value="${profile.companySize}">
            <input type="hidden" id="orig_locationId"         value="${profile.locationId > 0 ? profile.locationId : ''}">
            <input type="hidden" id="orig_fullName"           value="${user.fullName}">
            <input type="hidden" id="orig_phone"              value="${user.phone}">
            <input type="hidden" id="orig_companyDescription" value="${profile.companyDescription}">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Tên công ty *</label>
                    <input type="text" name="companyName" id="companyName"
                           value="${profile.companyName}" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Website</label>
                    <input type="url" name="website" id="website"
                           value="${profile.website}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:outline-none"
                           placeholder="https://...">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Quy mô công ty</label>
                    <select name="companySize" id="companySize"
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 bg-white">
                        <option value="">-- Chọn quy mô --</option>
                        <option value="1-10"     ${profile.companySize == '1-10'     ? 'selected' : ''}>1-10 nhân viên</option>
                        <option value="11-50"    ${profile.companySize == '11-50'    ? 'selected' : ''}>11-50 nhân viên</option>
                        <option value="51-200"   ${profile.companySize == '51-200'   ? 'selected' : ''}>51-200 nhân viên</option>
                        <option value="201-500"  ${profile.companySize == '201-500'  ? 'selected' : ''}>201-500 nhân viên</option>
                        <option value="501-1000" ${profile.companySize == '501-1000' ? 'selected' : ''}>501-1000 nhân viên</option>
                        <option value="1000+"    ${profile.companySize == '1000+'    ? 'selected' : ''}>Trên 1000 nhân viên</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Địa điểm</label>
                    <select name="locationId" id="locationId"
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 bg-white">
                        <option value="">-- Chọn địa điểm --</option>
                        <c:forEach var="loc" items="${locations}">
                            <option value="${loc.locationId}" ${profile.locationId == loc.locationId ? 'selected' : ''}>
                                ${loc.city}, ${loc.country}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Họ và tên liên lạc *</label>
                    <input type="text" name="fullName" id="fullName"
                           value="${user.fullName}" required
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số điện thoại</label>
                    <input type="text" name="phone" id="phone"
                           value="${user.phone}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả công ty</label>
                    <textarea name="companyDescription" id="companyDescription" rows="4"
                              class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500">${profile.companyDescription}</textarea>
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Logo công ty (JPG, PNG)</label>
                    <input type="file" name="logoFile" accept="image/*"
                           class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                    <p class="text-xs text-gray-400 mt-1">Để trống nếu không muốn thay đổi logo hiện tại</p>
                </div>
            </div>

            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/" class="px-6 py-3 text-gray-600 font-bold hover:text-gray-900 mt-1">Hủy</a>
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-10 rounded-xl transition shadow-lg">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</main>

<script>
(function () {
    // Map: { fieldId, origId, label, isSelect }
    var fields = [
        { id: 'companyName',        origId: 'orig_companyName',        label: 'Tên công ty' },
        { id: 'fullName',           origId: 'orig_fullName',           label: 'Họ và tên' },
        { id: 'phone',              origId: 'orig_phone',              label: 'Số điện thoại' },
        { id: 'website',            origId: 'orig_website',            label: 'Website' },
        { id: 'companyDescription', origId: 'orig_companyDescription', label: 'Mô tả công ty' },
        { id: 'companySize',        origId: 'orig_companySize',        label: 'Quy mô công ty',  isSelect: true },
        { id: 'locationId',         origId: 'orig_locationId',         label: 'Địa điểm',        isSelect: true }
    ];

    document.getElementById('recruiterForm').addEventListener('submit', function (e) {
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
