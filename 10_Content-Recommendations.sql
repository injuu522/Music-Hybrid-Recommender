-------------------- Repeating the steps above to generate recommendations for random 10 users:--------------------------------------

----------- For the first 2 users, we chose "Rihanna" as the artist-------------

CREATE TABLE IF NOT EXISTS ArtistBox2 AS
SELECT * FROM OneHotEncoding WHERE Name = 'RIHANNA';

CREATE TABLE IF NOT EXISTS Similarity2 AS
SELECT 
    ohe.Name,
    ohe.ID,
    (ohe.is_Metal * ab2.is_Metal + 
    ohe.is_Electronic * ab2.is_Electronic + 
    ohe.is_Rock * ab2.is_Rock + 
    ohe.is_HipHop_and_RnB * ab2.is_HipHop_and_RnB + 
    ohe.is_Pop * ab2.is_Pop + 
    ohe.is_Foreign_Music * ab2.is_Foreign_Music + 
    ohe.is_Decades * ab2.is_Decades + 
    ohe.is_Classical_Music * ab2.is_Classical_Music + 
    ohe.is_Modern_Contemporary * ab2.is_Modern_Contemporary + 
    ohe.is_Country * ab2.is_Country + 
    ohe.is_Other * ab2.is_Other) AS SimilarityScore
FROM OneHotEncoding ohe, ArtistBox2 ab2;

-- User ID 1710 

SELECT Name, SimilarityScore
FROM Similarity2
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 1710)
ORDER BY SimilarityScore DESC
LIMIT 5;

-- User ID 104

SELECT Name, SimilarityScore
FROM Similarity2
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 104)
ORDER BY SimilarityScore DESC
LIMIT 5;

----------- For the next 2 users, we chose "Coldplay" as the artist-------------

CREATE TABLE IF NOT EXISTS ArtistBox3 AS
SELECT * FROM OneHotEncoding WHERE Name = 'COLDPLAY';

CREATE TABLE IF NOT EXISTS Similarity3 AS
SELECT 
    ohe.Name,
    ohe.ID,
    (ohe.is_Metal * ab3.is_Metal + 
    ohe.is_Electronic * ab3.is_Electronic + 
    ohe.is_Rock * ab3.is_Rock + 
    ohe.is_HipHop_and_RnB * ab3.is_HipHop_and_RnB + 
    ohe.is_Pop * ab3.is_Pop + 
    ohe.is_Foreign_Music * ab3.is_Foreign_Music + 
    ohe.is_Decades * ab3.is_Decades + 
    ohe.is_Classical_Music * ab3.is_Classical_Music + 
    ohe.is_Modern_Contemporary * ab3.is_Modern_Contemporary + 
    ohe.is_Country * ab3.is_Country + 
    ohe.is_Other * ab3.is_Other) AS SimilarityScore
FROM OneHotEncoding ohe, ArtistBox3 ab3;


-- User ID 1638

SELECT Name, SimilarityScore
FROM Similarity3
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 1638)
ORDER BY SimilarityScore DESC
LIMIT 5;

-- User ID 670

SELECT Name, SimilarityScore
FROM Similarity3
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 670)
ORDER BY SimilarityScore DESC
LIMIT 5;

----------- For the next 2 users, we chose "Adele" as the artist-------------

CREATE TABLE IF NOT EXISTS ArtistBox5 AS
SELECT * FROM OneHotEncoding WHERE Name = 'ADELE';

CREATE TABLE IF NOT EXISTS Similarity5 AS
SELECT 
    ohe.Name,
    ohe.ID,
    (ohe.is_Metal * ab5.is_Metal + 
    ohe.is_Electronic * ab5.is_Electronic + 
    ohe.is_Rock * ab5.is_Rock + 
    ohe.is_HipHop_and_RnB * ab5.is_HipHop_and_RnB + 
    ohe.is_Pop * ab5.is_Pop + 
    ohe.is_Foreign_Music * ab5.is_Foreign_Music + 
    ohe.is_Decades * ab5.is_Decades + 
    ohe.is_Classical_Music * ab5.is_Classical_Music + 
    ohe.is_Modern_Contemporary * ab5.is_Modern_Contemporary + 
    ohe.is_Country * ab5.is_Country + 
    ohe.is_Other * ab5.is_Other) AS SimilarityScore
FROM OneHotEncoding ohe, ArtistBox5 ab5;


-- User ID 1697 

SELECT Name, SimilarityScore
FROM Similarity5
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 1697)
ORDER BY SimilarityScore DESC
LIMIT 5;

-- User ID 512

SELECT Name, SimilarityScore
FROM Similarity5
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 512)
ORDER BY SimilarityScore DESC
LIMIT 5;

----------- For the next 2 users, we chose "Kanye West" as the artist-------------

CREATE TABLE IF NOT EXISTS ArtistBox6 AS
SELECT * FROM OneHotEncoding WHERE Name = 'KANYE WEST';

CREATE TABLE IF NOT EXISTS Similarity6 AS
SELECT 
    ohe.Name,
    ohe.ID,
    (ohe.is_Metal * ab6.is_Metal + 
    ohe.is_Electronic * ab6.is_Electronic + 
    ohe.is_Rock * ab6.is_Rock + 
    ohe.is_HipHop_and_RnB * ab6.is_HipHop_and_RnB + 
    ohe.is_Pop * ab6.is_Pop + 
    ohe.is_Foreign_Music * ab6.is_Foreign_Music + 
    ohe.is_Decades * ab6.is_Decades + 
    ohe.is_Classical_Music * ab6.is_Classical_Music + 
    ohe.is_Modern_Contemporary * ab6.is_Modern_Contemporary + 
    ohe.is_Country * ab6.is_Country + 
    ohe.is_Other * ab6.is_Other) AS SimilarityScore
FROM OneHotEncoding ohe, ArtistBox6 ab6;


-- User ID 710

SELECT Name, SimilarityScore
FROM Similarity6
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 710)
ORDER BY SimilarityScore DESC
LIMIT 5;

-- User ID 1136

SELECT Name, SimilarityScore
FROM Similarity6
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 1136)
ORDER BY SimilarityScore DESC
LIMIT 5;

----------- For the last 2 users, we chose "Lady Gaga" as the artist-------------

CREATE TABLE IF NOT EXISTS ArtistBox7 AS
SELECT * FROM OneHotEncoding WHERE Name = 'LADY GAGA';

CREATE TABLE IF NOT EXISTS Similarity7 AS
SELECT 
    ohe.Name,
    ohe.ID,
    (ohe.is_Metal * ab7.is_Metal + 
    ohe.is_Electronic * ab7.is_Electronic + 
    ohe.is_Rock * ab7.is_Rock + 
    ohe.is_HipHop_and_RnB * ab7.is_HipHop_and_RnB + 
    ohe.is_Pop * ab7.is_Pop + 
    ohe.is_Foreign_Music * ab7.is_Foreign_Music + 
    ohe.is_Decades * ab7.is_Decades + 
    ohe.is_Classical_Music * ab7.is_Classical_Music + 
    ohe.is_Modern_Contemporary * ab7.is_Modern_Contemporary + 
    ohe.is_Country * ab7.is_Country + 
    ohe.is_Other * ab7.is_Other) AS SimilarityScore
FROM OneHotEncoding ohe, ArtistBox7 ab7;

-- User 1351

SELECT Name, SimilarityScore
FROM Similarity7
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 1351)
ORDER BY SimilarityScore DESC
LIMIT 5;

-- User 1770

SELECT Name, SimilarityScore
FROM Similarity7
WHERE ID NOT IN (SELECT ArtistID FROM UserArtists WHERE UserID = 1770)
ORDER BY SimilarityScore DESC
LIMIT 5;