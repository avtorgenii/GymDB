-- How many equipment pieces of every name cannot be repaired
SELECT name,
       status,
       COUNT(*) number
FROM "Equipment" RIGHT JOIN "Fault" ON "Equipment".id = "Fault".equipmentid
WHERE status = 'Cannot Be Repaired'
GROUP BY name, status
ORDER BY name, number DESC;