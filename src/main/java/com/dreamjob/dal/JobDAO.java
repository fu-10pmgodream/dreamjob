package com.dreamjob.dal;

import com.dreamjob.model.Job;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Repository
public class JobDAO {

    @Autowired
    private DBContext dbContext;

    public List<Job> getFeaturedJobs(int limit) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT TOP (?) j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName " +
                "FROM Jobs j " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID " +
                "WHERE j.Status = 'ACTIVE' " +
                "ORDER BY j.PostedDate DESC";

        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = new Job();
                    job.setJobId(rs.getInt("JobID"));
                    job.setRecruiterId(rs.getInt("RecruiterID"));
                    job.setTitle(rs.getString("Title"));
                    job.setDescription(rs.getString("Description"));
                    job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
                    job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
                    job.setEmploymentType(rs.getString("EmploymentType"));
                    job.setPostedDate(rs.getTimestamp("PostedDate"));

                    // Display fields
                    job.setCompanyName(rs.getString("CompanyName"));
                    job.setLogoPath(rs.getString("LogoPath"));
                    job.setCity(rs.getString("City"));
                    job.setCategoryName(rs.getString("CategoryName"));

                    jobs.add(job);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobs;
    }
}
