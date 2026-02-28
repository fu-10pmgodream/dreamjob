package com.dreamjob.controller;

import com.dreamjob.dal.AdminDAO;
import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminDAO adminDAO;

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

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

    @GetMapping("/users")
    public String manageUsers(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        model.addAttribute("users", adminDAO.getAllUsers());
        return "admin/users";
    }

    @PostMapping("/users/toggle")
    public String toggleUser(@RequestParam int userId, HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminDAO.toggleUserActive(userId);
        return "redirect:/admin/users";
    }
}
