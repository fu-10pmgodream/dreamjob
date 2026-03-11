package com.dreamjob.controller;

import com.dreamjob.dal.ProfileDAO;
import com.dreamjob.dal.SearchDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.JobSeekerProfile;
import com.dreamjob.model.RecruiterProfile;
import com.dreamjob.model.User;
import com.dreamjob.service.FileStorageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private ProfileDAO profileDAO;
    @Autowired
    private UserDAO userDAO;
    @Autowired
    private FileStorageService fileStorageService;
    @Autowired
    private SearchDAO searchDAO;

    // ─── Helper: trim safely ───────────────────────────────────────────────
    private static String trim(String s) {
        return s != null ? s.trim() : "";
    }

    /**
     * Returns error message if an already-filled field is being cleared, else null.
     */
    private static String notEmptyIfFilled(String existingValue, String newValue, String fieldLabel) {
        boolean hadValue = existingValue != null && !existingValue.trim().isEmpty();
        if (hadValue && newValue.trim().isEmpty()) {
            return fieldLabel + " đã được điền, không được phép xóa!";
        }
        return null;
    }

    // ─── GET /profile ───────────────────────────────────────────────────────
    @GetMapping
    public String viewProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        model.addAttribute("locations", searchDAO.getAllLocations());

        if ("RECRUITER".equals(user.getRole())) {
            RecruiterProfile profile = profileDAO.getRecruiterProfileByUserId(user.getUserId());
            model.addAttribute("profile", profile != null ? profile : new RecruiterProfile());
            return "profile/recruiter";
        } else if ("JOBSEEKER".equals(user.getRole())) {
            JobSeekerProfile profile = profileDAO.getSeekerProfileByUserId(user.getUserId());
            model.addAttribute("profile", profile != null ? profile : new JobSeekerProfile());
            return "profile/seeker";
        }
        return "redirect:/";
    }

    // ─── POST /profile/recruiter/update ────────────────────────────────────
    @PostMapping("/recruiter/update")
    public String updateRecruiterProfile(
            @RequestParam String companyName,
            @RequestParam(required = false) String companyDescription,
            @RequestParam(required = false) String website,
            @RequestParam(required = false) String companySize,
            @RequestParam(required = false) String locationId,
            @RequestParam String fullName,
            @RequestParam(required = false) String phone,
            @RequestParam("logoFile") MultipartFile logoFile,
            HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole()))
            return "redirect:/login";

        // Load existing profile from DB (source of truth for "had value" checks)
        RecruiterProfile profile = profileDAO.getRecruiterProfileByUserId(user.getUserId());
        if (profile == null) {
            profile = new RecruiterProfile();
            profile.setUserId(user.getUserId());
        }

        // ── Validate: trim + "cannot clear if already filled" ──────────────
        String[] checks = {
                notEmptyIfFilled(profile.getCompanyName(), trim(companyName), "Tên công ty"),
                notEmptyIfFilled(user.getFullName(), trim(fullName), "Họ và tên"),
                notEmptyIfFilled(user.getPhone(), trim(phone), "Số điện thoại"),
                notEmptyIfFilled(profile.getWebsite(), trim(website), "Website"),
                notEmptyIfFilled(profile.getCompanySize(), companySize, "Quy mô công ty"),
                notEmptyIfFilled(profile.getCompanyDescription(), trim(companyDescription), "Mô tả công ty"),
        };
        // LocationId: "had value" when > 0; "new value" is empty when blank/not
        // selected
        if (profile.getLocationId() > 0 && (locationId == null || locationId.isBlank())) {
            checks = appendError(checks, "Địa điểm đã được chọn, không được phép xóa!");
        }

        for (String err : checks) {
            if (err != null) {
                model.addAttribute("error", err);
                model.addAttribute("profile", profile);
                model.addAttribute("locations", searchDAO.getAllLocations());
                return "profile/recruiter";
            }
        }

        // ── Apply values ────────────────────────────────────────────────────
        profile.setCompanyName(trim(companyName));
        profile.setCompanyDescription(trim(companyDescription).isEmpty() ? null : trim(companyDescription));
        profile.setWebsite(trim(website).isEmpty() ? null : trim(website));
        profile.setCompanySize((companySize != null && !companySize.isBlank()) ? companySize : null);
        if (locationId != null && !locationId.isBlank()) {
            profile.setLocationId(Integer.parseInt(locationId));
        }

        if (logoFile != null && !logoFile.isEmpty()) {
            profile.setLogoPath(fileStorageService.uploadFile(logoFile, "logos"));
        } else {
            profile.setLogoPath(null); // signal: don't update logo
        }

        if (profileDAO.upsertRecruiterProfile(profile, trim(fullName), trim(phone).isEmpty() ? null : trim(phone))) {
            User updated = userDAO.findByEmail(user.getEmail());
            session.setAttribute("user", updated);
            
            RecruiterProfile updatedProfile = profileDAO.getRecruiterProfileByUserId(user.getUserId());
            if (updatedProfile != null && updatedProfile.getLogoPath() != null && !updatedProfile.getLogoPath().isEmpty()) {
                session.setAttribute("userAvatar", updatedProfile.getLogoPath());
            } else {
                session.removeAttribute("userAvatar");
            }
            
            return "redirect:/profile?success=true";
        }
        model.addAttribute("error", "Cập nhật thất bại!");
        model.addAttribute("profile", profile);
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "profile/recruiter";
    }

    // ─── POST /profile/seeker/update ───────────────────────────────────────
    @PostMapping("/seeker/update")
    public String updateSeekerProfile(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String skills,
            @RequestParam(defaultValue = "0") int experienceYears,
            @RequestParam(required = false) String education,
            @RequestParam(required = false) String locationId,
            @RequestParam String fullName,
            @RequestParam(required = false) String phone,
            @RequestParam("cvFile") MultipartFile cvFile,
            HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null || !"JOBSEEKER".equals(user.getRole()))
            return "redirect:/login";

        // Load existing profile from DB
        JobSeekerProfile profile = profileDAO.getSeekerProfileByUserId(user.getUserId());
        if (profile == null) {
            profile = new JobSeekerProfile();
            profile.setUserId(user.getUserId());
        }

        // ── Validate: trim + "cannot clear if already filled" ──────────────
        String[] checks = {
                notEmptyIfFilled(user.getFullName(), trim(fullName), "Họ và tên"),
                notEmptyIfFilled(user.getPhone(), trim(phone), "Số điện thoại"),
                notEmptyIfFilled(profile.getTitle(), trim(title), "Chức danh"),
                notEmptyIfFilled(profile.getSkills(), trim(skills), "Kỹ năng"),
                notEmptyIfFilled(profile.getEducation(), trim(education), "Học vấn"),
        };
        if (profile.getLocationId() > 0 && (locationId == null || locationId.isBlank())) {
            checks = appendError(checks, "Địa điểm đã được chọn, không được phép xóa!");
        }

        for (String err : checks) {
            if (err != null) {
                model.addAttribute("error", err);
                model.addAttribute("profile", profile);
                model.addAttribute("locations", searchDAO.getAllLocations());
                return "profile/seeker";
            }
        }

        // ── Apply values ────────────────────────────────────────────────────
        profile.setTitle(trim(title).isEmpty() ? null : trim(title));
        profile.setSkills(trim(skills).isEmpty() ? null : trim(skills));
        profile.setExperienceYears(experienceYears);
        profile.setEducation(trim(education).isEmpty() ? null : trim(education));
        if (locationId != null && !locationId.isBlank()) {
            profile.setLocationId(Integer.parseInt(locationId));
        }

        if (cvFile != null && !cvFile.isEmpty()) {
            profile.setCvPath(fileStorageService.uploadFile(cvFile, "cvs"));
        } else {
            profile.setCvPath(null);
        }

        if (profileDAO.upsertSeekerProfile(profile, trim(fullName), trim(phone).isEmpty() ? null : trim(phone))) {
            User updated = userDAO.findByEmail(user.getEmail());
            session.setAttribute("user", updated);
            return "redirect:/profile?success=true";
        }
        model.addAttribute("error", "Cập nhật thất bại!");
        model.addAttribute("profile", profile);
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "profile/seeker";
    }

    // ─── POST /profile/change-password ─────────────────────────────────────
    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        // ── Validation ──────────────────────────────────────────────────────

        // Mật khẩu cũ không được rỗng
        if (currentPassword == null || currentPassword.isBlank()) {
            return redirectWithPwdError(session, "Vui lòng nhập mật khẩu hiện tại!");
        }

        // Kiểm tra mật khẩu cũ có đúng không
        if (!userDAO.verifyPassword(user.getUserId(), currentPassword)) {
            return redirectWithPwdError(session, "Mật khẩu hiện tại không chính xác!");
        }

        // Mật khẩu mới tối thiểu 6 ký tự
        if (newPassword == null || newPassword.length() < 6) {
            return redirectWithPwdError(session, "Mật khẩu mới phải có ít nhất 6 ký tự!");
        }

        // Không được trùng với mật khẩu cũ
        if (currentPassword.equals(newPassword)) {
            return redirectWithPwdError(session, "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
        }

        // Xác nhận mật khẩu phải khớp
        if (!newPassword.equals(confirmPassword)) {
            return redirectWithPwdError(session, "Mật khẩu xác nhận không khớp!");
        }

        // ── Cập nhật ────────────────────────────────────────────────────────
        if (userDAO.updatePassword(user.getUserId(), newPassword)) {
            return "redirect:/profile?pwdSuccess=true";
        }

        return redirectWithPwdError(session, "Đã có lỗi xảy ra. Vui lòng thử lại!");
    }

    /** Lưu lỗi đổi mật khẩu vào session rồi redirect về trang profile */
    private String redirectWithPwdError(HttpSession session, String message) {
        session.setAttribute("pwdError", message);
        return "redirect:/profile#change-password";
    }

    // ─── Utility ───────────────────────────────────────────────────────────
    private static String[] appendError(String[] arr, String msg) {
        String[] newArr = new String[arr.length + 1];
        System.arraycopy(arr, 0, newArr, 0, arr.length);
        newArr[arr.length] = msg;
        return newArr;
    }
}
