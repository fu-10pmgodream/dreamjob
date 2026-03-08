package com.dreamjob.controller;

import com.dreamjob.dal.AdminDAO;
import com.dreamjob.dal.JobDAO;
import com.dreamjob.dal.SearchDAO;
import com.dreamjob.model.Job;
import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminDAO adminDAO;

    @Autowired
    private JobDAO jobDAO;

    @Autowired
    private SearchDAO searchDAO;

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    // ─── Dashboard ─────────────────────────────────────────────────────────
    @GetMapping
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";

        model.addAttribute("totalUsers", adminDAO.countUsers());
        model.addAttribute("totalJobs", adminDAO.countJobs());
        model.addAttribute("totalApplications", adminDAO.countApplications());
        model.addAttribute("totalCompanies", adminDAO.countCompanies());
        model.addAttribute("avgSalary", adminDAO.getAvgSalary());
        model.addAttribute("maxSalary", adminDAO.getMaxSalary());
        model.addAttribute("minSalary", adminDAO.getMinSalary());
        model.addAttribute("jobsByCategory", adminDAO.getJobsByCategory());
        model.addAttribute("jobsByType", adminDAO.getJobsByEmploymentType());
        model.addAttribute("applicationsByStatus", adminDAO.getApplicationsByStatus());
        model.addAttribute("usersByRole", adminDAO.getUsersByRole());
        return "admin/dashboard";
    }

    // ─── Manage Users ──────────────────────────────────────────────────────
    @GetMapping("/users")
    public String manageUsers(@RequestParam(defaultValue = "1") int page,
            HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";

        final int PAGE_SIZE = 10;
        int totalUsers = adminDAO.countUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        if (page < 1)
            page = 1;
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        model.addAttribute("users", adminDAO.getUsersPaged(page, PAGE_SIZE));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalUsers", totalUsers);
        return "admin/users";
    }

    @PostMapping("/users/toggle")
    public String toggleUser(@RequestParam int userId,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminDAO.toggleUserActive(userId);
        return "redirect:/admin/users?page=" + page;
    }

    // ─── Manage Jobs — List ────────────────────────────────────────────────
    @GetMapping("/jobs")
    public String manageJobs(@RequestParam(defaultValue = "1") int page,
            HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";

        final int PAGE_SIZE = 10;
        int totalJobs = adminDAO.countAllJobs();
        int totalPages = (int) Math.ceil((double) totalJobs / PAGE_SIZE);
        if (page < 1)
            page = 1;
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        model.addAttribute("jobs", adminDAO.getAllJobsPaged(page, PAGE_SIZE));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalJobs", totalJobs);
        return "admin/jobs";
    }

    // ─── Manage Jobs — Edit form ───────────────────────────────────────────
    @GetMapping("/jobs/edit/{id}")
    public String editJobForm(@PathVariable int id, HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        Job job = jobDAO.getJobById(id);
        if (job == null)
            return "redirect:/admin/jobs";
        model.addAttribute("job", job);
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "admin/job-form";
    }

    // ─── Manage Jobs — Save edit ───────────────────────────────────────────
    @PostMapping("/jobs/edit")
    public String editJob(@RequestParam int jobId,
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String requirements,
            @RequestParam(required = false) String salaryMin,
            @RequestParam(required = false) String salaryMax,
            @RequestParam(required = false) String locationId,
            @RequestParam(required = false) String categoryId,
            @RequestParam(required = false) String employmentType,
            @RequestParam(required = false) String expiredDateStr,
            @RequestParam String status,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session, Model model) {

        if (!isAdmin(session))
            return "redirect:/login";

        Job job = jobDAO.getJobById(jobId);
        if (job == null)
            return "redirect:/admin/jobs";

        job.setTitle(title.trim());
        job.setDescription(description != null ? description.trim() : null);
        job.setRequirements(requirements != null ? requirements.trim() : null);
        job.setSalaryMin(salaryMin != null && !salaryMin.isBlank() ? new BigDecimal(salaryMin) : null);
        job.setSalaryMax(salaryMax != null && !salaryMax.isBlank() ? new BigDecimal(salaryMax) : null);
        job.setLocationId(locationId != null && !locationId.isBlank() ? Integer.parseInt(locationId) : 0);
        job.setCategoryId(categoryId != null && !categoryId.isBlank() ? Integer.parseInt(categoryId) : 0);
        job.setEmploymentType(employmentType);
        job.setStatus(status);
        if (expiredDateStr != null && !expiredDateStr.isBlank()) {
            job.setExpiredDate(Timestamp.valueOf(expiredDateStr + " 23:59:59"));
        }

        if (adminDAO.adminUpdateJob(job)) {
            return "redirect:/admin/jobs?page=" + page + "&success=updated";
        }

        model.addAttribute("error", "Cập nhật thất bại!");
        model.addAttribute("job", job);
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "admin/job-form";
    }

    // ─── Manage Jobs — Toggle status ───────────────────────────────────────
    @PostMapping("/jobs/toggle-status")
    public String toggleJobStatus(@RequestParam int jobId,
            @RequestParam String currentStatus,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        String newStatus = "ACTIVE".equals(currentStatus) ? "CLOSED" : "ACTIVE";
        adminDAO.adminSetJobStatus(jobId, newStatus);
        return "redirect:/admin/jobs?page=" + page;
    }

    // ─── Manage Jobs — Delete ──────────────────────────────────────────────
    @PostMapping("/jobs/delete")
    public String deleteJob(@RequestParam int jobId,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminDAO.adminDeleteJob(jobId);
        return "redirect:/admin/jobs?page=" + page;
    }
}
