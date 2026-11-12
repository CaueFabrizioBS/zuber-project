-- Task 5: Was the weather good or bad at each hour?
--
-- The description field has many variations ("light rain", "broken clouds"...).
-- For the hypothesis test we only need two groups: "Bad" when it mentions
-- rain or storm, "Good" for everything else.

SELECT
    ts,
    CASE
        WHEN description LIKE '%rain%' OR description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions
FROM
    weather_records;
