-- Task 2: How many rides did the "Yellow" and "Blue" companies get
-- in the first week of November 2017?
--
-- Several taxi companies in Chicago carry Yellow or Blue in their name.
-- Here we count the rides of each one from November 1 to 7.
--
-- Two details worth noticing:
--   * start_ts has date and time, so we cast it to date. Otherwise
--     November 7 would stop counting at midnight.
--   * The two name conditions sit inside parentheses. AND runs before OR,
--     so without them every "Blue" ride would come in, whatever the date.

SELECT
    cabs.company_name AS company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM
    cabs
    INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE
    (trips.start_ts::date BETWEEN '2017-11-01' AND '2017-11-07')
    AND
    (cabs.company_name ILIKE '%Yellow%' OR cabs.company_name ILIKE '%Blue%')
GROUP BY
    cabs.company_name;

-- Result:
--   Blue Diamond                         6,764
--   Blue Ribbon Taxi Association Inc.   17,675
--   Taxi Affiliation Service Yellow     29,213
--   Yellow Cab                          33,668
