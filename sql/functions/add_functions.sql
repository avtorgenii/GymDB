-- Get trainings attendance by department
CREATE FUNCTION get_trainings_attendance(in_date date, department INT)
RETURNS TABLE(training_name VARCHAR, training_date DATE, num_clients BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT "TrainingType".name,
            in_date,
           COUNT(*)
    FROM "Training" LEFT JOIN "TrainingType" ON "Training".trainingtypeid = "TrainingType".id
        LEFT JOIN "TrainingAttendance" ON "Training".id = "TrainingAttendance".trainingid
        LEFT JOIN "Hall" ON "Training".hallid = "Hall".id
    WHERE "Training".date = in_date AND "Hall".departmentlocationid = department
    GROUP BY 1, 2
    ORDER BY 1, 2;
END;
$$ LANGUAGE plpgsql;


-- Get number of reported faults per department in selected dates range
CREATE FUNCTION get_num_fault_reports(start_date date, end_date date)
RETURNS TABLE(department VARCHAR, faults BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT "DepartmentLocation".name,
           COUNT(*)
    FROM "Fault" LEFT JOIN "Equipment" ON "Fault".equipmentid = "Equipment".id
        LEFT JOIN "Hall" ON "Equipment".hallid = "Hall".id
        LEFT JOIN "DepartmentLocation" ON "Hall".departmentlocationid = "DepartmentLocation".id
    WHERE "Fault".datereported BETWEEN start_date AND end_date
    GROUP BY 1
    ORDER BY 2 DESC, 1;
END;
$$ LANGUAGE plpgsql;

-- Get clients which were registered n years ago and are active
CREATE FUNCTION get_active_clients_registered_n_years_ago(years_ago INT)
RETURNS TABLE(client_id INT, registration_date date) AS $$
BEGIN
    RETURN QUERY
    SELECT "Client".clientid,
            "User".registrationdate::date
    FROM "Client" LEFT JOIN "User" ON "Client".userid = "User".id
    WHERE "User".isactive = TRUE AND EXTRACT(YEAR FROM AGE(NOW(), "User".registrationdate)) > years_ago
    ORDER BY "User".registrationdate;
END;
$$ LANGUAGE plpgsql;