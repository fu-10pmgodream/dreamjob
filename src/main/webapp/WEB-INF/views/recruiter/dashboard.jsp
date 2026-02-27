<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-gray-900">Quản lý tin tuyển dụng</h1>
            <p class="text-gray-500">Bạn đang có ${myJobs.size()} tin đăng đang hoạt động</p>
        </div>
        <a href="${pageContext.request.contextPath}/jobs/create" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-xl transition shadow-lg flex items-center">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            Đăng tin mới
        </a>
    </div>

    <c:if test="${param.success == 'created'}">
        <div class="mb-6 bg-green-50 border-l-4 border-green-500 p-4 text-green-700">Đã đăng tin tuyển dụng thành công!</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
        <div class="mb-6 bg-blue-50 border-l-4 border-blue-500 p-4 text-blue-700">Đã cập nhật thông tin thành công!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 text-red-700">Đã xóa tin tuyển dụng.</div>
    </c:if>

    <div class="bg-white shadow-xl rounded-2xl overflow-hidden border border-gray-100">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Vị trí tuyển dụng</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Lương</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Ngày đăng</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Trạng thái</th>
                    <th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">Thao tác</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-100">
                <c:forEach items="${myJobs}" var="job">
                    <tr class="hover:bg-gray-50 transition">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-bold text-gray-900">${job.title}</div>
                            <div class="text-xs text-gray-500">${job.categoryName} • ${job.employmentType}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                             <fmt:formatNumber value="${job.salaryMin / 1000000}" pattern="#.#"/> - <fmt:formatNumber value="${job.salaryMax / 1000000}" pattern="#.#"/>tr
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            <fmt:formatDate value="${job.postedDate}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${job.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                ${job.status}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-3">
                            <a href="${pageContext.request.contextPath}/jobs/edit/${job.jobId}" class="text-blue-600 hover:text-blue-900">Sửa</a>
                            <form action="${pageContext.request.contextPath}/jobs/delete" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa tin này?')">
                                <input type="hidden" name="id" value="${job.jobId}">
                                <button type="submit" class="text-red-600 hover:text-red-900">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<c:import url="../layout/footer.jsp" />
