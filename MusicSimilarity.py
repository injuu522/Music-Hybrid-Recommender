# Authors: Jack Deveney, Jui Nagarkar, Injuu Jyneis, & Adawn Symonette
# Title: BSAN 780 Final Project
# Date: 04.19.2024
# Description: This file contains Python code for collaborative and content based filtering.

#------------------------------------------------COLLABORATIVE BASED------------------------------------------------------------------------
import numpy as np
import pandas as pd
import sqlite3
from sklearn.metrics.pairwise import euclidean_distances
from scipy.spatial import distance

conn = sqlite3.connect(r"C:\Users\John Deveney\Downloads\Music.db")
cur = conn.cursor()

cur.execute("SELECT * FROM ScaledUserArtists;")

query = "SELECT * FROM ScaledUserArtists"

df = pd.read_sql_query(query, conn)

conn.close()

interaction_matrix = pd.pivot_table(df, values='scaled_weight', index='UserID', columns='ArtistID', fill_value=0)

interaction_matrix_array = interaction_matrix.values

print(interaction_matrix_array)

user_distance = euclidean_distances(interaction_matrix_array)

user_distance_df = pd.DataFrame(user_distance, index=interaction_matrix.index, columns=interaction_matrix.index)

print(user_distance_df.head())

user_distance_df

conn = sqlite3.connect(r"C:\Users\John Deveney\Downloads\Music.db")
cur = conn.cursor()

user_distance_df.to_sql('user_distance_df', conn, if_exists='replace', index=False)

conn.close()

#input user here
user_id_to_find = 1770
index_of_user_id = user_distance_df.index.get_loc(user_id_to_find)
print("Index of UserID", user_id_to_find, "is", index_of_user_id)
min_index = user_distance_df[user_distance_df.iloc[:, index_of_user_id] != 0].iloc[:, index_of_user_id].idxmin()
row_name = user_distance_df.index[min_index]
conn = sqlite3.connect(r"C:\Users\John Deveney\Downloads\Music.db")
cur = conn.cursor()
cur.execute("SELECT * FROM ScaledUserArtists WHERE UserID = ?", (int(row_name),))
result = cur.fetchall()
conn.close()
similar_user = pd.DataFrame(result, columns=['UserID', 'ArtistID', 'ScaledWeight'])
df_sorted = similar_user.sort_values(by='ScaledWeight', ascending=False)
top_artist_ids = df_sorted.head(5)['ArtistID']
matrix = top_artist_ids.to_numpy()
conn = sqlite3.connect(r"C:\Users\John Deveney\Downloads\Music.db")
cursor = conn.cursor()
ids_str = ','.join(map(str, matrix.flatten()))
cursor.execute(f"SELECT ID, Name FROM artists WHERE ID IN ({ids_str})")
results = cursor.fetchall()
id_name_map = {row[0]: row[1] for row in results}
print("Based on what similar users have listened to")
print(id_name_map)

#------------------------------------------------CONTENT BASED------------------------------------------------------------------------


#Content Based Filtering:

#since we were having issues with utf-8 in SQL we decided to check the encoding on the artist table

#checking the different artist names after running encoding for each
#getting the db file and establishing connection
conn = sqlite3.connect(r"C:\Users\sampa\OneDrive\Documents\Jui Homework\5 Year MBA Program!!\Spring 2024!\BSAN 780\In Class\Music.db")
cur = conn.cursor()

#selecting the name column specifically from the Artists table
cur.execute("SELECT Name FROM Artists;")

#fetching all results and storing them in a variable defined as result
result = cur.fetchall()

value_list = [value[0] for value in result]

# Print the list of values
print(value_list)

#encoding using utf-8
encoded_entries = [entry.encode('utf-8') for entry in value_list]

# Print the encoded entries
print(encoded_entries)

# Close the connection
conn.close()

#establishing connection again to output the top 5 artists based on the one hot encoding followed by other steps done in
#SQL
conn = sqlite3.connect(r"C:\Users\sampa\OneDrive\Documents\Jui Homework\5 Year MBA Program!!\Spring 2024!\BSAN 780\In Class\Music.db")
cur = conn.cursor()

#Selecting all the columns from the similarity score table created in DBeaver
cur.execute("SELECT * FROM SimilarityScore;")

#fetching the results and storing in a variable named result
result = cur.fetchall()

#extracting the values into a list
value_list = [value[0] for value in result]

#printing the list
#print(value_list)

#encoding using utf-8
encoded_entries = [entry.encode('utf-8') for entry in value_list]

# Print the encoded entries
print("Since you listened to this artist, here are 5 others we think you would like!\n" + str(encoded_entries))

# Close the connection
conn.close()