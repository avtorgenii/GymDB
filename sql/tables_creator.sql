CREATE TABLE "User" (
    ID SERIAL PRIMARY KEY,
    Email VARCHAR(100) UNIQUE not null CHECK (Email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Phone VARCHAR(25) UNIQUE CHECK (Phone ~* '^\+?[1-9]\d{1,14}$' OR Phone IS NULL),
    Password VARCHAR(255) not null ,
    RegistrationDate DATE DEFAULT current_date not null ,
    IsActive BOOLEAN default true not null
);

CREATE TABLE "Administrator" (
    AdministratorID SERIAL PRIMARY KEY,
    UserID INT not null,
    CreatedAt DATE DEFAULT current_date not null,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE
);

CREATE TABLE "Manager" (
    ManagerID SERIAL PRIMARY KEY,
    UserID INT not null,
    AddedBy INT,
    CreatedAt DATE DEFAULT current_date not null,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE,
    FOREIGN KEY (AddedBy) REFERENCES "Administrator"(AdministratorID) ON DELETE SET NULL
);

CREATE TABLE "Technician" (
    TechnicianID SERIAL PRIMARY KEY,
    UserID INT not null ,
    AddedBy INT,
    CreatedAt DATE DEFAULT current_date not null,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE,
    FOREIGN KEY (AddedBy) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

CREATE TABLE "Trainer" (
    TrainerID SERIAL PRIMARY KEY,
    UserID INT not null,
    AddedBy INT,
    CreatedAt DATE DEFAULT current_date not null,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE,
    FOREIGN KEY (AddedBy) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

CREATE TABLE "Client" (
    ClientID SERIAL PRIMARY KEY,
    UserID INT not null,
    FOREIGN KEY (UserID) REFERENCES "User"(ID) ON DELETE CASCADE
);

CREATE TABLE "Offer" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(50) not null,
    Description VARCHAR(255),
    Price DECIMAL not null check ( Price >= 0.00 ),
    Duration INT not null check ( Duration >= 0 ),
    AvailableToPurchase BOOLEAN not null DEFAULT true
);

CREATE TABLE "Membership" (
    ID SERIAL PRIMARY KEY,
    StartDate DATE not null default current_date,
    EndDate DATE CHECK ( EndDate >= StartDate ) not null,
    OfferID INT not null,
    OwnedBy INT not null,
    FOREIGN KEY (OfferID) REFERENCES "Offer"(ID) ON DELETE CASCADE,
    FOREIGN KEY (OwnedBy) REFERENCES "Client"(ClientID) ON DELETE CASCADE
);

CREATE TABLE "TrainingType" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(50) not null,
    Description VARCHAR(500)
);

CREATE TABLE "TrainerQualifications" (
    TrainerID INT,
    TrainingTypeID INT,
    PRIMARY KEY (TrainerID, TrainingTypeID),
    FOREIGN KEY (TrainerID) REFERENCES "Trainer"(TrainerID) ON DELETE CASCADE,
    FOREIGN KEY (TrainingTypeID) REFERENCES "TrainingType"(ID) ON DELETE CASCADE
);

CREATE TABLE "Availability" (
    ID SERIAL PRIMARY KEY,
    TrainerID INT not null,
    Date DATE not null default current_date,
    StartTime TIME not null,
    EndTime TIME CHECK ( EndTime > StartTime ) not null,
    FOREIGN KEY (TrainerID) REFERENCES "Trainer"(TrainerID) ON DELETE CASCADE
);

CREATE TABLE "DepartmentLocation" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) not null,
    City VARCHAR(255) not null,
    PostalCode VARCHAR(50) not null,
    Street VARCHAR(255) not null,
    BuildingNumber VARCHAR(10) not null,
    ManagedBy INT,
    FOREIGN KEY (ManagedBy) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

CREATE TABLE "Hall" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) not null,
    DepartmentLocationID INT not null,
    FOREIGN KEY (DepartmentLocationID) REFERENCES "DepartmentLocation"(ID) ON DELETE CASCADE
);

CREATE TABLE "Equipment" (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) not null,
    HallID INT not null,
    FOREIGN KEY (HallID) REFERENCES "Hall"(ID) ON DELETE CASCADE
);

CREATE TYPE FAULT_STATUS AS ENUM('Reported','Under Repair','Fixed','Cannot Be Repaired');

CREATE TABLE "Fault" (
    ID SERIAL PRIMARY KEY,
    Description VARCHAR(255),
    DateReported DATE not null default current_date,
    Status FAULT_STATUS not null default 'Reported',
    EquipmentID INT not null,
    HandledBy INT,
    AddedBy INT,
    FOREIGN KEY (EquipmentID) REFERENCES "Equipment"(ID) ON DELETE CASCADE,
    FOREIGN KEY (HandledBy) REFERENCES "Technician"(TechnicianID) ON DELETE SET NULL,
    FOREIGN KEY (AddedBy) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

CREATE TABLE "LockerRoom" (
    ID SERIAL PRIMARY KEY,
    Type VARCHAR(50) not null,
    DepartmentLocationID INT not null,
    FOREIGN KEY (DepartmentLocationID) REFERENCES "DepartmentLocation"(ID) ON DELETE CASCADE
);

CREATE TYPE LOCKER_STATUS AS ENUM('Free','Occupied','Not available');

CREATE TABLE "Locker" (
    ID SERIAL PRIMARY KEY,
    Number INT not null,
    Status LOCKER_STATUS not null default 'Free',
    LockerRoomID INT not null,
    OccupiedBy INT,
    FOREIGN KEY (LockerRoomID) REFERENCES "LockerRoom"(ID) ON DELETE CASCADE,
    FOREIGN KEY (OccupiedBy) REFERENCES "Membership"(ID) ON DELETE SET NULL
);

CREATE TABLE "Training" (
    ID SERIAL PRIMARY KEY,
    Date DATE not null,
    StartTime TIME not null,
    EndTime TIME CHECK ( EndTime > StartTime ),
    TrainingTypeID INT not null,
    HallID INT,
    Trainer INT,
    Manager INT,
    FOREIGN KEY (TrainingTypeID) REFERENCES "TrainingType"(ID) ON DELETE CASCADE,
    FOREIGN KEY (HallID) REFERENCES "Hall"(ID) ON DELETE SET NULL,
    FOREIGN KEY (Trainer) REFERENCES "Trainer"(TrainerID) ON DELETE SET NULL,
    FOREIGN KEY (Manager) REFERENCES "Manager"(ManagerID) ON DELETE SET NULL
);

CREATE TABLE "TrainingAttendance" (
    TrainingID INT,
    ClientID INT,
    PRIMARY KEY (TrainingID, ClientID),
    FOREIGN KEY (TrainingID) REFERENCES "Training"(ID) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES "Client"(ClientID) ON DELETE CASCADE
);
