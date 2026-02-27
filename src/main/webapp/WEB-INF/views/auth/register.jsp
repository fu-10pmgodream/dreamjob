<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="flex-grow flex items-center justify-center py-20 px-4 bg-gray-50">
    <div class="max-w-xl w-full bg-white rounded-3xl shadow-xl overflow-hidden border border-gray-100">
        <div class="p-8">
            <div class="text-center mb-10">
                <h2 class="text-3xl font-extrabold text-gray-900 mb-2">Tạo tài khoản mới</h2>
                <p class="text-gray-500">Bắt đầu hành trình sự nghiệp của bạn ngay hôm nay</p>
            </div>

            <c:if test="${not empty error}">
                <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 text-red-700 text-sm flex items-center">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Họ và tên</label>
                        <input type="text" name="fullName" required class="block w-full px-4 py-3 border border-gray-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition sm:text-sm" placeholder="Nguyễn Văn A">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Số điện thoại</label>
                        <input type="text" name="phone" class="block w-full px-4 py-3 border border-gray-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition sm:text-sm" placeholder="0901234567">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Email chuyên môn</label>
                    <input type="email" name="email" required class="block w-full px-4 py-3 border border-gray-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition sm:text-sm" placeholder="van-a@example.com">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Mật khẩu</label>
                    <input type="password" name="password" required class="block w-full px-4 py-3 border border-gray-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition sm:text-sm" placeholder="Tối thiểu 6 ký tự">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2 font-bold text-blue-600">Bạn là?</label>
                    <div class="grid grid-cols-2 gap-4 mt-2">
                        <label class="relative flex p-4 border rounded-xl cursor-pointer hover:bg-blue-50 transition border-gray-200 group">
                            <input type="radio" name="role" value="JOBSEEKER" checked class="mt-1 h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300">
                            <div class="ml-3">
                                <span class="block text-sm font-bold text-gray-900">Ứng viên</span>
                                <span class="block text-xs text-gray-500">Tôi muốn tìm việc</span>
                            </div>
                        </label>
                        <label class="relative flex p-4 border rounded-xl cursor-pointer hover:bg-blue-50 transition border-gray-200 group">
                            <input type="radio" name="role" value="RECRUITER" class="mt-1 h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300">
                            <div class="ml-3">
                                <span class="block text-sm font-bold text-gray-900">Nhà tuyển dụng</span>
                                <span class="block text-xs text-gray-500">Tôi muốn đăng tin</span>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="text-xs text-gray-500">
                    Bằng việc nhấp vào Đăng ký, bạn đồng ý với <a href="#" class="text-blue-600 font-medium">Điều khoản</a> và <a href="#" class="text-blue-600 font-medium">Chính sách</a> của chúng tôi.
                </div>

                <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition">
                    Tạo tài khoản
                </button>
            </form>

            <div class="mt-8 text-center border-t border-gray-100 pt-8">
                <p class="text-sm text-gray-600">
                    Đã có tài khoản? 
                    <a href="${pageContext.request.contextPath}/login" class="font-bold text-blue-600 hover:text-blue-500">Đăng nhập tại đây</a>
                </p>
            </div>
        </div>
    </div>
</main>

<c:import url="../layout/footer.jsp" />
