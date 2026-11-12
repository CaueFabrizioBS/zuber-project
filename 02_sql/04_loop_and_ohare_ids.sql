-- Task 4: What are the ids of the Loop and O'Hare neighborhoods?
--
-- We need these two ids to isolate the rides from downtown (Loop)
-- to the airport (O'Hare) in the last query.
--
-- The apostrophe in O'Hare is doubled so SQL reads it as part of the text
-- instead of the end of it.

SELECT
    neighborhood_id,
    name
FROM
    neighborhoods
WHERE
    name LIKE '%O''Hare%' OR name LIKE '%Loop%';

-- Result: Loop = 50, O'Hare = 63
