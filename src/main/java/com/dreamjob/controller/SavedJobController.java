package com.dreamjob.controller;

import com.dreamjob.dal.SavedJobDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/saved-jobs")
public class SavedJobController {

    @Autowired
    private SavedJobDAO savedJobDAO;
    @Autowired
    private UserDAO userDAO;

    @GetMapping
    public String viewSavedJobs(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"JOBSEEKER".equals(user.getRole()))
            return "redirect:/login";

        Integer seekerId = userDAO.getJobSeekerIdByUserId(user.getUserId());
        if (seekerId != null) {
            model.addAttribute("savedJobs", savedJobDAO.getSavedJobs(seekerId));
        }
        return "seeker/saved-jobs";
    }

    @PostMapping("/toggle")
    @ResponseBody
    public String toggleSave(@RequestParam int jobId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"JOBSEEKER".equals(user.getRole()))
            return "error";

        Integer seekerId = userDAO.getJobSeekerIdByUserId(user.getUserId());
        if (seekerId == null)
            return "error";

        if (savedJobDAO.isSaved(jobId, seekerId)) {
            savedJobDAO.unsaveJob(jobId, seekerId);
            return "unsaved";
        } else {
            savedJobDAO.saveJob(jobId, seekerId);
            return "saved";
        }
    }
}
