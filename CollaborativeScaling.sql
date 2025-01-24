-- Authors: Jack Deveney, Injuu Jyneis, Jui Nagarkar, & Adawn Symonette
-- Title: BSAN 780 Final Project
-- Date: 04.19.2024
-- Description: This file contains SQL code content based filtering.

SELECT * FROM UserArtists ua ;

CREATE TABLE UserWeightSummary AS
SELECT UserID, MAX(weight) AS max_weight, MIN(weight) AS min_weight
FROM UserArtists
GROUP BY UserID;

ALTER TABLE UserWeightSummary
ADD COLUMN weight_diff FLOAT;

UPDATE UserWeightSummary
SET weight_diff = max_weight - min_weight;

SELECT * FROM UserWeightSummary;


CREATE TABLE ScaledUserArtists AS
SELECT 
    ua.UserID,
    ua.ArtistID,
    (ua.weight - uw.min_weight) / uw.weight_diff AS scaled_weight
FROM 
    UserArtists ua
JOIN 
    UserWeightSummary uw ON ua.UserID = uw.UserID;
    
SELECT * FROM ScaledUserArtists;



