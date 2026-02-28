-- =============================================
-- DreamJob Database Schema
-- SQL Server
-- =============================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DreamJobDB')
BEGIN
    ALTER DATABASE DreamJobDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DreamJobDB;
END
GO

CREATE DATABASE DreamJobDB;
GO

USE DreamJobDB;
GO

-- =============================================
-- Table: Locations
-- =============================================
CREATE TABLE Locations (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL DEFAULT N'Vietnam'
);

-- =============================================
-- Table: Users
-- =============================================
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName NVARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('ADMIN', 'RECRUITER', 'JOBSEEKER')),
    Phone VARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

-- =============================================
-- Table: JobCategories
-- =============================================
CREATE TABLE JobCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);

-- =============================================
-- Table: RecruiterProfiles
-- =============================================
CREATE TABLE RecruiterProfiles (
    RecruiterID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    CompanyName NVARCHAR(255) NOT NULL,
    CompanyDescription NVARCHAR(MAX),
    Website VARCHAR(500),
    LogoPath VARCHAR(500),
    CompanySize NVARCHAR(50),
    LocationID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- =============================================
-- Table: JobSeekerProfiles
-- =============================================
CREATE TABLE JobSeekerProfiles (
    JobSeekerID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Title NVARCHAR(255),
    Skills NVARCHAR(MAX),
    ExperienceYears INT DEFAULT 0,
    Education NVARCHAR(MAX),
    CVPath VARCHAR(500),
    LocationID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- =============================================
-- Table: Jobs
-- =============================================
CREATE TABLE Jobs (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    RecruiterID INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Requirements NVARCHAR(MAX),
    SalaryMin DECIMAL(15,2),
    SalaryMax DECIMAL(15,2),
    LocationID INT,
    CategoryID INT,
    EmploymentType VARCHAR(50) CHECK (EmploymentType IN ('FULL_TIME', 'PART_TIME', 'CONTRACT', 'INTERNSHIP', 'REMOTE')),
    PostedDate DATETIME DEFAULT GETDATE(),
    ExpiredDate DATETIME,
    Status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (Status IN ('ACTIVE', 'CLOSED', 'DRAFT')),
    FOREIGN KEY (RecruiterID) REFERENCES RecruiterProfiles(RecruiterID),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (CategoryID) REFERENCES JobCategories(CategoryID)
);

-- =============================================
-- Table: Applications
-- =============================================
CREATE TABLE Applications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    JobID INT NOT NULL,
    JobSeekerID INT NOT NULL,
    AppliedDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'PENDING' CHECK (Status IN ('PENDING', 'REVIEWING', 'ACCEPTED', 'REJECTED')),
    CoverLetter NVARCHAR(MAX),
    CVPath VARCHAR(500),
    UNIQUE (JobID, JobSeekerID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
    FOREIGN KEY (JobSeekerID) REFERENCES JobSeekerProfiles(JobSeekerID)
);

-- =============================================
-- Table: SavedJobs
-- =============================================
CREATE TABLE SavedJobs (
    SavedID INT IDENTITY(1,1) PRIMARY KEY,
    JobID INT NOT NULL,
    JobSeekerID INT NOT NULL,
    SavedDate DATETIME DEFAULT GETDATE(),
    UNIQUE (JobID, JobSeekerID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
    FOREIGN KEY (JobSeekerID) REFERENCES JobSeekerProfiles(JobSeekerID)
);

GO
PRINT 'Schema created successfully!';
