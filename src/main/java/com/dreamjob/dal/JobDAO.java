package com.dreamjob.dal;

import com.dreamjob.model.Job;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class JobDAO {

    @Autowired
    private DBContext dbContext;

    public List<Job> getFeaturedJobs(int limit) {
        return getJobsByOrder("j.PostedDate DESC", limit);
    }

    public List<Job> getLatestJobs(int limit) {
        return getJobsByOrder("j.PostedDate DESC", limit);
    }

    public List<Job> getHottestJobs(int limit) {
        // Hottest based on SalaryMax for now
        return getJobsByOrder("j.SalaryMax DESC", limit);
    }

    /**
     * Lấy việc làm tương tự theo thứ tự ưu tiên:
     * 1. Cùng danh mục + cùng địa điểm (xếp theo ngày đăng mới nhất)
     * 2. Bổ sung cùng danh mục nếu chưa đủ
     * 3. Fallback mới nhất nếu vẫn chưa đủ
     * Luôn loại trừ job hiện tại.
     */
    public List<Job> getSimilarJobs(int currentJobId, int categoryId, int locationId, int limit) {
        List<Job> result = new ArrayList<>();

        // --- Bước 1: cùng category + location ---
        if (categoryId > 0 && locationId > 0) {
            String sql = "SELECT TOP (?) j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName "
                    + "FROM Jobs j "
                    + "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID "
                    + "LEFT JOIN Locations l ON j.LocationID = l.LocationID "
                    + "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID "
                    + "WHERE j.Status = 'ACTIVE' AND j.JobID <> ? "
                    + "  AND j.CategoryID = ? AND j.LocationID = ? "
                    + "ORDER BY j.PostedDate DESC";
            result.addAll(queryJobs(sql, limit, currentJobId, categoryId, locationId));
        }

        // --- Bước 2: bổ sung cùng category (loại bỏ id đã có) ---
        if (result.size() < limit && categoryId > 0) {
            int need = limit - result.size();
            List<Integer> excludeIds = getIds(result);
            excludeIds.add(currentJobId);
            String inClause = buildInClause(excludeIds.size());
            String sql = "SELECT TOP (?) j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName "
                    + "FROM Jobs j "
                    + "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID "
                    + "LEFT JOIN Locations l ON j.LocationID = l.LocationID "
                    + "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID "
                    + "WHERE j.Status = 'ACTIVE' AND j.JobID NOT IN (" + inClause + ") "
                    + "  AND j.CategoryID = ? "
                    + "ORDER BY j.PostedDate DESC";
            result.addAll(queryJobsWithExclude(sql, need, excludeIds, categoryId));
        }

        // --- Bước 3: fallback mới nhất ---
        if (result.size() < limit) {
            int need = limit - result.size();
            List<Integer> excludeIds = getIds(result);
            excludeIds.add(currentJobId);
            String inClause = buildInClause(excludeIds.size());
            String sql = "SELECT TOP (?) j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName "
                    + "FROM Jobs j "
                    + "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID "
                    + "LEFT JOIN Locations l ON j.LocationID = l.LocationID "
                    + "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID "
                    + "WHERE j.Status = 'ACTIVE' AND j.JobID NOT IN (" + inClause + ") "
                    + "ORDER BY j.PostedDate DESC";
            result.addAll(queryJobsWithExclude(sql, need, excludeIds, null));
        }

        return result;
    }

    // ─── Private helpers for getSimilarJobs ───────────────────────────────

    private List<Job> queryJobs(String sql, int limit, int excludeId, int categoryId, int locationId) {
        List<Job> list = new ArrayList<>();
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, excludeId);
            ps.setInt(3, categoryId);
            ps.setInt(4, locationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapJob(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Job> queryJobsWithExclude(String sql, int limit,
            List<Integer> excludeIds, Integer categoryId) {
        List<Job> list = new ArrayList<>();
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, limit);
            for (int id : excludeIds)
                ps.setInt(idx++, id);
            if (categoryId != null)
                ps.setInt(idx, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapJob(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Integer> getIds(List<Job> jobs) {
        List<Integer> ids = new ArrayList<>();
        for (Job j : jobs)
            ids.add(j.getJobId());
        return ids;
    }

    private String buildInClause(int size) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < size; i++) {
            if (i > 0)
                sb.append(",");
            sb.append("?");
        }
        return sb.toString();
    }

    private List<Job> getJobsByOrder(String orderBy, int limit) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT TOP (?) j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName " +
                "FROM Jobs j " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID " +
                "WHERE j.Status = 'ACTIVE' " +
                "ORDER BY " + orderBy;

        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobs.add(mapJob(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public List<Job> getJobsByRecruiter(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName " +
                "FROM Jobs j " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID " +
                "WHERE j.RecruiterID = ? " +
                "ORDER BY j.PostedDate DESC";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobs.add(mapJob(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public Job getJobById(int jobId) {
        String sql = "SELECT j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName " +
                "FROM Jobs j " +
                "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID " +
                "WHERE j.JobID = ?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapJob(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createJob(Job job) {
        String sql = "INSERT INTO Jobs (RecruiterID, Title, Description, Requirements, SalaryMin, SalaryMax, LocationID, CategoryID, EmploymentType, PostedDate, ExpiredDate, Status) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?)";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, job.getRecruiterId());
            ps.setString(2, job.getTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getRequirements());
            ps.setBigDecimal(5, job.getSalaryMin());
            ps.setBigDecimal(6, job.getSalaryMax());
            ps.setObject(7, job.getLocationId() > 0 ? job.getLocationId() : null);
            ps.setObject(8, job.getCategoryId() > 0 ? job.getCategoryId() : null);
            ps.setString(9, job.getEmploymentType());
            ps.setTimestamp(10, job.getExpiredDate());
            ps.setString(11, job.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateJob(Job job) {
        String sql = "UPDATE Jobs SET Title=?, Description=?, Requirements=?, SalaryMin=?, SalaryMax=?, LocationID=?, CategoryID=?, EmploymentType=?, ExpiredDate=?, Status=? "
                +
                "WHERE JobID=? AND RecruiterID=?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getRequirements());
            ps.setBigDecimal(4, job.getSalaryMin());
            ps.setBigDecimal(5, job.getSalaryMax());
            ps.setObject(6, job.getLocationId() > 0 ? job.getLocationId() : null);
            ps.setObject(7, job.getCategoryId() > 0 ? job.getCategoryId() : null);
            ps.setString(8, job.getEmploymentType());
            ps.setTimestamp(9, job.getExpiredDate());
            ps.setString(10, job.getStatus());
            ps.setInt(11, job.getJobId());
            ps.setInt(12, job.getRecruiterId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean closeJob(int jobId, int recruiterId) {
        String sql = "UPDATE Jobs SET Status='CLOSED' WHERE JobID=? AND RecruiterID=? AND Status='ACTIVE'";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void autoCloseExpiredJobs() {
        String sql = "UPDATE Jobs SET Status='CLOSED' WHERE Status='ACTIVE' AND ExpiredDate < GETDATE()";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean deleteJob(int jobId, int recruiterId) {
        String sql = "DELETE FROM Jobs WHERE JobID=? AND RecruiterID=?";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Job mapJob(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setJobId(rs.getInt("JobID"));
        job.setRecruiterId(rs.getInt("RecruiterID"));
        job.setTitle(rs.getString("Title"));
        job.setDescription(rs.getString("Description"));
        job.setRequirements(rs.getString("Requirements"));
        job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
        job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
        job.setLocationId(rs.getInt("LocationID"));
        job.setCategoryId(rs.getInt("CategoryID"));
        job.setEmploymentType(rs.getString("EmploymentType"));
        job.setPostedDate(rs.getTimestamp("PostedDate"));
        job.setExpiredDate(rs.getTimestamp("ExpiredDate"));
        job.setStatus(rs.getString("Status"));

        // Display fields
        job.setCompanyName(rs.getString("CompanyName"));
        job.setLogoPath(rs.getString("LogoPath"));
        job.setCity(rs.getString("City"));
        job.setCategoryName(rs.getString("CategoryName"));
        return job;
    }
}
