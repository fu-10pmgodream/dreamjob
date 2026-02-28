package com.dreamjob.dal;

import com.dreamjob.model.Application;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ApplicationDAO {

    @Autowired
    private DBContext dbContext;

    public boolean apply(int jobId, int jobSeekerId, String coverLetter, String cvPath) {
        String sql = "INSERT INTO Applications (JobID, JobSeekerID, AppliedDate, Status, CoverLetter, CVPath) " +
                "VALUES (?, ?, GETDATE(), 'PENDING', ?, ?)";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            ps.setString(3, coverLetter);
            ps.setString(4, cvPath);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasApplied(int jobId, int jobSeekerId) {
        String sql = "SELECT 1 FROM Applications WHERE JobID = ? AND JobSeekerID = ?";
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

    /** Seeker: view their own applications */
    public List<Application> getApplicationsBySeeker(int jobSeekerId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.Title as JobTitle, r.CompanyName, r.LogoPath as CompanyLogo " +
                "FROM Applications a " +
                "JOIN Jobs j ON a.JobID = j.JobID " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "WHERE a.JobSeekerID = ? ORDER BY a.AppliedDate DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapApplication(rs, true));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Recruiter: view applications for a specific job */
    public List<Application> getApplicationsByJob(int jobId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.Title as JobTitle, r.CompanyName, r.LogoPath as CompanyLogo, " +
                "u.FullName as SeekerName, u.Email as SeekerEmail, u.Phone as SeekerPhone " +
                "FROM Applications a " +
                "JOIN Jobs j ON a.JobID = j.JobID " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "JOIN JobSeekerProfiles jsp ON a.JobSeekerID = jsp.JobSeekerID " +
                "JOIN Users u ON jsp.UserID = u.UserID " +
                "WHERE a.JobID = ? ORDER BY a.AppliedDate DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapApplication(rs, false));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Recruiter: view all applications for all their jobs */
    public List<Application> getApplicationsByRecruiter(int recruiterId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.Title as JobTitle, r.CompanyName, r.LogoPath as CompanyLogo, " +
                "u.FullName as SeekerName, u.Email as SeekerEmail, u.Phone as SeekerPhone " +
                "FROM Applications a " +
                "JOIN Jobs j ON a.JobID = j.JobID " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "JOIN JobSeekerProfiles jsp ON a.JobSeekerID = jsp.JobSeekerID " +
                "JOIN Users u ON jsp.UserID = u.UserID " +
                "WHERE r.RecruiterID = ? ORDER BY a.AppliedDate DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapApplication(rs, false));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE Applications SET Status = ? WHERE ApplicationID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Application mapApplication(ResultSet rs, boolean includeSeeker) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("ApplicationID"));
        a.setJobId(rs.getInt("JobID"));
        a.setJobSeekerId(rs.getInt("JobSeekerID"));
        a.setAppliedDate(rs.getTimestamp("AppliedDate"));
        a.setStatus(rs.getString("Status"));
        a.setCoverLetter(rs.getString("CoverLetter"));
        a.setCvPath(rs.getString("CVPath"));
        a.setJobTitle(rs.getString("JobTitle"));
        a.setCompanyName(rs.getString("CompanyName"));
        a.setCompanyLogo(rs.getString("CompanyLogo"));
        if (!includeSeeker) {
            try {
                a.setSeekerName(rs.getString("SeekerName"));
                a.setSeekerEmail(rs.getString("SeekerEmail"));
                a.setSeekerPhone(rs.getString("SeekerPhone"));
            } catch (SQLException ignored) {
            }
        }
        return a;
    }
}
