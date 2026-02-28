package com.dreamjob.controller;

import com.dreamjob.dal.ApplicationDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/applications")
public class ApplicationController {

    @Autowired
    private ApplicationDAO applicationDAO;
    @Autowired
    private UserDAO userDAO;

    /** Seeker: view own applications */
    @GetMapping("/my")
    public String myApplications(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"JOBSEEKER".equals(user.getRole()))
            return "redirect:/login";

        Integer seekerId = userDAO.getJobSeekerIdByUserId(user.getUserId());
        if (seekerId == null) {
            model.addAttribute("applications", List.of());
            return "seeker/my-applications";
        }
        model.addAttribute("applications", applicationDAO.getApplicationsBySeeker(seekerId));
        return "seeker/my-applications";
    }

    /** Recruiter: view all applications for their jobs */
    @GetMapping("/manage")
    public String manageApplications(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole()))
            return "redirect:/login";

        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        if (recruiterId == null)
            return "redirect:/";
        model.addAttribute("applications", applicationDAO.getApplicationsByRecruiter(recruiterId));
        return "recruiter/applications";
    }

    /** Recruiter: view applications for a specific job */
    @GetMapping("/job/{jobId}")
    public String applicationsByJob(@PathVariable int jobId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole()))
            return "redirect:/login";
        model.addAttribute("applications", applicationDAO.getApplicationsByJob(jobId));
        model.addAttribute("jobId", jobId);
        return "recruiter/applications";
    }

    /** Recruiter: update application status */
    @PostMapping("/status")
    public String updateStatus(@RequestParam int applicationId,
            @RequestParam String status,
            @RequestParam(defaultValue = "0") int jobId,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole()))
            return "redirect:/login";
        applicationDAO.updateStatus(applicationId, status);
        return "redirect:/applications/manage";
    }
}
