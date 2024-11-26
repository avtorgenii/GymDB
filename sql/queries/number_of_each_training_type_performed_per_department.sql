--Number of training type performed per department
EXPLAIN
SELECT "DepartmentLocation".name as department,
       "TrainingType".name as training,
       COUNT(*) as trainings_amount
FROM "Training" LEFT JOIN "TrainingType" ON "Training".trainingtypeid = "TrainingType".id
                LEFT JOIN "Hall" ON "Training".hallid = "Hall".id
                LEFT JOIN "DepartmentLocation" ON "Hall".departmentlocationid = "DepartmentLocation".id
GROUP BY department, training
ORDER BY department, training
