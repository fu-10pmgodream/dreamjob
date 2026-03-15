<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:import url="../layout/header.jsp" />

<main class="flex-grow">
    <!-- Hero Section -->
    <section class="bg-teal-600 py-20 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-4xl md:text-6xl font-extrabold mb-6 tracking-tight">Tìm Kiếm Công Việc Ước Mơ Của Bạn</h1>
            <p class="text-xl text-teal-100 mb-10 max-w-2xl mx-auto">Hàng ngàn việc làm chất lượng cao từ các công ty hàng đầu đang chờ đón bạn ứng tuyển.</p>

            <form action="${pageContext.request.contextPath}/search" method="GET"
                  class="max-w-4xl mx-auto bg-white p-2 rounded-2xl shadow-2xl flex flex-col md:flex-row gap-2">

                <div class="flex-grow flex items-center px-4 py-3 border-b md:border-b-0 md:border-r border-gray-100">
                    <svg class="w-5 h-5 text-gray-400 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                    </svg>
                    <input type="text" name="keyword" placeholder="Tiêu đề công việc, kỹ năng, công ty..."
                           class="w-full text-gray-800 placeholder-gray-400 focus:outline-none text-sm">
                </div>

                <div class="md:w-64 flex items-center px-4 py-3 border-b md:border-b-0 md:border-r border-gray-100">
                    <svg class="w-5 h-5 text-gray-400 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    </svg>
                    <select name="locationId" class="w-full text-gray-700 focus:outline-none bg-transparent text-sm">
                        <option value="">Tất cả địa điểm</option>
                        <c:forEach items="${locations}" var="loc">
                            <option value="${loc.locationId}">${loc.city}</option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit"
                        class="bg-teal-600 hover:bg-teal-700 text-white font-bold py-3 px-8 rounded-xl transition shadow-lg whitespace-nowrap">
                    Tìm kiếm
                </button>
            </form>

            <!-- Quick Tags -->
            <div class="mt-6 flex flex-wrap justify-center gap-3 text-sm">
                <span class="text-teal-200 font-medium">Tìm nhanh:</span>
                <a href="${pageContext.request.contextPath}/search?keyword=Java" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-1.5 rounded-full transition">Java</a>
                <a href="${pageContext.request.contextPath}/search?keyword=Frontend" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-1.5 rounded-full transition">Frontend</a>
                <a href="${pageContext.request.contextPath}/search?keyword=Marketing" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-1.5 rounded-full transition">Marketing</a>
                <a href="${pageContext.request.contextPath}/search?employmentType=REMOTE" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-1.5 rounded-full transition">Remote</a>
                <a href="${pageContext.request.contextPath}/search?employmentType=INTERNSHIP" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-4 py-1.5 rounded-full transition">Thực tập</a>
            </div>
        </div>
    </section>

    <!-- Featured Jobs Section (Top Rated/Recommended) -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="flex justify-between items-end mb-10">
            <div>
                <h2 class="text-3xl font-bold text-gray-900 mb-2">Việc Làm Hấp Dẫn (Lương Cao)</h2>
                <p class="text-gray-500">Cơ hội thu nhập khủng từ các doanh nghiệp lớn</p>
            </div>
        </div>

        <div class="relative group">
            <!-- Navigation Buttons -->
            <button id="prevHottestBtn" class="absolute z-10 -left-5 top-1/2 -translate-y-1/2 bg-white rounded-full p-3 shadow-lg border border-gray-100 text-teal-600 hover:bg-teal-50 hidden md:flex opacity-0 group-hover:opacity-100 transition-opacity disabled:opacity-30 disabled:cursor-not-allowed">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" class="w-5 h-5"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <button id="nextHottestBtn" class="absolute z-10 -right-5 top-1/2 -translate-y-1/2 bg-white rounded-full p-3 shadow-lg border border-gray-100 text-teal-600 hover:bg-teal-50 hidden md:flex opacity-0 group-hover:opacity-100 transition-opacity disabled:opacity-30 disabled:cursor-not-allowed">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" class="w-5 h-5"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"></path></svg>
            </button>

            <!-- Slider Container -->
            <div id="hottestSlider" class="flex overflow-x-auto gap-6 pb-6 pt-2 snap-x snap-mandatory scroll-smooth hide-scrollbar px-2 -mx-2">
                <c:forEach items="${hottestJobs}" var="job">
                    <div class="snap-start flex-none w-full sm:w-[calc(50%-12px)] lg:w-[calc(25%-18px)]">
                        <a href="${pageContext.request.contextPath}/jobs/${job.jobId}"
                           class="block h-full bg-white border border-gray-100 rounded-2xl p-5 hover:shadow-xl hover:-translate-y-1 hover:border-teal-300 transition-all duration-300 group cursor-pointer">
                            <div class="flex items-center space-x-4 mb-4">
                                <div class="w-12 h-12 bg-white rounded-lg shadow-sm flex items-center justify-center p-1 border border-gray-50 flex-shrink-0">
                                    <img src="${not empty job.logoPath ? job.logoPath : 'https://via.placeholder.com/100'}" alt="logo" class="max-w-full max-h-full object-contain">
                                </div>
                                <div class="overflow-hidden">
                                    <h4 class="font-bold text-gray-900 group-hover:text-teal-600 truncate" title="${job.title}">${job.title}</h4>
                                    <p class="text-xs text-teal-600 font-medium truncate" title="${job.companyName}">${job.companyName}</p>
                                </div>
                            </div>
                            <div class="flex justify-between items-center text-sm pt-4 border-t border-gray-50 mt-auto">
                                <span class="text-green-600 font-bold text-lg"><fmt:formatNumber value="${job.salaryMax / 1000000}" pattern="#.#"/>tr</span>
                                <span class="bg-teal-50 text-teal-700 text-xs px-3 py-1.5 rounded-lg font-semibold group-hover:bg-teal-600 group-hover:text-white transition-colors">Ứng tuyển</span>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <style>
            .hide-scrollbar {
                -ms-overflow-style: none; /* IE and Edge */
                scrollbar-width: none; /* Firefox */
            }
            .hide-scrollbar::-webkit-scrollbar {
                display: none; /* Chrome, Safari and Opera */
            }
        </style>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const slider = document.getElementById('hottestSlider');
                const prevBtn = document.getElementById('prevHottestBtn');
                const nextBtn = document.getElementById('nextHottestBtn');
                
                if(!slider || !prevBtn || !nextBtn) return;

                prevBtn.addEventListener('click', () => {
                    const scrollAmount = slider.clientWidth;
                    // Nếu đang ở đầu, cuộn mượt về vị trí cuối
                    if (slider.scrollLeft <= 10) {
                        const maxScroll = slider.scrollWidth - slider.clientWidth;
                        slider.scrollTo({ left: maxScroll, behavior: 'smooth' });
                    } else {
                        slider.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
                    }
                });

                nextBtn.addEventListener('click', () => {
                    const scrollAmount = slider.clientWidth;
                    const maxScroll = slider.scrollWidth - slider.clientWidth;
                    // Nếu đã cuộn đến cuối, cuộn mượt về đầu
                    if (slider.scrollLeft >= maxScroll - 10) {
                        slider.scrollTo({ left: 0, behavior: 'smooth' });
                    } else {
                        slider.scrollBy({ left: scrollAmount, behavior: 'smooth' });
                    }
                });
            });
        </script>
    </section>

    <!-- Latest Jobs Section -->
    <section class="bg-white py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-end mb-10">
                <div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Việc Làm Mới Nhất</h2>
                    <p class="text-gray-500">Ứng tuyển ngay để trở thành những người đầu tiên</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <c:forEach items="${latestJobs}" var="job">
                    <div class="flex items-center p-5 border border-gray-50 rounded-2xl hover:bg-teal-50 transition cursor-pointer" onclick="location.href='${pageContext.request.contextPath}/jobs/${job.jobId}'">
                        <div class="w-16 h-16 bg-white rounded-xl shadow-sm flex items-center justify-center p-2 mr-6 border border-gray-100">
                             <img src="${not empty job.logoPath ? job.logoPath : 'https://via.placeholder.com/100'}" alt="logo" class="max-w-full max-h-full object-contain">
                        </div>
                        <div class="flex-grow">
                            <h3 class="text-lg font-bold text-gray-900">${job.title}</h3>
                            <div class="flex items-center space-x-4 text-sm text-gray-500 mt-1">
                                <span class="flex items-center"><svg class="w-4 h-4 mr-1 text-teal-500" fill="currentColor" viewBox="0 0 20 20"><path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3zM3.31 9.397L5 10.12v4.102a8.969 8.969 0 00-1.05-.174 1 1 0 01-.89-.89 11.115 11.115 0 01.25-3.762zM9.3 16.573A9.026 9.026 0 007 14.935v-3.957l1.818.78a3 3 0 002.364 0l5.508-2.361a11.026 11.026 0 01.25 3.762 1 1 0 01-.89.89 8.968 8.968 0 00-5.35 2.524 1 1 0 01-1.4 0z"></path></svg>${job.companyName}</span>
                                <span class="flex items-center"><svg class="w-4 h-4 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path></svg>${job.city}</span>
                            </div>
                        </div>
                        <div class="text-right hidden md:block">
                            <p class="text-teal-600 font-bold"><fmt:formatNumber value="${job.salaryMin / 1000000}" pattern="#.#"/> - <fmt:formatNumber value="${job.salaryMax / 1000000}" pattern="#.#"/>tr</p>
                            <span class="text-xs text-gray-400">Đăng <fmt:formatDate value="${job.postedDate}" pattern="dd/MM/yyyy"/></span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<c:import url="../layout/footer.jsp" />
