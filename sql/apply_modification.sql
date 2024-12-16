CREATE TABLE IF NOT EXISTS "LockerUsageHistory" (
    ID SERIAL PRIMARY KEY,
    Date DATE not null default current_date,
    StartTime TIME not null default current_time,
    EndTime TIME,
    LockerID INT not null,
    ClientID INT not null,
    FOREIGN KEY (LockerID) REFERENCES "Locker"(ID) ON DELETE SET NULL ,
    FOREIGN KEY (ClientID) REFERENCES "User"(ID) ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS "UserTypes" (
    ID SERIAL PRIMARY KEY,
    Type VARCHAR(50)
);


ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "TypeId" INT,
ADD CONSTRAINT "User_typeid_fkey" FOREIGN KEY ("TypeId")
REFERENCES "UserTypes" (ID);


ALTER TABLE "Manager"
DROP CONSTRAINT IF EXISTS "Manager_addedby_fkey";

ALTER TABLE "Technician"
DROP CONSTRAINT IF EXISTS "Technician_addedby_fkey";

ALTER TABLE "Trainer"
DROP CONSTRAINT IF EXISTS "Trainer_addedby_fkey";


-- Dropping old constraints
ALTER TABLE "TrainerQualifications"
DROP CONSTRAINT IF EXISTS "TrainerQualifications_trainerid_fkey";

ALTER TABLE "Availability"
DROP CONSTRAINT IF EXISTS "Availability_trainerid_fkey";

ALTER TABLE "DepartmentLocation"
DROP CONSTRAINT IF EXISTS "DepartmentLocation_managedby_fkey";

ALTER TABLE "Fault"
DROP CONSTRAINT IF EXISTS "Fault_addedby_fkey";
ALTER TABLE "Fault"
DROP CONSTRAINT IF EXISTS "Fault_handledby_fkey";

ALTER TABLE "LockerUsageHistory"
DROP CONSTRAINT IF EXISTS "LockerUsageHistory_clientid_fkey";

ALTER TABLE "Training"
DROP CONSTRAINT IF EXISTS "Training_manager_fkey";
ALTER TABLE "Training"
DROP CONSTRAINT IF EXISTS "Training_trainer_fkey";

ALTER TABLE "TrainingAttendance"
DROP CONSTRAINT IF EXISTS "TrainingAttendance_clientid_fkey";

ALTER TABLE "Membership"
DROP CONSTRAINT IF EXISTS "Membership_ownedby_fkey";

--Updating user ids and references
UPDATE "Membership"
SET OwnedBy = (
    SELECT "userid"
    FROM "Client"
    WHERE "Client"."clientid" = "Membership"."ownedby"
);

UPDATE "Training"
SET Manager = (
    SELECT "userid"
    FROM "Manager"
    WHERE "Manager"."managerid" = "Training"."manager"
);

UPDATE "Training"
SET Trainer = (
    SELECT "userid"
    FROM "Trainer"
    WHERE "Trainer"."trainerid" = "Training"."trainer"
);

UPDATE "Fault"
SET HandledBy = (
    SELECT "userid"
    FROM "Technician"
    WHERE "Technician"."technicianid" = "Fault"."handledby"
);

UPDATE "Fault"
SET AddedBy = (
    SELECT "userid"
    FROM "Manager"
    WHERE "Manager"."managerid" = "Fault"."addedby"
);

UPDATE "DepartmentLocation"
SET ManagedBy = (
    SELECT "userid"
    FROM "Manager"
    WHERE "Manager"."managerid" = "DepartmentLocation"."managedby"
);

UPDATE "Availability"
SET TrainerID = (
    SELECT "userid"
    FROM "Trainer"
    WHERE "Trainer"."trainerid" = "Availability"."trainerid"
);

UPDATE "TrainerQualifications"
SET TrainerID = (
    SELECT "userid"
    FROM "Trainer"
    WHERE "Trainer"."trainerid" = "TrainerQualifications"."trainerid"
);

UPDATE "LockerUsageHistory"
SET ClientID = (
    SELECT "userid"
    FROM "Client"
    WHERE "Client"."clientid" = "LockerUsageHistory"."clientid"
);

UPDATE "TrainingAttendance"
SET ClientID = (
    SELECT "userid"
    FROM "Client"
    WHERE "Client"."clientid" = "TrainingAttendance"."clientid"
);


-- Creating new constraints
ALTER TABLE "TrainerQualifications"
ADD CONSTRAINT "TrainerQualifications_trainerid_fkey" FOREIGN KEY ("trainerid")
REFERENCES "User" (ID);


ALTER TABLE "Availability"
ADD CONSTRAINT "Availability_trainerid_fkey" FOREIGN KEY ("trainerid")
REFERENCES "User" (ID);


ALTER TABLE "DepartmentLocation"
ADD CONSTRAINT "DepartmentLocation_managedby_fkey" FOREIGN KEY ("managedby")
REFERENCES "User" (ID);


ALTER TABLE "Fault"
ADD CONSTRAINT "Fault_addedby_fkey" FOREIGN KEY ("addedby")
REFERENCES "User" (ID);


ALTER TABLE "Fault"
ADD CONSTRAINT "Fault_handledby_fkey" FOREIGN KEY ("handledby")
REFERENCES "User" (ID);


ALTER TABLE "LockerUsageHistory"
ADD CONSTRAINT "LockerUsageHistory_clientid_fkey" FOREIGN KEY ("clientid")
REFERENCES "User" (ID);

ALTER TABLE "Training"
ADD CONSTRAINT "Training_manager_fkey" FOREIGN KEY ("manager")
REFERENCES "User" (ID);


ALTER TABLE "Training"
ADD CONSTRAINT "Training_trainer_fkey" FOREIGN KEY ("trainer")
REFERENCES "User" (ID);


ALTER TABLE "TrainingAttendance"
ADD CONSTRAINT "TrainingAttendance_clientid_fkey" FOREIGN KEY ("clientid")
REFERENCES "User" (ID);

ALTER TABLE "Membership"
ADD CONSTRAINT "Membership_ownedby_fkey" FOREIGN KEY ("ownedby")
REFERENCES "User" (ID);

DROP TABLE IF EXISTS "Administrator";
DROP TABLE IF EXISTS "Client";
DROP TABLE IF EXISTS "Trainer";
DROP TABLE IF EXISTS "Technician";
DROP TABLE IF EXISTS "Manager";
