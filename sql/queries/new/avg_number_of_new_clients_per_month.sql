SELECT EXTRACT("month" FROM sub.month_start_date) as month,
       AVG(new_clients) as new_clients
FROM
(
    SELECT DATE_TRUNC('month', registrationdate) AS month_start_date,
           COUNT(*) as new_clients
    FROM "User" INNER JOIN public."UserTypes" UT on "User"."TypeId" = UT.id
    WHERE UT.type = 'client'
    GROUP BY month_start_date
    ORDER BY month_start_date
) sub
GROUP BY month
ORDER BY month;

