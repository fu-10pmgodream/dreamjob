package com.dreamjob.controller;

import com.dreamjob.dal.ProfileDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.JobSeekerProfile;
import com.dreamjob.model.RecruiterProfile;
import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private ProfileDAO profileDAO;

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/";
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        User user = userDAO.login(email, password);
        if (user != null) {
            session.setAttribute("user", user);
            return "redirect:/";
        } else {
            model.addAttribute("error", "Email hoặc mật khẩu không chính xác!");
            return "auth/login";
        }
    }

    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/";
        }
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String fullName,
            @RequestParam String role,
            @RequestParam String phone,
            Model model) {

        // Validate số điện thoại phải có đúng 10 chữ số
        if (phone == null || !phone.matches("\\d{10}")) {
            model.addAttribute("error", "Số điện thoại phải có đúng 10 chữ số!");
            return "auth/register";
        }

        if (userDAO.findByEmail(email) != null) {
            model.addAttribute("error", "Email này đã được sử dụng!");
            return "auth/register";
        }

        if (userDAO.findByPhone(phone) != null) {
            model.addAttribute("error", "Số điện thoại này đã được sử dụng!");
            return "auth/register";
        }

        User user = new User();
        user.setEmail(email);
        user.setFullName(fullName);
        user.setRole(role);
        user.setPhone(phone);

        if (userDAO.register(user, password)) {
            User createdUser = userDAO.findByEmail(email);

            // ===============================
            // Nếu là RECRUITER
            // ===============================
            if ("RECRUITER".equalsIgnoreCase(role)) {

                RecruiterProfile recruiterProfile = new RecruiterProfile();
                recruiterProfile.setUserId(createdUser.getUserId());
                recruiterProfile.setCompanyName("Chưa cập nhật");
                recruiterProfile.setCompanyDescription("");
                recruiterProfile.setWebsite("");
                recruiterProfile.setLogoPath(null);
                recruiterProfile.setCompanySize("");
                recruiterProfile.setLocationId(0);

                profileDAO.upsertRecruiterProfile(recruiterProfile, fullName, phone);
            }

            // ===============================
            // Nếu là JOBSEEKER
            // ===============================
            if ("JOBSEEKER".equalsIgnoreCase(role)) {

                JobSeekerProfile profile = new JobSeekerProfile();
                profile.setUserId(createdUser.getUserId());
                profile.setTitle("");
                profile.setSkills("");
                profile.setExperienceYears(0);
                profile.setEducation("");
                profile.setCvPath(null);
                profile.setLocationId(0);

                profileDAO.upsertSeekerProfile(profile, fullName, phone);
            }

            return "redirect:/login?success=true";
        } else {
            model.addAttribute("error", "Đã có lỗi xảy ra, vui lòng thử lại!");
            return "auth/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
