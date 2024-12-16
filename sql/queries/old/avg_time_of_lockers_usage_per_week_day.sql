SELECT CASE EXTRACT(DOW FROM date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        ELSE 'Unknown'
    END AS day_of_week,
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
       )                      AS avg_time_of_lockers_usage
FROM "LockerUsageHistory"
GROUP BY day_of_week
ORDER BY avg_time_of_lockers_usage DESC;
