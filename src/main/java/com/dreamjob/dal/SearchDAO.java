package com.dreamjob.dal;

import com.dreamjob.model.Job;
import com.dreamjob.model.JobCategory;
import com.dreamjob.model.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SearchDAO {

    @Autowired
    private DBContext dbContext;

    public List<Job> searchJobs(String keyword, String categoryId, String locationId,
            String salaryMin, String salaryMax, String employmentType,
            String sortBy, int page, int pageSize) {
        List<Job> jobs = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT j.*, r.CompanyName, r.LogoPath, l.City, c.CategoryName " +
                        "FROM Jobs j " +
                        "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                        "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                        "LEFT JOIN JobCategories c ON j.CategoryID = c.CategoryID " +
                        "WHERE j.Status = 'ACTIVE' ");

        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (j.Title LIKE ? OR j.Description LIKE ? OR r.CompanyName LIKE ?) ");
        }
        if (categoryId != null && !categoryId.isBlank()) {
            sql.append("AND j.CategoryID = ? ");
        }
        if (locationId != null && !locationId.isBlank()) {
            sql.append("AND j.LocationID = ? ");
        }
        if (salaryMin != null && !salaryMin.isBlank()) {
            sql.append("AND j.SalaryMin >= ? ");
        }
        if (salaryMax != null && !salaryMax.isBlank()) {
            sql.append("AND j.SalaryMax <= ? ");
        }
        if (employmentType != null && !employmentType.isBlank()) {
            sql.append("AND j.EmploymentType = ? ");
        }

        // Sorting
        switch (sortBy != null ? sortBy : "") {
            case "salary_asc":
                sql.append("ORDER BY j.SalaryMax ASC ");
                break;
            case "salary_desc":
                sql.append("ORDER BY j.SalaryMax DESC ");
                break;
            case "oldest":
                sql.append("ORDER BY j.PostedDate ASC ");
                break;
            default:
                sql.append("ORDER BY j.PostedDate DESC ");
                break;
        }

        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.isBlank()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (categoryId != null && !categoryId.isBlank())
                ps.setInt(idx++, Integer.parseInt(categoryId));
            if (locationId != null && !locationId.isBlank())
                ps.setInt(idx++, Integer.parseInt(locationId));
            if (salaryMin != null && !salaryMin.isBlank())
                ps.setBigDecimal(idx++, new BigDecimal(salaryMin));
            if (salaryMax != null && !salaryMax.isBlank())
                ps.setBigDecimal(idx++, new BigDecimal(salaryMax));
            if (employmentType != null && !employmentType.isBlank())
                ps.setString(idx++, employmentType);

            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    jobs.add(mapJob(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public int countSearch(String keyword, String categoryId, String locationId,
            String salaryMin, String salaryMax, String employmentType) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Jobs j " +
                        "JOIN RecruiterProfiles r ON j.RecruiterID = r.RecruiterID " +
                        "LEFT JOIN Locations l ON j.LocationID = l.LocationID " +
                        "WHERE j.Status = 'ACTIVE' ");
        if (keyword != null && !keyword.isBlank())
            sql.append("AND (j.Title LIKE ? OR j.Description LIKE ? OR r.CompanyName LIKE ?) ");
        if (categoryId != null && !categoryId.isBlank())
            sql.append("AND j.CategoryID = ? ");
        if (locationId != null && !locationId.isBlank())
            sql.append("AND j.LocationID = ? ");
        if (salaryMin != null && !salaryMin.isBlank())
            sql.append("AND j.SalaryMin >= ? ");
        if (salaryMax != null && !salaryMax.isBlank())
            sql.append("AND j.SalaryMax <= ? ");
        if (employmentType != null && !employmentType.isBlank())
            sql.append("AND j.EmploymentType = ? ");

        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.isBlank()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (categoryId != null && !categoryId.isBlank())
                ps.setInt(idx++, Integer.parseInt(categoryId));
            if (locationId != null && !locationId.isBlank())
                ps.setInt(idx++, Integer.parseInt(locationId));
            if (salaryMin != null && !salaryMin.isBlank())
                ps.setBigDecimal(idx++, new BigDecimal(salaryMin));
            if (salaryMax != null && !salaryMax.isBlank())
                ps.setBigDecimal(idx++, new BigDecimal(salaryMax));
            if (employmentType != null && !employmentType.isBlank())
                ps.setString(idx, employmentType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<JobCategory> getAllCategories() {
        List<JobCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM JobCategories ORDER BY CategoryName";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JobCategory c = new JobCategory();
                c.setCategoryId(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getString("CategoryName"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Location> getAllLocations() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT * FROM Locations ORDER BY City";
        try (Connection con = dbContext.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Location loc = new Location();
                loc.setLocationId(rs.getInt("LocationID"));
                loc.setCity(rs.getString("City"));
                loc.setCountry(rs.getString("Country"));
                list.add(loc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Job mapJob(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setJobId(rs.getInt("JobID"));
        job.setRecruiterId(rs.getInt("RecruiterID"));
        job.setTitle(rs.getString("Title"));
        job.setDescription(rs.getString("Description"));
        job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
        job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
        job.setLocationId(rs.getInt("LocationID"));
        job.setCategoryId(rs.getInt("CategoryID"));
        job.setEmploymentType(rs.getString("EmploymentType"));
        job.setPostedDate(rs.getTimestamp("PostedDate"));
        job.setExpiredDate(rs.getTimestamp("ExpiredDate"));
        job.setStatus(rs.getString("Status"));
        job.setCompanyName(rs.getString("CompanyName"));
        job.setLogoPath(rs.getString("LogoPath"));
        job.setCity(rs.getString("City"));
        job.setCategoryName(rs.getString("CategoryName"));
        return job;
    }
}
