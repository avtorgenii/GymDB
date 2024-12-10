SELECT C.clientid,
       TO_CHAR(
               INTERVAL '1 second' * AVG(
                       CASE
                           WHEN endtime < starttime THEN
                               EXTRACT(EPOCH FROM (endtime)) + 86400 - EXTRACT(EPOCH FROM (starttime))
                           ELSE
                               EXTRACT(EPOCH FROM (endtime - starttime))
                           END
                                     ),
               'HH24:MI:SS'
       ) AS avg_time_of_lockers_usage
FROM "LockerUsageHistory"
         INNER JOIN
     "Client" C
     ON C.clientid = "LockerUsageHistory".clientid
GROUP BY C.clientid
ORDER BY C.clientid;
