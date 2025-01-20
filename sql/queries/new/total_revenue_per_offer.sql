EXPLAIN
SELECT "Offer".name AS name,
       SUM("Offer".price) AS total_revenue
FROM "Membership"
         LEFT JOIN "Offer" ON "Membership".offerid = "Offer".id
         LEFT JOIN "Client" ON "Membership".ownedby = "Client".clientid
GROUP BY "Offer".id
ORDER BY total_revenue DESC;