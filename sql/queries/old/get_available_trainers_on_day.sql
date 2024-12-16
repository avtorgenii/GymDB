-- get trainers available on certain date
EXPLAIN
SELECT U.firstname,
       U.lastname,
       "Availability".starttime,
       "Availability".endtime
FROM "Availability" LEFT JOIN "Trainer" T on "Availability".trainerid = T.trainerid
                    LEFT JOIN public."User" U on T.userid = U.id
WHERE date = '2024-11-05'
ORDER BY starttime, endtime;
