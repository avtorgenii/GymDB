SELECT "DepartmentLocation".name as department,
       CONCAT("User".firstname, ' ', "User".lastname) as trainer_name,
       DATE_TRUNC('month', "Availability".date) as year_month,
       SUM(EXTRACT(EPOCH FROM (endtime - starttime)) / 3600) AS total_hours
FROM "Availability" LEFT JOIN "Trainer" ON "Availability".trainerid = "Trainer".trainerid
        LEFT JOIN "User" ON "Trainer".userid = "User".id
        LEFT JOIN "Manager" On "Trainer".addedby = "Manager".managerid
        LEFT JOIN "DepartmentLocation" ON "Manager".managerid = "DepartmentLocation".managedby
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3