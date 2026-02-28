package com.dreamjob.controller;

import com.dreamjob.dal.ProfileDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.JobSeekerProfile;
import com.dreamjob.model.RecruiterProfile;
import com.dreamjob.model.User;
import com.dreamjob.service.CloudinaryService;
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
    private CloudinaryService cloudinaryService;

    @GetMapping
    public String viewProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

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

        RecruiterProfile profile = profileDAO.getRecruiterProfileByUserId(user.getUserId());
        if (profile == null) {
            profile = new RecruiterProfile();
            profile.setUserId(user.getUserId());
        }

        profile.setCompanyName(companyName);
        profile.setCompanyDescription(companyDescription);
        profile.setWebsite(website);
        profile.setCompanySize(companySize);
        if (locationId != null && !locationId.isBlank()) {
            profile.setLocationId(Integer.parseInt(locationId));
        }

        if (logoFile != null && !logoFile.isEmpty()) {
            String logoUrl = cloudinaryService.uploadImage(logoFile, "logos");
            profile.setLogoPath(logoUrl);
        } else {
            profile.setLogoPath(null); // signal: don't update logo
        }

        if (profileDAO.upsertRecruiterProfile(profile, fullName, phone)) {
            // Refresh session user
            User updated = userDAO.findByEmail(user.getEmail());
            session.setAttribute("user", updated);
            return "redirect:/profile?success=true";
        }
        model.addAttribute("error", "Cập nhật thất bại!");
        model.addAttribute("profile", profile);
        return "profile/recruiter";
    }

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

        JobSeekerProfile profile = profileDAO.getSeekerProfileByUserId(user.getUserId());
        if (profile == null) {
            profile = new JobSeekerProfile();
            profile.setUserId(user.getUserId());
        }

        profile.setTitle(title);
        profile.setSkills(skills);
        profile.setExperienceYears(experienceYears);
        profile.setEducation(education);
        if (locationId != null && !locationId.isBlank()) {
            profile.setLocationId(Integer.parseInt(locationId));
        }

        if (cvFile != null && !cvFile.isEmpty()) {
            String cvUrl = cloudinaryService.uploadImage(cvFile, "cvs");
            profile.setCvPath(cvUrl);
        } else {
            profile.setCvPath(null);
        }

        if (profileDAO.upsertSeekerProfile(profile, fullName, phone)) {
            User updated = userDAO.findByEmail(user.getEmail());
            session.setAttribute("user", updated);
            return "redirect:/profile?success=true";
        }
        model.addAttribute("error", "Cập nhật thất bại!");
        model.addAttribute("profile", profile);
        return "profile/seeker";
    }
}
