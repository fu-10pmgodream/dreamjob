package com.dreamjob.dal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

@Repository
public class AdminDAO {

    @Autowired
    private DBContext dbContext;

    public int countUsers() {
        return countQuery("SELECT COUNT(*) FROM Users");
    }

    public int countJobs() {
        return countQuery("SELECT COUNT(*) FROM Jobs WHERE Status='ACTIVE'");
    }

    public int countApplications() {
        return countQuery("SELECT COUNT(*) FROM Applications");
    }

    public int countCompanies() {
        return countQuery("SELECT COUNT(*) FROM RecruiterProfiles");
    }

    public Map<String, Integer> getJobsByCategory() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT c.CategoryName, COUNT(j.JobID) as cnt " +
                "FROM JobCategories c LEFT JOIN Jobs j ON c.CategoryID = j.CategoryID AND j.Status='ACTIVE' " +
                "GROUP BY c.CategoryName ORDER BY cnt DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                map.put(rs.getString("CategoryName"), rs.getInt("cnt"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Integer> getApplicationsByStatus() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT Status, COUNT(*) as cnt FROM Applications GROUP BY Status";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                map.put(rs.getString("Status"), rs.getInt("cnt"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Integer> getJobsByEmploymentType() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT EmploymentType, COUNT(*) as cnt FROM Jobs WHERE Status='ACTIVE' GROUP BY EmploymentType ORDER BY cnt DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                map.put(rs.getString("EmploymentType"), rs.getInt("cnt"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Integer> getUsersByRole() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT Role, COUNT(*) as cnt FROM Users GROUP BY Role";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                map.put(rs.getString("Role"), rs.getInt("cnt"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public double getAvgSalary() {
        String sql = "SELECT AVG((SalaryMin+SalaryMax)/2) FROM Jobs WHERE Status='ACTIVE' AND SalaryMin IS NOT NULL";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getMaxSalary() {
        String sql = "SELECT MAX(SalaryMax) FROM Jobs WHERE Status='ACTIVE'";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getMinSalary() {
        String sql = "SELECT MIN(SalaryMin) FROM Jobs WHERE Status='ACTIVE' AND SalaryMin > 0";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // All users list
    public java.util.List<com.dreamjob.model.User> getAllUsers() {
        java.util.List<com.dreamjob.model.User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY CreatedAt DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                com.dreamjob.model.User u = new com.dreamjob.model.User();
                u.setUserId(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setRole(rs.getString("Role"));
                u.setPhone(rs.getString("Phone"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                u.setActive(rs.getBoolean("IsActive"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Paged users list
    public java.util.List<com.dreamjob.model.User> getUsersPaged(int page, int pageSize) {
        java.util.List<com.dreamjob.model.User> list = new java.util.ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Users ORDER BY CreatedAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.dreamjob.model.User u = new com.dreamjob.model.User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setEmail(rs.getString("Email"));
                    u.setFullName(rs.getString("FullName"));
                    u.setRole(rs.getString("Role"));
                    u.setPhone(rs.getString("Phone"));
                    u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    u.setActive(rs.getBoolean("IsActive"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean toggleUserActive(int userId) {
        String sql = "UPDATE Users SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE UserID=?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private int countQuery(String sql) {
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
