-- Task 3: How do the two most popular companies compare with everyone else?
--
-- Flash Cab and Taxi Affiliation Services lead the market. Here we keep
-- them as they are and put every other company into a single "Other" group,
-- for the week of November 1 to 7, 2017.
--
-- The names are matched with = on purpose. There is another company called
-- "Taxi Affiliation Service Yellow", and a LIKE pattern would mix it in.

SELECT
    CASE
        WHEN cabs.company_name = 'Flash Cab' THEN 'Flash Cab'
        WHEN cabs.company_name = 'Taxi Affiliation Services' THEN 'Taxi Affiliation Services'
        ELSE 'Other'
    END AS company,
    COUNT(trips.trip_id) AS trips_amount
FROM
    cabs
    INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE
    trips.start_ts::date BETWEEN '2017-11-01' AND '2017-11-07'
GROUP BY
    company
ORDER BY
    trips_amount DESC;
