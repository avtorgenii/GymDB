SELECT DL.name as department_name,
       LR.type as sex,
       COUNT(*) as num_free
FROM "Locker" LEFT JOIN "LockerRoom" LR ON "Locker".lockerroomid = LR.id LEFT JOIN public."DepartmentLocation" DL on LR.departmentlocationid = DL.id
WHERE "Locker".status = 'Free'
GROUP BY DL.name, LR.type
ORDER BY 1