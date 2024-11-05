-- Users Table
CREATE TABLE "User" (
    ID SERIAL PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Phone VARCHAR(15) UNIQUE,
    Password VARCHAR(255),
    RegistrationDate DATE,
    IsActive VARCHAR(10)
);

-- Administrator Table (References User.ID)
CREATE TABLE "Administrator" (
    AdministratorID SERIAL PRIMARY KEY,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE
);

-- Manager Table (References User.ID, AddedBy references User.ID)
CREATE TABLE "Manager" (
    ManagerID SERIAL PRIMARY KEY,
    UserID INT,
    AddedBy INT,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE,
    FOREIGN KEY (AddedBy) REFERENCES "Administrator"(AdministratorID) ON DELETE SET NULL
);

-- Technician Table (References User.ID, AddedBy references User.ID)
CREATE TABLE "Technician" (
    TechnicianID SERIAL PRIMARY KEY,
    UserID INT,
    AddedBy INT,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE,
    FOREIGN KEY (AddedBy) REFERENCES "User"(ID) ON DELETE SET NULL
);

-- Trainer Table (References User.ID, AddedBy references User.ID)
CREATE TABLE "Trainer" (
    TrainerID SERIAL PRIMARY KEY,
    UserID INT,
    AddedBy INT,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE,
    FOREIGN KEY (AddedBy) REFERENCES "User"(ID) ON DELETE SET NULL
);

-- Client Table (References User.ID)
CREATE TABLE "Client" (
    ClientID SERIAL PRIMARY KEY,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE
);

-- Offer Table
CREATE TABLE "Offer" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Description VARCHAR(255),
    Price FLOAT,
    Duration INT
);

-- Membership Table (References Client.ClientID, Offer.ID)
CREATE TABLE "Membership" (
    ID SERIAL PRIMARY KEY,
    StartDate DATE,
    EndDate DATE,
    OfferID INT,
    OwnedBy INT,
    FOREIGN KEY (OfferID) REFERENCES "Offer"(ID) ON DELETE CASCADE,
    FOREIGN KEY (OwnedBy) REFERENCES "Client"(ClientID) ON DELETE CASCADE
);

-- TrainingType Table
CREATE TABLE "TrainingType" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Description VARCHAR(500)
);

-- TrainerQualifications Table (References Trainer.TrainerID, TrainingType.ID)
CREATE TABLE "TrainerQualifications" (
    TrainerID INT,
    TrainingTypeID INT,
    PRIMARY KEY (TrainerID, TrainingTypeID),
    FOREIGN KEY (TrainerID) REFERENCES "Trainer"(TrainerID) ON DELETE CASCADE,
    FOREIGN KEY (TrainingTypeID) REFERENCES "TrainingType"(ID) ON DELETE CASCADE
);

-- Availability Table (References Trainer.TrainerID)
CREATE TABLE "Availability" (
    ID SERIAL PRIMARY KEY,
    TrainerID INT,
    Date DATE,
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (TrainerID) REFERENCES "Trainer"(TrainerID) ON DELETE CASCADE
);

-- DepartmentLocation Table (References Manager.ManagerID)
CREATE TABLE "DepartmentLocation" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Adress VARCHAR(255),
    ManagedBy INT,
    FOREIGN KEY (ManagedBy) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

-- Hall Table (References DepartmentLocation.ID)
CREATE TABLE "Hall" (
    ID SERIAL PRIMARY KEY,
    DepartmentLocationID INT,
    Name VARCHAR(255),
    FOREIGN KEY (DepartmentLocationID) REFERENCES "DepartmentLocation"(ID) ON DELETE CASCADE
);

-- Equipment Table (References Hall.ID)
CREATE TABLE "Equipment" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    HallID INT,
    FOREIGN KEY (HallID) REFERENCES "Hall"(ID) ON DELETE CASCADE
);

-- Fault Table (References Technician.TechnicianID, Manager.ManagerID, Equipment.ID)
CREATE TABLE "Fault" (
    ID SERIAL PRIMARY KEY,
    Description VARCHAR(255),
    Status VARCHAR(18),
    EquipmentID INT,
    HandledBy INT,
    AddedBy INT,
    FOREIGN KEY (EquipmentID) REFERENCES "Equipment"(ID) ON DELETE CASCADE,
    FOREIGN KEY (HandledBy) REFERENCES "Technician"(TechnicianID) ON DELETE SET NULL,
    FOREIGN KEY (AddedBy) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

-- LockerRoom Table (References DepartmentLocation.ID)
CREATE TABLE "LockerRoom" (
    ID SERIAL PRIMARY KEY,
    Type VARCHAR(50),
    DepartmentLocationID INT,
    FOREIGN KEY (DepartmentLocationID) REFERENCES "DepartmentLocation"(ID) ON DELETE CASCADE
);

-- Locker Table (References LockerRoom.ID, OccupiedBy references Client.ClientID)
CREATE TABLE "Locker" (
    ID SERIAL PRIMARY KEY,
    Number INT,
    Status VARCHAR(13),
    LockerRoomID INT,
    OccupiedBy INT,
    FOREIGN KEY (LockerRoomID) REFERENCES "LockerRoom"(ID) ON DELETE CASCADE,
    FOREIGN KEY (OccupiedBy) REFERENCES "Client"(ClientID) ON DELETE SET NULL
);

-- Training Table (References Trainer.TrainerID, Manager.ManagerID, TrainingType.ID, Hall.ID)
CREATE TABLE "Training" (
    ID SERIAL PRIMARY KEY,
    Date DATE,
    StartTime TIME,
    EndTime TIME,
    TrainingTypeID INT,
    HallID INT,
    TrainerID INT,
    ManagerID INT,
    FOREIGN KEY (TrainingTypeID) REFERENCES "TrainingType"(ID) ON DELETE CASCADE,
    FOREIGN KEY (HallID) REFERENCES "Hall"(ID) ON DELETE CASCADE,
    FOREIGN KEY (TrainerID) REFERENCES "Trainer"(TrainerID) ON DELETE CASCADE,
    FOREIGN KEY (ManagerID) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

-- TrainingAttendance Table (References Training.ID, Client.ClientID)
CREATE TABLE "TrainingAttendance" (
    ID SERIAL PRIMARY KEY,
    TrainingID INT,
    ClientClientID INT,
    FOREIGN KEY (TrainingID) REFERENCES "Training"(ID) ON DELETE CASCADE,
    FOREIGN KEY (ClientClientID) REFERENCES "Client"(ClientID) ON DELETE CASCADE
);
