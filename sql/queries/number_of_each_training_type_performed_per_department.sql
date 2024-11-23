SELECT "DepartmentLocation".name as department,
       "TrainingType".name as training,
       COUNT(*) as trainings_amount
FROM "Training" LEFT JOIN "TrainingType" ON "Training".trainingtypeid = "TrainingType".id
                LEFT JOIN "Hall" ON "Training".hallid = "Hall".id
                LEFT JOIN "DepartmentLocation" ON "Hall".departmentlocationid = "DepartmentLocation".id
GROUP BY 1, 2
ORDER BY 1, 2
