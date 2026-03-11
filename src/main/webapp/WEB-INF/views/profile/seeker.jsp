<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden">
        <!-- Header Banner -->
        <div class="relative h-40 bg-gradient-to-r from-teal-500 to-teal-700 flex items-end px-10 pb-0">
            <div class="absolute -bottom-16 left-10 w-32 h-32 rounded-full border-4 border-white shadow-xl bg-teal-50 flex items-center justify-center text-5xl font-bold text-teal-600">
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
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số điện thoại</label>
                    <input type="text" name="phone" id="phone"
                           value="${user.phone}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Chức danh hiện tại</label>
                    <input type="text" name="title" id="title"
                           value="${profile.title}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none"
                           placeholder="Ví dụ: Senior Java Developer">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Số năm kinh nghiệm</label>
                    <input type="number" name="experienceYears"
                           value="${profile.experienceYears}" min="0" max="50"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Địa điểm</label>
                    <select name="locationId" id="locationId"
                            class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 bg-white">
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
                           class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-teal-50 file:text-teal-700 hover:file:bg-teal-100">
                    <c:if test="${not empty profile.cvPath}">
                        <a href="${profile.cvPath}" target="_blank" class="text-xs text-teal-600 mt-1 block hover:underline">Xem CV hiện tại ↗</a>
                    </c:if>
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Kỹ năng (cách nhau bởi dấu phẩy)</label>
                    <input type="text" name="skills" id="skills"
                           value="${profile.skills}"
                           class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none"
                           placeholder="Java, Spring Boot, SQL, ReactJS...">
                </div>
                <div class="col-span-1 md:col-span-2">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Học vấn</label>
                    <textarea name="education" id="education" rows="3"
                              class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500 focus:outline-none"
                              placeholder="Đại học, chuyên ngành, năm tốt nghiệp...">${profile.education}</textarea>
                </div>
            </div>

            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/" class="px-6 py-3 text-gray-600 font-bold hover:text-gray-900 mt-1">Hủy</a>
                <button type="submit" class="bg-teal-600 hover:bg-teal-700 text-white font-bold py-3 px-10 rounded-xl transition shadow-lg">Lưu thay đổi</button>
            </div>
        </form>
    </div>

    <%-- ═══════════════════════════════════════════════ --%>
    <%-- CARD ĐỔI MẬT KHẨU                              --%>
    <%-- ═══════════════════════════════════════════════ --%>
    <div id="change-password" class="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden mt-6">
        <div class="p-8">
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-xl bg-orange-50 flex items-center justify-center flex-shrink-0">
                    <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-gray-900">Đổi mật khẩu</h3>
                    <p class="text-sm text-gray-500">Cập nhật mật khẩu để bảo vệ tài khoản</p>
                </div>
            </div>

            <%-- Thông báo lỗi từ session --%>
            <c:if test="${not empty pwdError}">
                <div class="mb-5 bg-red-50 border-l-4 border-red-500 p-4 text-red-700 text-sm flex items-start gap-3 rounded-lg">
                    <svg class="w-5 h-5 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span>${pwdError}</span>
                </div>
                <c:remove var="pwdError" scope="session"/>
            </c:if>

            <%-- Thông báo thành công --%>
            <c:if test="${param.pwdSuccess == 'true'}">
                <div class="mb-5 bg-green-50 border-l-4 border-green-500 p-4 text-green-700 text-sm flex items-start gap-3 rounded-lg">
                    <svg class="w-5 h-5 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span>Đổi mật khẩu thành công!</span>
                </div>
            </c:if>

            <form id="changePwdForm" action="${pageContext.request.contextPath}/profile/change-password"
                  method="POST" class="grid grid-cols-1 md:grid-cols-3 gap-5">

                <%-- Mật khẩu hiện tại --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mật khẩu hiện tại *</label>
                    <div class="relative">
                        <input type="password" name="currentPassword" id="cp_current" required
                               class="w-full pl-4 pr-10 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-orange-400 focus:outline-none text-sm"
                               placeholder="Nhập mật khẩu hiện tại">
                        <button type="button" onclick="togglePwd('cp_current','cp_eye1')"
                                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600">
                            <svg id="cp_eye1" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <%-- Mật khẩu mới --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Mật khẩu mới *</label>
                    <div class="relative">
                        <input type="password" name="newPassword" id="cp_new" required minlength="6"
                               class="w-full pl-4 pr-10 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-orange-400 focus:outline-none text-sm"
                               placeholder="Tối thiểu 6 ký tự">
                        <button type="button" onclick="togglePwd('cp_new','cp_eye2')"
                                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600">
                            <svg id="cp_eye2" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <%-- Xác nhận mật khẩu --%>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Xác nhận mật khẩu mới *</label>
                    <div class="relative">
                        <input type="password" name="confirmPassword" id="cp_confirm" required minlength="6"
                               class="w-full pl-4 pr-10 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-orange-400 focus:outline-none text-sm"
                               placeholder="Nhập lại mật khẩu mới">
                        <button type="button" onclick="togglePwd('cp_confirm','cp_eye3')"
                                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600">
                            <svg id="cp_eye3" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                        </button>
                    </div>
                    <p id="cp_matchMsg" class="text-xs mt-1 hidden"></p>
                </div>

                <%-- Nút submit --%>
                <div class="md:col-span-3 flex justify-end pt-2 border-t border-gray-100">
                    <button type="submit"
                            class="bg-orange-500 hover:bg-orange-600 text-white font-bold py-3 px-8 rounded-xl transition shadow-md">
                        Đổi mật khẩu
                    </button>
                </div>
            </form>
        </div>
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

// ─── Đổi mật khẩu: show/hide & match check ───────────────────────────
function togglePwd(inputId, iconId) {
    var input = document.getElementById(inputId);
    input.type = input.type === 'password' ? 'text' : 'password';
}

(function () {
    var np = document.getElementById('cp_new');
    var cp = document.getElementById('cp_confirm');
    var msg = document.getElementById('cp_matchMsg');

    function check() {
        if (!cp.value) { msg.className = 'text-xs mt-1 hidden'; return; }
        if (np.value === cp.value) {
            msg.textContent = '✓ Mật khẩu khớp';
            msg.className = 'text-xs mt-1 text-green-600';
        } else {
            msg.textContent = '✗ Mật khẩu không khớp';
            msg.className = 'text-xs mt-1 text-red-600';
        }
    }
    if (np && cp) { np.addEventListener('input', check); cp.addEventListener('input', check); }

    document.getElementById('changePwdForm').addEventListener('submit', function(e) {
        if (np.value !== cp.value) {
            e.preventDefault();
            msg.textContent = '✗ Mật khẩu không khớp';
            msg.className = 'text-xs mt-1 text-red-600';
            cp.focus();
        }
    });
})();
</script>

<c:import url="../layout/footer.jsp" />
