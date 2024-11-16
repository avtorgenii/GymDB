-- How many equipment pieces of every name cannot be repaired

SELECT name,
       status,
       COUNT(*) number
FROM "Equipment" RIGHT JOIN "Fault" ON "Equipment".id = "Fault".equipmentid
WHERE status = 'Cannot Be Repaired'
GROUP BY 1, 2
ORDER BY 1, 3 DESC;