package com.dreamjob.controller;

import com.dreamjob.dal.JobDAO;
import com.dreamjob.model.Job;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private JobDAO jobDAO;

    @GetMapping("/")
    public String index(Model model) {
        List<Job> featuredJobs = jobDAO.getFeaturedJobs(6);
        model.addAttribute("featuredJobs", featuredJobs);
        return "home/index";
    }
}
