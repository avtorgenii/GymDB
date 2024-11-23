-- Number of clients attended each training_type per month
SELECT TT.name as training_name,
       DATE_TRUNC('month', "Training".date) as year_month,
       COUNT(*)
FROM "TrainingAttendance" LEFT JOIN "Training" ON "TrainingAttendance".trainingid = "Training".id
                          LEFT JOIN public."TrainingType" TT on "Training".trainingtypeid = TT.id
GROUP BY training_name, year_month
ORDER BY training_name, year_month DESC