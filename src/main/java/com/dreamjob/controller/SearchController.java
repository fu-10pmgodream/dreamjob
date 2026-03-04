package com.dreamjob.controller;

import com.dreamjob.dal.SearchDAO;
import com.dreamjob.dal.SavedJobDAO;
import com.dreamjob.dal.UserDAO;
import com.dreamjob.model.Job;
import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/search")
public class SearchController {

    @Autowired
    private SearchDAO searchDAO;
    @Autowired
    private SavedJobDAO savedJobDAO;
    @Autowired
    private UserDAO userDAO;

    private static final int PAGE_SIZE = 9;

    @GetMapping
    public String search(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) String categoryId,
            @RequestParam(required = false) String locationId,
            @RequestParam(required = false) String salaryMin,
            @RequestParam(required = false) String salaryMax,
            @RequestParam(required = false) String employmentType,
            @RequestParam(required = false, defaultValue = "newest") String sortBy,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session, Model model) {

        List<Job> jobs = searchDAO.searchJobs(keyword.trim(), categoryId, locationId,
                salaryMin, salaryMax, employmentType, sortBy, page, PAGE_SIZE);

        int totalJobs = searchDAO.countSearch(keyword.trim(), categoryId, locationId, salaryMin, salaryMax, employmentType);
        int totalPages = (int) Math.ceil((double) totalJobs / PAGE_SIZE);

        // Get saved job IDs for current seeker
        User user = (User) session.getAttribute("user");
        if (user != null && "JOBSEEKER".equals(user.getRole())) {
            Integer seekerId = userDAO.getJobSeekerIdByUserId(user.getUserId());
            if (seekerId != null) {
                model.addAttribute("savedJobIds", savedJobDAO.getSavedJobIds(seekerId));
            }
        }

        model.addAttribute("jobs", jobs);
        model.addAttribute("totalJobs", totalJobs);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", page);
        model.addAttribute("categories", searchDAO.getAllCategories());
        model.addAttribute("locations", searchDAO.getAllLocations());
        // Preserve filter params
        model.addAttribute("keyword", keyword.trim());
        model.addAttribute("selectedCategory", categoryId);
        model.addAttribute("selectedLocation", locationId);
        model.addAttribute("salaryMin", salaryMin);
        model.addAttribute("salaryMax", salaryMax);
        model.addAttribute("selectedType", employmentType);
        model.addAttribute("sortBy", sortBy);

        return "search/results";
    }
}
