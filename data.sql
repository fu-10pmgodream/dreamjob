-- =============================================
-- DreamJob Sample Data
-- Run this AFTER schema.sql
-- =============================================

USE DreamJobDB;
GO

-- =============================================
-- Locations
-- =============================================
INSERT INTO Locations (City, Country) VALUES
(N'Hà Nội', N'Vietnam'),
(N'Hồ Chí Minh', N'Vietnam'),
(N'Đà Nẵng', N'Vietnam'),
(N'Cần Thơ', N'Vietnam'),
(N'Hải Phòng', N'Vietnam');

-- =============================================
-- Job Categories
-- =============================================
INSERT INTO JobCategories (CategoryName) VALUES
(N'Công nghệ thông tin'),
(N'Marketing & Truyền thông'),
(N'Tài chính & Kế toán'),
(N'Thiết kế đồ họa'),
(N'Kinh doanh & Bán hàng'),
(N'Nhân sự (HR)'),
(N'Kỹ thuật & Sản xuất'),
(N'Giáo dục & Đào tạo'),
(N'Y tế & Sức khỏe'),
(N'Logistics & Vận tải');

-- =============================================
-- Users (password hash = BCrypt of "Password@123")
-- =============================================
-- Admin users
INSERT INTO Users (Email, PasswordHash, FullName, Role, Phone, IsActive) VALUES
('admin@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Nguyễn Văn Admin', 'ADMIN', '0901234567', 1),
('superadmin@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Trần Thị Super Admin', 'ADMIN', '0901234568', 1);

-- Recruiter users
INSERT INTO Users (Email, PasswordHash, FullName, Role, Phone, IsActive) VALUES
('recruiter.fpt@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Lê Văn Tuyển FPT', 'RECRUITER', '0912345678', 1),
('recruiter.vng@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Phạm Thu Hương VNG', 'RECRUITER', '0912345679', 1),
('recruiter.tiki@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Hoàng Minh Tiki', 'RECRUITER', '0912345680', 1),
('recruiter.grab@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Nguyễn Hải Grab', 'RECRUITER', '0912345681', 1),
('recruiter.momo@dreamjob.vn', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Trần Lan MoMo', 'RECRUITER', '0912345682', 1);

-- JobSeeker users
INSERT INTO Users (Email, PasswordHash, FullName, Role, Phone, IsActive) VALUES
('seeker1@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Nguyễn Minh Khoa', 'JOBSEEKER', '0987654321', 1),
('seeker2@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Trần Thị Bích', 'JOBSEEKER', '0987654322', 1),
('seeker3@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Lê Quang Hưng', 'JOBSEEKER', '0987654323', 1),
('seeker4@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Phạm Thảo Nhi', 'JOBSEEKER', '0987654324', 1),
('seeker5@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Hoàng Đức Anh', 'JOBSEEKER', '0987654325', 1),
('seeker6@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Vũ Thị Lan', 'JOBSEEKER', '0987654326', 1),
('seeker7@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Đinh Văn Mạnh', 'JOBSEEKER', '0987654327', 1),
('seeker8@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Bùi Thị Hoa', 'JOBSEEKER', '0987654328', 1),
('seeker9@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Đỗ Quang Vinh', 'JOBSEEKER', '0987654329', 1),
('seeker10@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3i', N'Ngô Thị Kim', 'JOBSEEKER', '0987654330', 1);

-- =============================================
-- RecruiterProfiles
-- =============================================
INSERT INTO RecruiterProfiles (UserID, CompanyName, CompanyDescription, Website, LogoPath, CompanySize, LocationID) VALUES
(3, N'FPT Software', N'FPT Software là một trong những công ty CNTT hàng đầu Việt Nam, cung cấp dịch vụ phát triển phần mềm, outsourcing và chuyển đổi số cho khách hàng toàn cầu.', 'https://fptsoftware.com', 'https://via.placeholder.com/150/1e40af/ffffff?text=FPT', N'Trên 10,000 nhân viên', 1),
(4, N'VNG Corporation', N'VNG là công ty công nghệ hàng đầu Việt Nam với các sản phẩm nổi tiếng như Zalo, ZaloPay, game online và dịch vụ cloud computing.', 'https://vng.com.vn', 'https://via.placeholder.com/150/7c3aed/ffffff?text=VNG', N'1,000-5,000 nhân viên', 2),
(5, N'Tiki Corporation', N'Tiki là sàn thương mại điện tử lớn nhất Việt Nam, cung cấp dịch vụ mua sắm trực tuyến với hàng triệu sản phẩm.', 'https://tiki.vn', 'https://via.placeholder.com/150/dc2626/ffffff?text=TIKI', N'1,000-5,000 nhân viên', 2),
(6, N'Grab Vietnam', N'Grab là ứng dụng công nghệ đa dịch vụ hàng đầu Đông Nam Á, cung cấp dịch vụ vận chuyển, giao đồ ăn và thanh toán.', 'https://grab.com', 'https://via.placeholder.com/150/16a34a/ffffff?text=GRAB', N'500-1,000 nhân viên', 2),
(7, N'MoMo E-Wallet', N'MoMo là ứng dụng ví điện tử lớn nhất Việt Nam với hơn 31 triệu người dùng, cung cấp giải pháp thanh toán số cho mọi nhu cầu.', 'https://momo.vn', 'https://via.placeholder.com/150/be185d/ffffff?text=MoMo', N'500-1,000 nhân viên', 2);

-- =============================================
-- JobSeekerProfiles
-- =============================================
INSERT INTO JobSeekerProfiles (UserID, Title, Skills, ExperienceYears, Education, CVPath, LocationID) VALUES
(8, N'Backend Developer', N'Java, Spring Boot, SQL Server, Docker, Git', 3, N'Đại học Bách Khoa Hà Nội - Kỹ thuật phần mềm', NULL, 1),
(9, N'Frontend Developer', N'React, Vue.js, JavaScript, CSS, HTML, Figma', 2, N'Đại học FPT - CNTT', NULL, 2),
(10, N'Full-Stack Developer', N'Java, Spring, React, MySQL, Redis', 4, N'Đại học Công nghệ - ĐHQGHN', NULL, 1),
(11, N'UI/UX Designer', N'Figma, Adobe XD, Photoshop, Illustrator, Sketch', 2, N'Đại học Kiến trúc TP.HCM', NULL, 2),
(12, N'Data Analyst', N'Python, SQL, Power BI, Excel, Tableau', 1, N'Đại học Kinh tế TP.HCM', NULL, 2),
(13, N'Marketing Specialist', N'SEO, SEM, Google Ads, Facebook Ads, Content Marketing', 3, N'Đại học Thương mại Hà Nội', NULL, 1),
(14, N'Mobile Developer', N'Android, Kotlin, Flutter, React Native, Firebase', 5, N'Đại học Bách Khoa TP.HCM', NULL, 2),
(15, N'DevOps Engineer', N'Docker, Kubernetes, Jenkins, AWS, Linux', 4, N'Đại học Công nghệ thông tin TP.HCM', NULL, 2),
(16, N'Business Analyst', N'BPMN, UML, Agile, Scrum, SQL', 2, N'Đại học Ngoại thương TP.HCM', NULL, 3),
(17, N'Project Manager', N'PMP, Agile, Scrum, MS Project, JIRA', 6, N'Đại học Kinh tế Đà Nẵng', NULL, 3);

-- =============================================
-- Jobs
-- =============================================
INSERT INTO Jobs (RecruiterID, Title, Description, Requirements, SalaryMin, SalaryMax, LocationID, CategoryID, EmploymentType, PostedDate, ExpiredDate, Status) VALUES
-- FPT Software Jobs
(1, N'Senior Java Developer', N'Chúng tôi tìm kiếm Senior Java Developer có kinh nghiệm để tham gia phát triển các hệ thống lớn cho khách hàng quốc tế. Bạn sẽ làm việc trong môi trường Agile, cộng tác với team đa quốc gia.', N'- 4+ năm kinh nghiệm Java\n- Thành thạo Spring Boot, Microservices\n- Hiểu biết về Docker, Kubernetes\n- Tiếng Anh giao tiếp tốt', 25000000, 45000000, 1, 1, 'FULL_TIME', '2025-12-01', '2026-03-31', 'ACTIVE'),
(1, N'React.js Developer', N'Tham gia xây dựng các ứng dụng web hiện đại với React.js cho các khách hàng công nghệ hàng đầu.', N'- 2+ năm kinh nghiệm React.js\n- Biết TypeScript là lợi thế\n- Kinh nghiệm với Redux/Context API\n- Quen làm việc với REST API', 18000000, 30000000, 1, 1, 'FULL_TIME', '2026-01-01', '2026-04-30', 'ACTIVE'),
(1, N'Business Analyst (Banking Domain)', N'Phân tích nghiệp vụ cho các dự án ngân hàng và tài chính với khách hàng Nhật Bản và Hàn Quốc.', N'- 2+ năm kinh nghiệm BA trong lĩnh vực ngân hàng\n- Biết UML, BPMN\n- Tiếng Nhật N3 hoặc Tiếng Hàn TOPIK 4 là lợi thế\n- Biết SQL', 20000000, 35000000, 1, 2, 'FULL_TIME', '2026-01-15', '2026-04-30', 'ACTIVE'),

-- VNG Jobs
(2, N'Backend Engineer (Zalo Platform)', N'Gia nhập đội ngũ kỹ thuật của Zalo để phát triển hệ thống messaging quy mô lớn phục vụ hàng chục triệu người dùng.', N'- 3+ năm kinh nghiệm backend (Go/Java/C++)\n- Hiểu sâu về distributed systems\n- Kinh nghiệm với Kafka, Redis\n- Passion với high-performance systems', 30000000, 60000000, 2, 1, 'FULL_TIME', '2025-11-01', '2026-03-31', 'ACTIVE'),
(2, N'Data Engineer', N'Xây dựng và vận hành data pipeline phục vụ phân tích dữ liệu cho hệ sinh thái VNG.', N'- 2+ năm kinh nghiệm Data Engineering\n- Thành thạo Python, Spark, Hadoop\n- Kinh nghiệm với data warehouse\n- Biết SQL nâng cao', 25000000, 45000000, 2, 1, 'FULL_TIME', '2026-01-20', '2026-04-30', 'ACTIVE'),
(2, N'UI/UX Designer (Mobile)', N'Thiết kế trải nghiệm người dùng cho ứng dụng Zalo và các sản phẩm VNG với hàng triệu người dùng hàng ngày.', N'- 3+ năm kinh nghiệm UI/UX\n- Portfolio phong phú với mobile app design\n- Thành thạo Figma\n- Hiểu biết về user research', 20000000, 38000000, 2, 4, 'FULL_TIME', '2026-01-10', '2026-04-15', 'ACTIVE'),

-- Tiki Jobs
(3, N'Product Manager - E-commerce', N'Dẫn dắt sản phẩm thương mại điện tử của Tiki từ ý tưởng đến triển khai, làm việc với team kỹ thuật và kinh doanh.', N'- 3+ năm kinh nghiệm PM trong E-commerce\n- Kỹ năng phân tích dữ liệu tốt\n- Tư duy product strong\n- Giao tiếp tiếng Anh tốt', 35000000, 60000000, 2, 5, 'FULL_TIME', '2025-12-15', '2026-03-31', 'ACTIVE'),
(3, N'Growth Marketing Manager', N'Dẫn dắt chiến lược tăng trưởng người dùng và doanh thu cho sàn Tiki thông qua các kênh digital marketing.', N'- 4+ năm kinh nghiệm Growth/Performance Marketing\n- Thành thạo Google Ads, Facebook Ads\n- Kỹ năng phân tích số liệu\n- Kinh nghiệm A/B testing', 28000000, 50000000, 2, 2, 'FULL_TIME', '2026-01-05', '2026-04-15', 'ACTIVE'),
(3, N'Java Developer (Internship)', N'Chương trình thực tập Summer 2026 tại Tiki - Cơ hội làm việc với hệ thống e-commerce lớn nhất Việt Nam.', N'- Sinh viên năm 3-4 ngành CNTT\n- Biết Java cơ bản\n- Hiểu OOP\n- Có thể làm việc 5 ngày/tuần', 5000000, 8000000, 2, 1, 'INTERNSHIP', '2026-02-01', '2026-03-31', 'ACTIVE'),

-- Grab Jobs
(4, N'Android Developer', N'Phát triển tính năng mới cho ứng dụng Grab trên nền tảng Android, phục vụ hàng triệu người dùng tại Đông Nam Á.', N'- 3+ năm kinh nghiệm Android\n- Thành thạo Kotlin\n- Kinh nghiệm với MVVM, Clean Architecture\n- Hiểu biết về CI/CD', 28000000, 50000000, 2, 1, 'FULL_TIME', '2025-12-01', '2026-03-31', 'ACTIVE'),
(4, N'Operations Manager (Driver Operations)', N'Quản lý vận hành đội lái xe và đảm bảo chất lượng dịch vụ cho Grab tại thị trường Việt Nam.', N'- 3+ năm kinh nghiệm Operations Management\n- Kỹ năng lãnh đạo tốt\n- Biết phân tích dữ liệu\n- Kinh nghiệm trong lĩnh vực logistics/transportation', 22000000, 40000000, 2, 10, 'FULL_TIME', '2026-01-15', '2026-04-30', 'ACTIVE'),
(4, N'Financial Analyst', N'Phân tích tài chính và hỗ trợ quyết định kinh doanh cho Grab Vietnam.', N'- 2+ năm kinh nghiệm tài chính\n- Thành thạo Excel, Power BI\n- Biết SQL\n- Tốt nghiệp Đại học chuyên ngành Tài chính', 20000000, 38000000, 2, 3, 'FULL_TIME', '2026-01-20', '2026-04-30', 'ACTIVE'),

-- MoMo Jobs
(5, N'iOS Developer', N'Phát triển ứng dụng MoMo trên iOS, mang lại trải nghiệm thanh toán tốt nhất cho người dùng Việt Nam.', N'- 3+ năm kinh nghiệm iOS\n- Thành thạo Swift\n- Hiểu về payment systems là lợi thế\n- Kinh nghiệm với Xcode, TestFlight', 28000000, 52000000, 2, 1, 'FULL_TIME', '2025-11-15', '2026-03-31', 'ACTIVE'),
(5, N'HR Business Partner', N'Đối tác chiến lược với các phòng ban kinh doanh để xây dựng văn hóa và phát triển nhân tài tại MoMo.', N'- 3+ năm kinh nghiệm HRBP\n- Hiểu biết về labor law Việt Nam\n- Kỹ năng giao tiếp và thuyết phục tốt\n- Bằng Đại học ngành HR/luật/kinh tế', 20000000, 35000000, 2, 6, 'FULL_TIME', '2026-01-10', '2026-04-15', 'ACTIVE'),
(5, N'Content Creator & Social Media', N'Sáng tạo nội dung hấp dẫn cho MoMo trên các kênh mạng xã hội, xây dựng thương hiệu trẻ và năng động.', N'- 1+ năm kinh nghiệm Content Creator\n- Kỹ năng viết lách tốt\n- Biết cơ bản Photoshop/Canva\n- Hiểu về social media analytics', 12000000, 22000000, 2, 2, 'FULL_TIME', '2026-02-01', '2026-05-01', 'ACTIVE'),
(5, N'Senior DevOps Engineer', N'Xây dựng và vận hành hạ tầng cloud cho hệ thống thanh toán MoMo xử lý hàng triệu giao dịch mỗi ngày.', N'- 4+ năm kinh nghiệm DevOps/SRE\n- Thành thạo Kubernetes, Terraform\n- Kinh nghiệm với AWS hoặc GCP\n- Hiểu về payment security', 35000000, 65000000, 2, 1, 'FULL_TIME', '2025-12-20', '2026-03-31', 'ACTIVE'),
(5, N'Kế toán viên', N'Thực hiện các nghiệp vụ kế toán tài chính tại MoMo, đảm bảo tuân thủ quy định pháp luật về tài chính.', N'- Tốt nghiệp Đại học ngành Kế toán/Tài chính\n- Biết phần mềm kế toán MISA/SAP\n- Có chứng chỉ CPA là lợi thế\n- Cẩn thận, trung thực', 12000000, 20000000, 2, 3, 'FULL_TIME', '2026-02-10', '2026-05-10', 'ACTIVE'),
-- Additional jobs for variety
(1, N'Python Developer (AI/ML)', N'Phát triển các giải pháp AI/ML tích hợp vào sản phẩm phần mềm của FPT cho thị trường quốc tế.', N'- 2+ năm Python\n- Kinh nghiệm với TensorFlow/PyTorch\n- Biết MLOps\n- Tiếng Anh đọc hiểu tài liệu kỹ thuật', 22000000, 42000000, 1, 1, 'FULL_TIME', '2026-02-15', '2026-05-15', 'ACTIVE'),
(2, N'Game Developer (Unity)', N'Phát triển game mobile và PC trên nền tảng Unity cho cổng game của VNG.', N'- 2+ năm kinh nghiệm Unity C#\n- Hiểu biết về game design\n- Kinh nghiệm tối ưu hiệu năng game mobile\n- Portfolio game cá nhân', 20000000, 38000000, 2, 1, 'FULL_TIME', '2026-01-25', '2026-04-25', 'ACTIVE'),
(3, N'Warehouse Manager', N'Quản lý hoạt động kho hàng tại trung tâm fulfillment của Tiki, đảm bảo quy trình xử lý đơn hàng hiệu quả.', N'- 3+ năm kinh nghiệm quản lý kho\n- Hiểu biết về WMS\n- Kỹ năng lãnh đạo đội nhóm\n- Chịu được áp lực cao điểm', 18000000, 32000000, 2, 10, 'FULL_TIME', '2026-02-01', '2026-05-01', 'ACTIVE'),
(4, N'Customer Experience Specialist', N'Hỗ trợ và cải thiện trải nghiệm của đối tác tài xế Grab tại Đà Nẵng.', N'- 1+ năm kinh nghiệm customer service\n- Kiên nhẫn, thấu hiểu khách hàng\n- Biết tiếng Anh cơ bản\n- Quen thuộc với Excel', 10000000, 18000000, 3, 5, 'FULL_TIME', '2026-02-10', '2026-05-10', 'ACTIVE');

-- =============================================
-- Applications
-- =============================================
INSERT INTO Applications (JobID, JobSeekerID, AppliedDate, Status, CoverLetter, CVPath) VALUES
(1, 1, '2026-01-05', 'REVIEWING', N'Kính gửi nhà tuyển dụng, tôi có 3 năm kinh nghiệm Java Spring Boot và rất muốn gia nhập team FPT Software.', NULL),
(2, 2, '2026-01-10', 'PENDING', N'Tôi có 2 năm kinh nghiệm React và TypeScript, rất phù hợp với vị trí này.', NULL),
(4, 3, '2025-11-15', 'ACCEPTED', N'Với kinh nghiệm 4 năm backend Java và distributed systems, tôi tự tin có thể đóng góp cho Zalo Platform.', NULL),
(5, 5, '2026-01-25', 'PENDING', N'Tôi có kinh nghiệm Python và data pipeline, mong muốn làm việc tại VNG.', NULL),
(6, 4, '2026-01-12', 'REVIEWING', N'Tôi có 2 năm kinh nghiệm thiết kế UI/UX mobile app và portfolio đa dạng.', NULL),
(9, 1, '2026-02-05', 'PENDING', N'Tôi quan tâm đến vị trí thực tập tại Tiki để phát triển kỹ năng Java thực tế.', NULL),
(10, 7, '2025-12-05', 'REJECTED', N'Tôi có 5 năm kinh nghiệm Android Kotlin, xin ứng tuyển vị trí Android Developer tại Grab.', NULL),
(13, 3, '2025-11-20', 'ACCEPTED', N'Tôi có kinh nghiệm iOS Swift và đam mê với fintech, rất muốn gia nhập MoMo.', NULL),
(15, 6, '2026-01-12', 'REVIEWING', N'Với kinh nghiệm marketing và content creation, tôi muốn đóng góp cho thương hiệu MoMo.', NULL),
(16, 8, '2026-01-01', 'REVIEWING', N'Tôi có 4 năm DevOps/SRE với Kubernetes và Terraform, rất phù hợp cho hệ thống MoMo.', NULL),
(7, 6, '2025-12-20', 'PENDING', N'Với nền tảng marketing số mạnh, tôi muốn ứng tuyển PM E-commerce tại Tiki.', NULL),
(8, 6, '2026-01-08', 'ACCEPTED', N'Tôi có kinh nghiệm Growth Marketing và data-driven approach.', NULL),
(11, 5, '2026-01-22', 'PENDING', N'Tôi muốn ứng tuyển vào vị trí Financial Analyst tại Grab.', NULL),
(14, 6, '2026-01-14', 'REVIEWING', N'Tôi có kinh nghiệm HRBP trong lĩnh vực fintech, muốn gia nhập MoMo.', NULL),
(3, 9, '2026-01-20', 'PENDING', N'Tôi có kinh nghiệm BA trong lĩnh vực ngân hàng và đang học tiếng Nhật.', NULL);

-- =============================================
-- SavedJobs
-- =============================================
INSERT INTO SavedJobs (JobID, JobSeekerID, SavedDate) VALUES
(1, 1, '2026-01-03'),
(2, 2, '2026-01-08'),
(4, 3, '2025-11-10'),
(6, 4, '2026-01-10'),
(7, 5, '2025-12-18'),
(10, 7, '2025-12-01'),
(13, 3, '2025-11-18'),
(15, 6, '2026-01-10'),
(16, 8, '2025-12-28'),
(5, 5, '2026-01-23'),
(8, 6, '2026-01-06'),
(12, 5, '2026-01-20'),
(14, 6, '2026-01-12'),
(17, 2, '2026-02-12'),
(20, 1, '2026-02-14');

-- =============================================
-- CompanyImages
-- =============================================
INSERT INTO CompanyImages (RecruiterID, ImagePath) VALUES
(1, 'https://via.placeholder.com/800x400/1e40af/ffffff?text=FPT+Office+Hanoi'),
(1, 'https://via.placeholder.com/800x400/1e40af/ffffff?text=FPT+Campus'),
(2, 'https://via.placeholder.com/800x400/7c3aed/ffffff?text=VNG+Campus+HCM'),
(3, 'https://via.placeholder.com/800x400/dc2626/ffffff?text=Tiki+Fulfillment'),
(4, 'https://via.placeholder.com/800x400/16a34a/ffffff?text=Grab+Office'),
(5, 'https://via.placeholder.com/800x400/be185d/ffffff?text=MoMo+HQ');

GO
PRINT 'Sample data inserted successfully!';
PRINT 'All passwords = Password@123';
PRINT 'Admin: admin@dreamjob.vn / Password@123';
PRINT 'Recruiter: recruiter.fpt@dreamjob.vn / Password@123';
PRINT 'JobSeeker: seeker1@gmail.com / Password@123';
