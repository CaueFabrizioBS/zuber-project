-- Task 1: Which taxi companies got the most rides on November 15 and 16, 2017?
--
-- This is our first look at the competition: one row per company,
-- busiest first. The result of this query is the file
-- data/project_sql_result_01.csv used in the analysis notebook.
--
-- start_ts has date and time, so we cast it to date. Otherwise
-- November 16 would stop counting at midnight.

SELECT
    cabs.company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM
    cabs
    INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE
    trips.start_ts::date BETWEEN '2017-11-15' AND '2017-11-16'
GROUP BY
    cabs.company_name
ORDER BY
    trips_amount DESC;
