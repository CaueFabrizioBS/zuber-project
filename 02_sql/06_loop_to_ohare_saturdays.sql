-- Task 6: Saturday rides from the Loop to O'Hare, with the weather at the time
--
-- This is the table behind the hypothesis test: does rain change how long
-- the ride to the airport takes? The result of this query is the file
-- data/project_sql_result_07.csv used in the analysis notebook.
--
-- A few details:
--   * trips and weather_records have no direct link, but both timestamps
--     are rounded to the hour, so we can join them on start_ts = ts.
--   * INNER JOIN already drops the rides that have no weather record.
--   * EXTRACT(DOW ...) returns the day of the week as a number.
--     Sunday is 0, so Saturday is 6.

SELECT
    trips.start_ts,
    CASE
        WHEN weather_records.description LIKE '%rain%'
            OR weather_records.description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions,
    trips.duration_seconds
FROM
    trips
    INNER JOIN weather_records ON trips.start_ts = weather_records.ts
WHERE
    trips.pickup_location_id = 50
    AND trips.dropoff_location_id = 63
    AND EXTRACT(DOW FROM trips.start_ts) = 6
ORDER BY
    trips.trip_id;
