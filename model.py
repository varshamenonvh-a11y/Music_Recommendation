import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Load dataset
music = pd.read_csv("C:/Users/user/OneDrive/Documents/VaStUfFs/DATA SCIENCE AND AI/AI/FINAL_PROJECT/youtube-top-100-songs-2025.csv")
# Data cleaning
music['tags'] = music['tags'].fillna(music['tags'].mode()[0])
music = music.drop_duplicates(subset=['title', 'channel']).reset_index(drop=True)

# Select features
selected_features = ['view_count', 'tags', 'channel', 'channel_follower_count']

for feature in selected_features:
    music[feature] = music[feature].fillna(' ')

# Combine features into a single text
combined_features = (
    music['view_count'].astype(str) + ' ' +
    music['tags'] + ' ' +
    music['channel'] + ' ' +
    music['channel_follower_count'].astype(str)
)

def get_recommendations(view_count, tags, channel, channel_follower_count, top_n=5):
    user_input = f"{view_count} {tags} {channel} {channel_follower_count}"
    all_music_features = combined_features.tolist()
    all_texts = all_music_features + [user_input]

    vectorizer = TfidfVectorizer()
    all_vectors = vectorizer.fit_transform(all_texts)

    music_vectors = all_vectors[:-1]
    user_vector = all_vectors[-1]

    similarities = cosine_similarity(user_vector, music_vectors).flatten()
    top_indices = similarities.argsort()[-top_n:][::-1]

    recommended_titles = [music.iloc[i]['title'] for i in top_indices]
    return recommended_titles