<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="flex-grow">
    <!-- Hero Section -->
    <section class="bg-blue-600 py-20 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-4xl md:text-6xl font-extrabold mb-6 tracking-tight">Tìm Kiếm Công Việc Ước Mơ Của Bạn</h1>
            <p class="text-xl text-blue-100 mb-10 max-w-2xl mx-auto">Hàng ngàn việc làm chất lượng cao từ các công ty hàng đầu đang chờ đón bạn ứng tuyển.</p>
            
            <div class="max-w-4xl mx-auto bg-white p-2 rounded-2xl shadow-2xl flex flex-col md:flex-row gap-2">
                <div class="flex-grow flex items-center px-4 py-3 border-b md:border-b-0 md:border-r border-gray-100">
                    <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                    </svg>
                    <input type="text" placeholder="Tiêu đề công việc, kỹ năng..." class="w-full text-gray-800 placeholder-gray-400 focus:outline-none">
                </div>
                <div class="md:w-1/3 flex items-center px-4 py-3 border-b md:border-b-0 md:border-r border-gray-100">
                    <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    </svg>
                    <select class="w-full text-gray-800 focus:outline-none bg-transparent">
                        <option value="">Tất cả địa điểm</option>
                        <option>Hà Nội</option>
                        <option>TP. Hồ Chí Minh</option>
                        <option>Đà Nẵng</option>
                    </select>
                </div>
                <button class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-xl transition shadow-lg">Tìm kiếm</button>
            </div>
        </div>
    </section>

    <!-- Featured Jobs Section -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="flex justify-between items-end mb-10">
            <div>
                <h2 class="text-3xl font-bold text-gray-900 mb-2">Việc Làm Nổi Bật</h2>
                <p class="text-gray-500">Những cơ hội nghề nghiệp tốt nhất vừa được đăng tuyển</p>
            </div>
            <a href="#" class="text-blue-600 font-semibold hover:underline flex items-center">
                Xem tất cả 
                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <c:forEach items="${featuredJobs}" var="job">
                <div class="bg-white border border-gray-100 rounded-2xl p-6 hover:shadow-xl transition-shadow duration-300 group">
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-14 h-14 bg-gray-50 rounded-xl overflow-hidden flex items-center justify-center p-2 border border-gray-100">
                            <c:choose>
                                <c:when test="${not empty job.logoPath}">
                                    <img src="${job.logoPath}" alt="${job.companyName}" class="max-w-full max-h-full object-contain">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-xl font-bold text-blue-400">${job.companyName.substring(0, 1)}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <span class="bg-blue-50 text-blue-600 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider">
                            ${job.employmentType == 'FULL_TIME' ? 'Toàn thời gian' : job.employmentType}
                        </span>
                    </div>
                    
                    <h3 class="text-lg font-bold text-gray-900 mb-1 group-hover:text-blue-600 transition">
                        <a href="#">${job.title}</a>
                    </h3>
                    <p class="text-blue-600 font-semibold text-sm mb-4">${job.companyName}</p>
                    
                    <div class="flex flex-wrap gap-2 mb-6">
                        <div class="flex items-center text-gray-500 text-sm bg-gray-50 px-3 py-1 rounded-lg">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                            </svg>
                            ${job.city}
                        </div>
                        <div class="flex items-center text-green-600 text-sm bg-green-50 px-3 py-1 rounded-lg font-medium">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <fmt:formatNumber value="${job.salaryMin / 1000000}" pattern="#.#"/>tr - 
                            <fmt:formatNumber value="${job.salaryMax / 1000000}" pattern="#.#"/>tr
                        </div>
                    </div>
                    
                    <div class="flex items-center justify-between pt-4 border-t border-gray-50">
                        <span class="text-xs text-gray-400">
                            Đăng <fmt:formatDate value="${job.postedDate}" pattern="dd/MM/yyyy"/>
                        </span>
                        <a href="#" class="text-sm font-bold text-gray-700 hover:text-blue-600 transition">Chi tiết &rarr;</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<c:import url="../layout/footer.jsp" />
