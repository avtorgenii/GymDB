SELECT U.firstname,
       U.lastname,
       "Availability".starttime,
       "Availability".endtime
FROM "Availability" LEFT JOIN "User" T on "Availability".trainerid = T.id
                    LEFT JOIN public."User" U on T.id = U.id
WHERE date = '2024-11-05'
ORDER BY starttime, endtime;