
-- Create Rangers Table
CREATE Table rangers (
    rangers_id SERIAL PRIMARY KEY,
    rangers_name VARCHAR(50) NOT NULL,
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
    ranger_id INTEGER REFERENCES rangers(rangers_id) ON DELETE CASCADE,
    species_id INTEGER REFERENCES species(species_id) ON DELETE CASCADE,
    sighting_time DATE NOT NULL,
    location TEXT,
    note TEXT
);

SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;