DROP SCHEMA IF EXISTS mountaineering_schema CASCADE;
CREATE SCHEMA mountaineering_schema;
SET search_path TO mountaineering_schema;

DROP TABLE IF EXISTS Countries CASCADE;
CREATE TABLE Countries (
  CountryID SERIAL PRIMARY KEY,
  country_name TEXT NOT NULL
);

DROP TABLE IF EXISTS Areas CASCADE;
CREATE TABLE Areas (
  AreaID SERIAL PRIMARY KEY,
  area_name TEXT NOT NULL,
  CountryID INTEGER REFERENCES Countries(CountryID) NOT NULL
);

DROP TABLE IF EXISTS Cities CASCADE;
CREATE TABLE Cities (
  CityID SERIAL PRIMARY KEY,
  city_name TEXT NOT NULL,
  AreaID INTEGER REFERENCES Areas(AreaID) NOT NULL
);

DROP TABLE IF EXISTS Streets CASCADE;
CREATE TABLE Streets (
  StreetID SERIAL PRIMARY KEY,
  street_name TEXT NOT NULL,
  street_number integer NOT NULL,
  CityID INTEGER REFERENCES Cities(CityID) NOT NULL,
  CountryID INTEGER REFERENCES Countries(CountryID) NOT NULL
);

DROP TABLE IF EXISTS Climbers CASCADE;
CREATE TABLE Climbers (
  ClimberID SERIAL PRIMARY KEY,
  firstname TEXT NOT NULL,
  lastname TEXT NOT NULL
);

DROP TABLE IF EXISTS Climbers_Countries CASCADE;
CREATE TABLE Climbers_Countries (
  ClimberCountryID SERIAL PRIMARY KEY,
  ClimberID INTEGER REFERENCES Climbers(ClimberID) NOT NULL,
  CountryID INTEGER REFERENCES Countries(CountryID) NOT NULL
);

DROP TABLE IF EXISTS Mountains CASCADE;
CREATE TABLE Mountains (
  MountainID SERIAL PRIMARY KEY,
  mountain_name TEXT NOT NULL,
  Height INTEGER NOT NULL,
  CountryID INTEGER REFERENCES Countries(CountryID) NOT NULL,
  AreaID INTEGER REFERENCES Areas(AreaID) NOT NULL
);

DROP TABLE IF EXISTS Climbing_Events CASCADE;
CREATE TABLE Climbing_Events (
  EventID SERIAL PRIMARY KEY,
  StartDate DATE not null,
  EndDate DATE not null CHECK (EndDate > StartDate),
  MountainID INTEGER REFERENCES Mountains(MountainID) NOT NULL,
  duration INTERVAL GENERATED ALWAYS AS ((EndDate - StartDate) * interval '1 day') STORED
);

DROP TABLE IF EXISTS Climbers_Events CASCADE;
CREATE TABLE Climbers_Events (
  ClimberEventID SERIAL PRIMARY KEY,
  ClimberID INTEGER REFERENCES Climbers(ClimberID) NOT NULL,
  EventID INTEGER REFERENCES Climbing_Events(EventID) NOT NULL
);

DROP TABLE IF EXISTS Events_Countries CASCADE;
CREATE TABLE Events_Countries (
  EventCountryID SERIAL PRIMARY KEY,
  EventID INTEGER REFERENCES Climbing_Events(EventID) NOT NULL,
  CountryID INTEGER REFERENCES Countries(CountryID) NOT NULL
);

DROP TABLE IF EXISTS Addresses CASCADE;
CREATE TABLE Addresses (
  AddressID SERIAL PRIMARY KEY,
  ClimberID INTEGER UNIQUE REFERENCES Climbers(ClimberID) NOT NULL,
  StreetID INTEGER REFERENCES Streets(StreetID) NOT NULL,
  CityID INTEGER REFERENCES Cities(CityID) NOT NULL,
  AreaID INTEGER REFERENCES Areas(AreaID) NOT NULL,
  CountryID INTEGER REFERENCES Countries(CountryID) NOT NULL
);

ALTER TABLE Climbing_Events
ADD CONSTRAINT check_start_date
CHECK (StartDate > '2000-01-01');

ALTER TABLE Mountains
ADD CONSTRAINT check_non_negative_height
CHECK (Height >= 0);

ALTER TABLE Climbers
ADD CONSTRAINT unique_climber_name
UNIQUE (firstname, lastname);

ALTER TABLE Countries
ADD CONSTRAINT unique_country_name
UNIQUE (country_name);

ALTER TABLE Mountains
ADD CONSTRAINT unique_mountain_name
UNIQUE (mountain_name);

INSERT INTO Countries (country_name) VALUES
('Ukraine'), 
('Ecuador');

INSERT INTO Areas (area_name, CountryID) VALUES
('Zakarpattia', 1),
('Chimborazo', 2),
('Kyiv', 1),
('Cochabamba', 2);

INSERT INTO Cities (city_name, AreaID) VALUES
('Lazeshchyna', 1),
('Urbina', 2),
('Kyiv', 3),
('Cochabamba', 4);

INSERT INTO Streets (street_name, street_number, CityID, CountryID) VALUES
('Pivnichna', 28, 3, 1),
('Ayopaya', 327, 4, 2);

INSERT INTO Mountains (mountain_name, Height, CountryID, AreaID) VALUES
('Hoverla', 2061, 1, 1),
('Chimborazo', 4118, 2, 2);

INSERT INTO Climbers (firstname, lastname) VALUES
('Artur', 'Podpalov'),
('Jack', 'Cooper');

INSERT INTO Climbing_Events (StartDate, EndDate, MountainID) VALUES
('2006-02-17', '2006-02-26', 1),
('2018-06-09', '2018-06-19', 2);

INSERT INTO Climbers_Events (ClimberID, EventID) VALUES
(1, 1),
(2, 2);

INSERT INTO Events_Countries (EventID, CountryID) VALUES
(1, 1),
(2, 2);

INSERT INTO Addresses (ClimberID, StreetID, CityID, AreaID, CountryID) VALUES
(1, 1, 3, 3, 1),
(2, 2, 4, 4, 2);

INSERT INTO Climbers_Countries (ClimberID, CountryID) VALUES
(1, 1),
(2, 2); 

ALTER TABLE Countries
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Areas
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Cities
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Streets
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Climbers
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Climbers_Countries
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Mountains
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Climbing_Events
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Climbers_Events
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Events_Countries
ADD COLUMN record_ts DATE DEFAULT current_date;

ALTER TABLE Addresses
ADD COLUMN record_ts DATE DEFAULT current_date;

