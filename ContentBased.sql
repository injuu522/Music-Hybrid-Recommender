-- Authors: Injuu Jyneis, Jui Nagarkar, Adawn Symonette, & Jack Deveney
-- Title: BSAN 780 Final Project
-- Date: 03.29.2024
-- Description: This file contains SQL code content based filtering.

SELECT Name FROM Artists a 

SELECT * FROM Tags t 

SELECT * FROM user_friends uf 

SELECT * FROM UserArtists ua 

SELECT * FROM UserTaggedArtists uta 


-- Removing duplicate entries

DELETE FROM Artists
WHERE ID NOT IN (
    SELECT MIN(ID)
    FROM Artists
    GROUP BY Name
);

-- Standardizing text fields

UPDATE Artists
SET Name = UPPER(Name);

------ Encoding special characters ----------------

-- Converting the database to use UTF-8
--PRAGMA encoding = "UTF-8";

-- Changing the text columns of the table to store UTF-8 data
--ALTER TABLE Artists RENAME TO Artists_old;

--CREATE TABLE Artists_new (
-- ID INTEGER,
--  Name TEXT,
--  URL TEXT,
--  pictureURL TEXT
--);

-- The following SQL gives syntax errors

--INSERT INTO Artists_new (ID, Name, URL, pictureURL)
--SELECT ID, CONVERT(Name USING utf8mb4), URL, pictureURL
--FROM Artists_old;


-- We kept getting error trying to do the UTF-8 encoding.
-- Online resources recommend using Python for this, so we're just going to keep it as it for now
-- And convert to UTF-8 when we will use Python. 

ALTER TABLE Tags ADD COLUMN Category TEXT;


UPDATE Tags
SET Category = 'Metal'
WHERE TagValue LIKE '%metal%'
OR TagValue LIKE '%black metal%'
OR TagValue LIKE '%death metal%'
OR TagValue LIKE '%alternative metal%';


UPDATE Tags
SET Category = 'Electronic'
WHERE TagValue LIKE '%electronic%'
OR TagValue LIKE '%ambient%'
OR TagValue LIKE '%techno%'
OR TagValue LIKE '%electro%'
OR TagValue LIKE '%ebm%'
OR TagValue LIKE '%dub%'
OR TagValue LIKE '%trance%'
OR TagValue LIKE '%alternative electronic%';

UPDATE Tags
SET Category = 'Rock'
WHERE TagValue LIKE '%rock%'
OR TagValue LIKE '%punk%'
OR TagValue LIKE '%indie%'
OR TagValue LIKE '%alternative rock%';

UPDATE Tags
SET Category = 'Hip Hop and RnB'
WHERE TagValue LIKE '%hip hop%'
OR TagValue LIKE '%rap%'
OR TagValue LIKE '%hip hop%'
OR TagValue LIKE '%hop%'
OR TagValue LIKE '%r&b%'
OR TagValue LIKE '%rnb%'
OR TagValue LIKE '%urban%'
OR TagValue LIKE '%soul%'
OR TagValue LIKE '%rhythm and blues%'
OR TagValue LIKE '%alternative rap%'
OR TagValue LIKE '%alternative rnb%';

UPDATE Tags
SET Category = 'Pop'
WHERE TagValue LIKE '%pop%'
OR TagValue LIKE 'disco%'
OR TagValue LIKE '%pop music%'
OR TagValue LIKE '%2000%'
OR TagValue LIKE '%2010%'
OR TagValue LIKE '%alternative pop%';

UPDATE Tags
SET Category = 'Foreign Music'
WHERE TagValue LIKE '%foreign%'
OR TagValue LIKE '%k-pop%'
OR TagValue LIKE '%j-pop%'
OR TagValue LIKE '%french%'
OR TagValue LIKE '%german%'
OR TagValue LIKE '%spanish%'
OR TagValue LIKE '%deutsch%'
OR TagValue LIKE '%latin%'
OR TagValue LIKE '%hungarian%'
OR TagValue LIKE '%brazilian%'
OR TagValue LIKE '%australian%'
OR TagValue LIKE '%arabic%'
OR TagValue LIKE '%chilean%'
OR TagValue LIKE '%russian%'
OR TagValue LIKE '%japan%'
OR TagValue LIKE '%asian%'
OR TagValue LIKE '%canadian%'
OR TagValue LIKE '%dutch%'
OR TagValue LIKE '%italian%'
OR TagValue LIKE '%greek%'
OR TagValue LIKE '%israeli%'; 

UPDATE Tags
SET Category = 'Decades'
WHERE TagValue LIKE '%70s%'
OR TagValue LIKE '%80s%'
OR TagValue LIKE '%80%'
OR TagValue LIKE '%70%'
OR TagValue LIKE '%90s%'
OR TagValue LIKE '%60%'
OR TagValue LIKE '%1978%'
OR TagValue LIKE '%1982%'
OR TagValue LIKE '%old school%';

UPDATE Tags
SET Category = 'Classical Music'
WHERE TagValue LIKE '%classical%'
OR TagValue LIKE '%baroque%'
OR TagValue LIKE '%classic%'
OR TagValue LIKE '%symphony%'
OR TagValue LIKE '%alternative classical%';

UPDATE Tags
SET Category = 'Modern/Comptemporary'
WHERE TagValue LIKE '%funk%'
OR TagValue LIKE '%jazz%'
OR TagValue LIKE '%new age%'
OR TagValue LIKE '%dance%'
OR TagValue LIKE '%ethereal%'
OR TagValue LIKE '%alternative comptemporary%';

UPDATE Tags
SET Category = 'Country'
WHERE TagValue LIKE '%country%';


-- Set 'Other' for tags that do not match any category
UPDATE Tags
SET Category = 'Other'
WHERE Category IS NULL;

SELECT * FROM Tags t 

-- Assuming we have a table ArtistTags (ArtistID, TagID) that links artists with their tags
-- and a table UserArtists (UserID, ArtistID) that logs user artist preferences.

-- Creating a table with artists, tags and categories
-- Creating a table with artists, tags, and categories

DROP TABLE ArtistsCategories;

CREATE TABLE ArtistsCategories AS
SELECT DISTINCT a.ID, a.Name, t.TagValue, t.Category
FROM Artists a
INNER JOIN UserTaggedArtists uta ON a.ID = uta.ArtistID
INNER JOIN Tags t ON uta.TagID = t.TagID;



SELECT * FROM ArtistsCategories ac 

SELECT * FROM Artists

SELECT * FROM Tags t 

-- Content-based filtering query:
-- This query recommends artist names from the same categories as those listened to by a specific user.


-- Content-based filtering query:

--this was the first method we tried to implement where we choose the category and the name. However, we figured out that this results
-- with numerous results and there is no way to identify which result is closer to the particular user
-- this is why we chose to follow the method shown below using one hot encoding which allows us to find and recommend songs that have
-- the highest similarity scores
SELECT DISTINCT a.Name, ac.Category
FROM Artists a
JOIN ArtistsCategories ac ON a.ID = ac.ID
AND a.ID NOT IN (
    -- Excluding artists the user has already listened to
    SELECT ua.ArtistID
    FROM UserArtists ua
    WHERE ua.UserID = 3 -- Replace 7 with the specific UserID
)
ORDER BY a.Name;

-- This query recommends artist names in the "rock" category, similar to "ANYTHING BOX", that have not been listened to by the specific user.

SELECT DISTINCT a.Name, ac.Category
FROM Artists a
JOIN ArtistsCategories ac ON a.ID = ac.ID
WHERE ac.Category = 'Rock' -- Targeting only rock artists
AND ac.TagValue IN (
    SELECT ac2.TagValue
    FROM ArtistsCategories ac2
    JOIN Artists a2 ON ac2.ID = a2.ID
    WHERE a2.Name = 'COLDPLAY' -- Replace with actual artist name or ID
)
AND a.ID NOT IN (
    -- Excluding artists the user has already listened to
    SELECT ua.ArtistID
    FROM UserArtists ua
    WHERE ua.UserID = 3 -- Replace 7 with the specific UserID
)
AND a.Name != 'COLDPLAY' -- Ensuring we don't recommend the artist they've already listened to
ORDER BY a.Name;

-- In the result, we can see the same artist in several categories because one can produce songs in different categories. 

-- One hot encoding:

SELECT 
    a.Name,
    MAX(CASE WHEN ac.Category = 'Metal' THEN 1 ELSE 0 END) AS is_Metal,
    MAX(CASE WHEN ac.Category = 'Electronic' THEN 1 ELSE 0 END) AS is_Electronic,
    MAX(CASE WHEN ac.Category = 'Rock' THEN 1 ELSE 0 END) AS is_Rock,
    MAX(CASE WHEN ac.Category = 'Hip Hop and RnB' THEN 1 ELSE 0 END) AS is_HipHop_and_RnB,
    MAX(CASE WHEN ac.Category = 'Pop' THEN 1 ELSE 0 END) AS is_Pop,
    MAX(CASE WHEN ac.Category = 'Foreign Music' THEN 1 ELSE 0 END) AS is_Foreign_Music,
    MAX(CASE WHEN ac.Category = 'Decades' THEN 1 ELSE 0 END) AS is_Decades,
    MAX(CASE WHEN ac.Category = 'Classical Music' THEN 1 ELSE 0 END) AS is_Classical_Music,
    MAX(CASE WHEN ac.Category = 'Modern/Comptemporary' THEN 1 ELSE 0 END) AS is_Modern_Contemporary,
    MAX(CASE WHEN ac.Category = 'Country' THEN 1 ELSE 0 END) AS is_Country,
    MAX(CASE WHEN ac.Category = 'Other' THEN 1 ELSE 0 END) AS is_Other
FROM Artists a
JOIN ArtistsCategories ac ON a.ID = ac.ID
GROUP BY a.Name
ORDER BY a.Name;


-- Need to tie it back to the user

-- Step 1: Create a table with one-hot encoded vectors for each artist.
CREATE TABLE IF NOT EXISTS OneHotEncoding AS
SELECT 
    a.Name,
    a.ID,
    MAX(CASE WHEN ac.Category = 'Metal' THEN 1 ELSE 0 END) AS is_Metal,
    MAX(CASE WHEN ac.Category = 'Electronic' THEN 1 ELSE 0 END) AS is_Electronic,
    MAX(CASE WHEN ac.Category = 'Rock' THEN 1 ELSE 0 END) AS is_Rock,
    MAX(CASE WHEN ac.Category = 'Hip Hop and RnB' THEN 1 ELSE 0 END) AS is_HipHop_and_RnB,
    MAX(CASE WHEN ac.Category = 'Pop' THEN 1 ELSE 0 END) AS is_Pop,
    MAX(CASE WHEN ac.Category = 'Foreign Music' THEN 1 ELSE 0 END) AS is_Foreign_Music,
    MAX(CASE WHEN ac.Category = 'Decades' THEN 1 ELSE 0 END) AS is_Decades,
    MAX(CASE WHEN ac.Category = 'Classical Music' THEN 1 ELSE 0 END) AS is_Classical_Music,
    MAX(CASE WHEN ac.Category = 'Modern/Contemporary' THEN 1 ELSE 0 END) AS is_Modern_Contemporary,
    MAX(CASE WHEN ac.Category = 'Country' THEN 1 ELSE 0 END) AS is_Country,
    MAX(CASE WHEN ac.Category = 'Other' THEN 1 ELSE 0 END) AS is_Other
FROM Artists a
JOIN ArtistsCategories ac ON a.ID = ac.ID
GROUP BY a.Name, a.ID;

-- Step 2: Create a table specifically for the artist "ANYTHING BOX."
CREATE TABLE IF NOT EXISTS ArtistBox AS
SELECT * FROM OneHotEncoding WHERE Name = 'COLDPLAY';

-- Step 3: Create a table for the similarity scores.
CREATE TABLE IF NOT EXISTS Similarity AS
SELECT 
    ohe.Name,
    ohe.ID,
    (ohe.is_Metal * ab.is_Metal + 
    ohe.is_Electronic * ab.is_Electronic + 
    ohe.is_Rock * ab.is_Rock + 
    ohe.is_HipHop_and_RnB * ab.is_HipHop_and_RnB + 
    ohe.is_Pop * ab.is_Pop + 
    ohe.is_Foreign_Music * ab.is_Foreign_Music + 
    ohe.is_Decades * ab.is_Decades + 
    ohe.is_Classical_Music * ab.is_Classical_Music + 
    ohe.is_Modern_Contemporary * ab.is_Modern_Contemporary + 
    ohe.is_Country * ab.is_Country + 
    ohe.is_Other * ab.is_Other) AS SimilarityScore
FROM OneHotEncoding ohe, ArtistBox ab;

-- Step 4: Query from the similarity table to recommend artists.
CREATE TABLE IF NOT EXISTS SimilarityScore AS
SELECT Name, SimilarityScore
FROM Similarity
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 3) -- Excluding artists user 7 has already listened to
ORDER BY SimilarityScore DESC
LIMIT 5; -- Suggesting the artist with the highest similarity score
