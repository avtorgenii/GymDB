-- Users Table
CREATE TABLE "User" (
    ID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    Password VARCHAR(255),
    RegistrationDate DATE,
    AccountDeletionDate DATE
);

-- Admin Table (References User.ID)
CREATE TABLE "Admin" (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES "User" (ID) ON DELETE CASCADE
);

-- Manager Table (References User.ID, CreatedByUserID references User.ID)
CREATE TABLE "Manager" (
    UserID INT PRIMARY KEY,
    CreatedByUserID INT,
    FOREIGN KEY (UserID) REFERENCES "User" (ID) ON DELETE CASCADE,
    FOREIGN KEY (CreatedByUserID) REFERENCES "User" (ID) ON DELETE SET NULL
);

-- Technician Table (References User.ID, CreatedByUserID references User.ID)
CREATE TABLE "Technician" (
    UserID INT PRIMARY KEY,
    CreatedByUserID INT,
    FOREIGN KEY (UserID) REFERENCES "User" (ID) ON DELETE CASCADE,
    FOREIGN KEY (CreatedByUserID) REFERENCES "User" (ID) ON DELETE SET NULL
);

-- Trainer Table (References User.ID, CreatedByUserID references User.ID)
CREATE TABLE "Trainer" (
    UserID INT PRIMARY KEY,
    CreatedByUserID INT,
    FOREIGN KEY (UserID) REFERENCES "User" (ID) ON DELETE CASCADE,
    FOREIGN KEY (CreatedByUserID) REFERENCES "User" (ID) ON DELETE SET NULL
);

-- Client Table (References User.ID)
CREATE TABLE "Client" (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES "User" (ID) ON DELETE CASCADE
);

-- DepartmentLocation Table (References Manager.User.ID)
CREATE TABLE "DepartmentLocation" (
    ID SERIAL PRIMARY KEY,
    ManagerUserID INT,
    Address VARCHAR(255),
    FOREIGN KEY (ManagerUserID) REFERENCES "Manager" (UserID) ON DELETE SET NULL
);

-- Hall Table (References DepartmentLocation.ID)
CREATE TABLE "Hall" (
    ID SERIAL PRIMARY KEY,
    DepartmentLocationID INT,
    Name VARCHAR(100),
    FOREIGN KEY (DepartmentLocationID) REFERENCES "DepartmentLocation" (ID) ON DELETE CASCADE
);

-- EquipmentCategory Table
CREATE TABLE "EquipmentCategory" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(100)
);

-- Equipment Table (References Hall.ID, EquipmentCategory.ID)
CREATE TABLE "Equipment" (
    ID SERIAL PRIMARY KEY,
    HallID INT,
    Name VARCHAR(100),
    EquipmentCategoryID INT,
    FOREIGN KEY (HallID) REFERENCES "Hall" (ID) ON DELETE CASCADE,
    FOREIGN KEY (EquipmentCategoryID) REFERENCES "EquipmentCategory" (ID) ON DELETE CASCADE
);

-- Fault Table (References Technician.User.ID, Manager.User.ID, Equipment.ID)
CREATE TABLE "Fault" (
    ID SERIAL PRIMARY KEY,
    TechnicianUserID INT,
    ManagerUserID INT,
    EquipmentID INT,
    Description TEXT,
    Status VARCHAR(50),
    FOREIGN KEY (TechnicianUserID) REFERENCES "Technician" (UserID) ON DELETE SET NULL,
    FOREIGN KEY (ManagerUserID) REFERENCES "Manager" (UserID) ON DELETE SET NULL,
    FOREIGN KEY (EquipmentID) REFERENCES "Equipment" (ID) ON DELETE CASCADE
);

-- LockerRoom Table (References DepartmentLocation.ID)
CREATE TABLE "LockerRoom" (
    ID SERIAL PRIMARY KEY,
    DepartmentLocationID INT,
    FOREIGN KEY (DepartmentLocationID) REFERENCES "DepartmentLocation" (ID) ON DELETE CASCADE
);

-- Locker Table (References LockerRoom.ID, OccupiedBy references Client.UserID)
CREATE TABLE "Locker" (
    ID SERIAL PRIMARY KEY,
    LockerRoomID INT,
    Status VARCHAR(50),
    OccupiedBy INT,
    FOREIGN KEY (LockerRoomID) REFERENCES "LockerRoom" (ID) ON DELETE CASCADE,
    FOREIGN KEY (OccupiedBy) REFERENCES "Client" (UserID) ON DELETE SET NULL
);

-- Offer Table
CREATE TABLE "Offer" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT,
    Price NUMERIC(10, 2),
    Duration INT -- Duration in days
);

-- Membership Table (References Client.User.ID, Offer.ID)
CREATE TABLE "Membership" (
    ID SERIAL PRIMARY KEY,
    ClientUserID INT,
    OfferID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ClientUserID) REFERENCES "Client" (UserID) ON DELETE CASCADE,
    FOREIGN KEY (OfferID) REFERENCES "Offer" (ID) ON DELETE CASCADE
);

-- Availability Table (References Trainer.User.ID)
CREATE TABLE "Availability" (
    ID SERIAL PRIMARY KEY,
    TrainerUserID INT,
    Date DATE,
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (TrainerUserID) REFERENCES "Trainer" (UserID) ON DELETE CASCADE
);

-- TrainingType Table
CREATE TABLE "TrainingType" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT
);

-- TrainersAndTrainingTypes Table (References Trainer.User.ID, TrainingType.ID)
CREATE TABLE "TrainersAndTrainingTypes" (
    TrainerUserID INT,
    TrainingTypeID INT,
    PRIMARY KEY (TrainerUserID, TrainingTypeID),
    FOREIGN KEY (TrainerUserID) REFERENCES "Trainer" (UserID) ON DELETE CASCADE,
    FOREIGN KEY (TrainingTypeID) REFERENCES "TrainingType" (ID) ON DELETE CASCADE
);

-- Training Table (References Trainer.User.ID, Manager.User.ID, TrainingType.ID, Hall.ID)
CREATE TABLE "Training" (
    ID SERIAL PRIMARY KEY,
    TrainerUserID INT,
    Date DATE,
    StartTime TIME,
    EndTime TIME,
    ManagerUserID INT,
    TrainingTypeID INT,
    HallID INT,
    FOREIGN KEY (TrainerUserID) REFERENCES "Trainer" (UserID) ON DELETE CASCADE,
    FOREIGN KEY (ManagerUserID) REFERENCES "Manager" (UserID) ON DELETE SET NULL,
    FOREIGN KEY (TrainingTypeID) REFERENCES "TrainingType" (ID) ON DELETE CASCADE,
    FOREIGN KEY (HallID) REFERENCES "Hall" (ID) ON DELETE CASCADE
);

-- TrainingAttendance Table (References Training.ID, Client.User.ID)
CREATE TABLE "TrainingAttendance" (
    ID SERIAL PRIMARY KEY,
    TrainingID INT,
    ClientUserID INT,
    FOREIGN KEY (TrainingID) REFERENCES "Training" (ID) ON DELETE CASCADE,
    FOREIGN KEY (ClientUserID) REFERENCES "Client" (UserID) ON DELETE CASCADE
);
