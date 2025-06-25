
-- Create Rangers Table
CREATE Table rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region TEXT
);

-- Create Species Table
CREATE Table species (
    species_id SERIAL PRIMARY KEY UNIQUE,
    common_name VARCHAR(50) NOT NULL,
    scientific_name TEXT NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status TEXT NOT NULL CHECK (conservation_status IN ('Endangered', 'Vulnerable', 'Historic'))
);

--  Create Sightings Table
CREATE Table sightings (
    sighting_id SERIAL PRIMARY KEY UNIQUE,
    ranger_id INTEGER REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    species_id INTEGER REFERENCES species(species_id) ON DELETE CASCADE,
    sighting_time TIMESTAMP NOT NULL,
    location TEXT,
    notes TEXT
);

-- Insert the data in Rengers table
INSERT INTO rangers (ranger_id, name, region) 
VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

-- Insert the data in Species table
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) 
VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Insert the data in Sighting table
INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) 
VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- Execute all the tables
SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;

-- Drop all the tables if the table are exist in db
-- DROP TABLE IF EXISTS sightings;
-- DROP TABLE IF EXISTS species;
-- DROP TABLE IF EXISTS rangers;


-- Problem 1: Insert new value in Rangers table
INSERT INTO rangers (ranger_id, name, region)
VALUES (4, 'Derek Fox', 'Coastal Plains');

INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');


-- Problem 2: Count unique species ever sighted
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;


-- Problem 3: Find all sightings where the location includes "Pass".
SELECT *  
FROM sightings
WHERE location ILIKE '%pass%';


-- Problem 4: List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name
ORDER BY r.name;


-- Problem 5: List species that have never been sighted.
SELECT common_name
FROM species sp
WHERE NOT EXISTS (
    SELECT *
    FROM sightings si
    WHERE si.species_id = sp.species_id
);

 
-- Problem 6: Show the most recent 2 sightings.
SELECT sp.common_name, si.sighting_time, r.name
FROM sightings si
JOIN species sp ON si.species_id = sp.species_id
JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;



-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
    set conservation_status = 'Historic'
    WHERE discovery_date < '1800-01-01';



-- Problem 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT sighting_id,
    CASE
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;



-- Problem 9: Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);
