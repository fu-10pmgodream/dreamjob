package com.dreamjob.dal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SavedJobDAO {

    @Autowired
    private DBContext dbContext;

    public boolean saveJob(int jobId, int jobSeekerId) {
        String sql = "INSERT INTO SavedJobs (JobID, JobSeekerID, SavedDate) VALUES (?, ?, GETDATE())";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean unsaveJob(int jobId, int jobSeekerId) {
        String sql = "DELETE FROM SavedJobs WHERE JobID = ? AND JobSeekerID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isSaved(int jobId, int jobSeekerId) {
        String sql = "SELECT 1 FROM SavedJobs WHERE JobID = ? AND JobSeekerID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Integer> getSavedJobIds(int jobSeekerId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT JobID FROM SavedJobs WHERE JobSeekerID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    ids.add(rs.getInt("JobID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    public List<com.dreamjob.model.Job> getSavedJobs(int jobSeekerId) {
        List<com.dreamjob.model.Job> jobs = new ArrayList<>();
        String sql = "SELECT j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName " +
                "FROM SavedJobs sj " +
                "JOIN Jobs j ON sj.JobID = j.JobID " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID " +
                "WHERE sj.JobSeekerID = ? ORDER BY sj.SavedDate DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.dreamjob.model.Job job = new com.dreamjob.model.Job();
                    job.setJobId(rs.getInt("JobID"));
                    job.setTitle(rs.getString("Title"));
                    job.setDescription(rs.getString("Description"));
                    job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
                    job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
                    job.setEmploymentType(rs.getString("EmploymentType"));
                    job.setPostedDate(rs.getTimestamp("PostedDate"));
                    job.setStatus(rs.getString("Status"));
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
