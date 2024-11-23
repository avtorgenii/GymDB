
EXPLAIN
SELECT "DepartmentLocation".name as department,
       "TrainingType".name as training_name,
       COUNT(*) as number_trainers
FROM "Trainer" LEFT JOIN public."Manager" M on "Trainer".addedby = M.managerid
               LEFT JOIN "DepartmentLocation" ON M.managerid = "DepartmentLocation".managedby
               RIGHT JOIN "TrainerQualifications" ON "Trainer".trainerid = "TrainerQualifications".trainerid
               LEFT JOIN "TrainingType" ON "TrainerQualifications".trainingtypeid = "TrainingType".id
GROUP BY department, training_name
ORDER BY department, number_trainers