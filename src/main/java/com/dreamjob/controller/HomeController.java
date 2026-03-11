package com.dreamjob.controller;

import com.dreamjob.dal.JobDAO;
import com.dreamjob.dal.SearchDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private JobDAO jobDAO;

    @Autowired
    private SearchDAO searchDAO;

    @GetMapping("/")
    public String index(Model model) {
        jobDAO.autoCloseExpiredJobs();
        model.addAttribute("featuredJobs", jobDAO.getFeaturedJobs(6));
        model.addAttribute("latestJobs", jobDAO.getLatestJobs(8));
        model.addAttribute("hottestJobs", jobDAO.getHottestJobs(4));
        model.addAttribute("locations", searchDAO.getAllLocations());
        return "home/index";
    }
}
