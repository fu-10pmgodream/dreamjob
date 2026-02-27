package com.dreamjob.dal;

import com.dreamjob.model.RecruiterProfile;
import com.dreamjob.model.JobSeekerProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.*;

@Repository
public class ProfileDAO {

    @Autowired
    private DBContext dbContext;

    // ================= RECRUITER PROFILE =================

    public RecruiterProfile getRecruiterProfileByUserId(int userId) {
        String sql = "SELECT rp.*, l.City, l.Country, u.Email, u.FullName, u.Phone " +
                "FROM RecruiterProfiles rp " +
                "JOIN Users u ON rp.UserID = u.UserID " +
                "LEFT JOIN Locations l ON rp.LocationID = l.LocationID " +
                "WHERE rp.UserID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRecruiterProfile(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean upsertRecruiterProfile(RecruiterProfile profile, String fullName, String phone) {
        // Update Users table first
        String sqlUser = "UPDATE Users SET FullName=?, Phone=? WHERE UserID=?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sqlUser)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, profile.getUserId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        // Check if profile exists
        String checkSql = "SELECT COUNT(1) FROM RecruiterProfiles WHERE UserID=?";
        boolean exists = false;
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, profile.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    exists = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        if (exists) {
            String sql = "UPDATE RecruiterProfiles SET CompanyName=?, CompanyDescription=?, Website=?, CompanySize=?, LocationID=?"
                    +
                    (profile.getLogoPath() != null ? ", LogoPath=?" : "") +
                    " WHERE UserID=?";
            try (Connection con = dbContext.getConnection();
                    PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, profile.getCompanyName());
                ps.setString(2, profile.getCompanyDescription());
                ps.setString(3, profile.getWebsite());
                ps.setString(4, profile.getCompanySize());
                ps.setObject(5, profile.getLocationId() > 0 ? profile.getLocationId() : null);
                if (profile.getLogoPath() != null) {
                    ps.setString(6, profile.getLogoPath());
                    ps.setInt(7, profile.getUserId());
                } else {
                    ps.setInt(6, profile.getUserId());
                }
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            String sql = "INSERT INTO RecruiterProfiles (UserID, CompanyName, CompanyDescription, Website, LogoPath, CompanySize, LocationID) VALUES (?,?,?,?,?,?,?)";
            try (Connection con = dbContext.getConnection();
                    PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, profile.getUserId());
                ps.setString(2, profile.getCompanyName());
                ps.setString(3, profile.getCompanyDescription());
                ps.setString(4, profile.getWebsite());
                ps.setString(5, profile.getLogoPath());
                ps.setString(6, profile.getCompanySize());
                ps.setObject(7, profile.getLocationId() > 0 ? profile.getLocationId() : null);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // ================= JOB SEEKER PROFILE =================

    public JobSeekerProfile getSeekerProfileByUserId(int userId) {
        String sql = "SELECT jsp.*, l.City, u.Email, u.FullName, u.Phone " +
                "FROM JobSeekerProfiles jsp " +
                "JOIN Users u ON jsp.UserID = u.UserID " +
                "LEFT JOIN Locations l ON jsp.LocationID = l.LocationID " +
                "WHERE jsp.UserID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapSeekerProfile(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean upsertSeekerProfile(JobSeekerProfile profile, String fullName, String phone) {
        // Update Users table first
        String sqlUser = "UPDATE Users SET FullName=?, Phone=? WHERE UserID=?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sqlUser)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, profile.getUserId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        String checkSql = "SELECT COUNT(1) FROM JobSeekerProfiles WHERE UserID=?";
        boolean exists = false;
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, profile.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    exists = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        if (exists) {
            String sql = "UPDATE JobSeekerProfiles SET Title=?, Skills=?, ExperienceYears=?, Education=?, LocationID=?"
                    +
                    (profile.getCvPath() != null ? ", CVPath=?" : "") + " WHERE UserID=?";
            try (Connection con = dbContext.getConnection();
                    PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, profile.getTitle());
                ps.setString(2, profile.getSkills());
                ps.setInt(3, profile.getExperienceYears());
                ps.setString(4, profile.getEducation());
                ps.setObject(5, profile.getLocationId() > 0 ? profile.getLocationId() : null);
                if (profile.getCvPath() != null) {
                    ps.setString(6, profile.getCvPath());
                    ps.setInt(7, profile.getUserId());
                } else {
                    ps.setInt(6, profile.getUserId());
                }
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            String sql = "INSERT INTO JobSeekerProfiles (UserID, Title, Skills, ExperienceYears, Education, CVPath, LocationID) VALUES (?,?,?,?,?,?,?)";
            try (Connection con = dbContext.getConnection();
                    PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, profile.getUserId());
                ps.setString(2, profile.getTitle());
                ps.setString(3, profile.getSkills());
                ps.setInt(4, profile.getExperienceYears());
                ps.setString(5, profile.getEducation());
                ps.setString(6, profile.getCvPath());
                ps.setObject(7, profile.getLocationId() > 0 ? profile.getLocationId() : null);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // ============= MAPPERS =============

    private RecruiterProfile mapRecruiterProfile(ResultSet rs) throws SQLException {
        RecruiterProfile p = new RecruiterProfile();
        p.setRecruiterId(rs.getInt("RecruiterID"));
        p.setUserId(rs.getInt("UserID"));
        p.setCompanyName(rs.getString("CompanyName"));
        p.setCompanyDescription(rs.getString("CompanyDescription"));
        p.setWebsite(rs.getString("Website"));
        p.setLogoPath(rs.getString("LogoPath"));
        p.setCompanySize(rs.getString("CompanySize"));
        p.setLocationId(rs.getInt("LocationID"));
        p.setCity(rs.getString("City"));
        p.setEmail(rs.getString("Email"));
        p.setFullName(rs.getString("FullName"));
        p.setPhone(rs.getString("Phone"));
        return p;
    }

    private JobSeekerProfile mapSeekerProfile(ResultSet rs) throws SQLException {
        JobSeekerProfile p = new JobSeekerProfile();
        p.setJobSeekerId(rs.getInt("JobSeekerID"));
        p.setUserId(rs.getInt("UserID"));
        p.setTitle(rs.getString("Title"));
        p.setSkills(rs.getString("Skills"));
        p.setExperienceYears(rs.getInt("ExperienceYears"));
        p.setEducation(rs.getString("Education"));
        p.setCvPath(rs.getString("CVPath"));
        p.setLocationId(rs.getInt("LocationID"));
        p.setCity(rs.getString("City"));
        p.setEmail(rs.getString("Email"));
        p.setFullName(rs.getString("FullName"));
        p.setPhone(rs.getString("Phone"));
        return p;
    }
}
