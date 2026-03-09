package com.dreamjob.controller;

import com.dreamjob.dal.ApplicationDAO;
import com.dreamjob.dal.JobDAO;
import com.dreamjob.dal.SavedJobDAO;
import com.dreamjob.dal.SearchDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.Job;
import com.dreamjob.model.User;
import com.dreamjob.service.FileStorageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Timestamp;
import java.util.List;

@Controller
@RequestMapping("/jobs")
public class JobController {

    @Autowired
    private JobDAO jobDAO;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private ApplicationDAO applicationDAO;

    @Autowired
    private SavedJobDAO savedJobDAO;

    @Autowired
    private SearchDAO searchDAO;

    @Autowired
    private FileStorageService fileStorageService;

    // View Job Details
    @GetMapping("/{id}")
    public String details(@PathVariable int id, Model model, HttpSession session) {
        Job job = jobDAO.getJobById(id);
        if (job == null)
            return "error/404";
        model.addAttribute("job", job);
        model.addAttribute("similarJobs",
                jobDAO.getSimilarJobs(job.getJobId(), job.getCategoryId(), job.getLocationId(), 3));

        User user = (User) session.getAttribute("user");
        if (user != null && "JOBSEEKER".equals(user.getRole())) {
            Integer seekerId = userDAO.getJobSeekerIdByUserId(user.getUserId());
            if (seekerId != null) {
                model.addAttribute("hasApplied", applicationDAO.hasApplied(id, seekerId));
                model.addAttribute("isSaved", savedJobDAO.isSaved(id, seekerId));
            }
        }

        return "job/details";
    }

    // --- JOBSEEKER ACTIONS ---
    @PostMapping("/apply")
    public String apply(@RequestParam int jobId,
            @RequestParam String coverLetter,
            @RequestParam("cvFile") MultipartFile cvFile,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"JOBSEEKER".equals(user.getRole())) {
            return "redirect:/login";
        }

        Integer seekerId = userDAO.getJobSeekerIdByUserId(user.getUserId());
        if (seekerId == null)
            return "redirect:/";

        String cvUrl = null;
        if (cvFile != null && !cvFile.isEmpty()) {
            cvUrl = fileStorageService.uploadFile(cvFile, "cvs");
        }

        if (applicationDAO.apply(jobId, seekerId, coverLetter, cvUrl)) {
            return "redirect:/jobs/" + jobId + "?applied=success";
        }
        return "redirect:/jobs/" + jobId + "?applied=error";
    }

    // --- RECRUITER ACTIONS ---

    @GetMapping("/manage")
    public String manage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        if (recruiterId == null)
            return "redirect:/";

        List<Job> myJobs = jobDAO.getJobsByRecruiter(recruiterId);
        model.addAttribute("myJobs", myJobs);
        return "recruiter/dashboard";
    }

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "recruiter/job-form";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute Job job,
            @RequestParam(required = false) String expiredDateStr,
            HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        job.setRecruiterId(recruiterId);
        job.setStatus("ACTIVE");
        if (expiredDateStr != null && !expiredDateStr.isBlank()) {
            job.setExpiredDate(Timestamp.valueOf(expiredDateStr + " 23:59:59"));
        }

        if (jobDAO.createJob(job)) {
            return "redirect:/jobs/manage?success=created";
        }
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "recruiter/job-form";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        Job job = jobDAO.getJobById(id);

        if (job == null || job.getRecruiterId() != recruiterId) {
            return "redirect:/jobs/manage";
        }

        model.addAttribute("job", job);
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "recruiter/job-form";
    }

    @PostMapping("/edit")
    public String edit(@ModelAttribute Job job,
            @RequestParam(required = false) String expiredDateStr,
            HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        job.setRecruiterId(recruiterId);
        job.setStatus("ACTIVE");
        if (expiredDateStr != null && !expiredDateStr.isBlank()) {
            job.setExpiredDate(Timestamp.valueOf(expiredDateStr + " 23:59:59"));
        }

        if (jobDAO.updateJob(job)) {
            return "redirect:/jobs/manage?success=updated";
        }
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "recruiter/job-form";
    }

    @PostMapping("/close")
    public String close(@RequestParam int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        if (jobDAO.closeJob(id, recruiterId)) {
            return "redirect:/jobs/manage?success=closed";
        }
        return "redirect:/jobs/manage?error=close_failed";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECRUITER".equals(user.getRole())) {
            return "redirect:/login";
        }
        Integer recruiterId = userDAO.getRecruiterIdByUserId(user.getUserId());
        if (jobDAO.deleteJob(id, recruiterId)) {
            return "redirect:/jobs/manage?success=deleted";
        }
        return "redirect:/jobs/manage?error=delete_failed";
    }
}
