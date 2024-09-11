-- Drop triggers if they exist
DROP TRIGGER IF EXISTS before_user_delete;

-- Drop procedures if they exist
DROP PROCEDURE IF EXISTS follow_user;
DROP PROCEDURE IF EXISTS unfollow_user;
DROP PROCEDURE IF EXISTS follow_artist;
DROP PROCEDURE IF EXISTS unfollow_artist;
DROP PROCEDURE IF EXISTS like_song;
DROP PROCEDURE IF EXISTS unlike_song;
DROP PROCEDURE IF EXISTS like_album;
DROP PROCEDURE IF EXISTS unlike_album;
DROP PROCEDURE IF EXISTS like_playlist;
DROP PROCEDURE IF EXISTS unlike_playlist;

-- Drop tables if they exist
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS user_follow_user;
DROP TABLE IF EXISTS user_follow_artist;
DROP TABLE IF EXISTS liked_songs;
DROP TABLE IF EXISTS liked_albums;
DROP TABLE IF EXISTS liked_playlists;

-- Create Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT,
    name VARCHAR(50),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(20) NOT NULL,
    date_created DATETIME,
    profile_pic BLOB,
    PRIMARY KEY (id)
);

-- Create Artists Table
CREATE TABLE artists (
    id INT AUTO_INCREMENT,
    name VARCHAR(50),
    biography TEXT,
    date_created DATE,
    profile_pic BLOB,
    PRIMARY KEY (id)
);

-- Create Albums Table
CREATE TABLE albums (
    id INT AUTO_INCREMENT,
    artist_id INT,
    title VARCHAR(156) NOT NULL,
    release_date DATE NOT NULL,
    cover_art BLOB NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (artist_id) REFERENCES artists(id)
);

-- Create Songs Table
CREATE TABLE songs (
    id INT AUTO_INCREMENT,
    artist_id INT,
    album_id INT DEFAULT NULL,
    title VARCHAR(50) NOT NULL,
    duration TIME NOT NULL,
    release_date DATE NOT NULL,
    genre VARCHAR(37) NOT NULL,
    single BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (artist_id) REFERENCES artists(id),
    FOREIGN KEY (album_id) REFERENCES albums(id)
);

-- Create Playlists Table
CREATE TABLE playlists (
    id INT AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(30) NOT NULL,
    description TEXT DEFAULT NULL,
    date_created DATE NOT NULL,
    public BOOL DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create User Follow User Table
CREATE TABLE user_follow_user (
    id INT AUTO_INCREMENT,
    user1_id INT,
    user2_id INT,
    since DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (user1_id) REFERENCES users(id),
    FOREIGN KEY (user2_id) REFERENCES users(id)
);

-- Create User Follow Artist Table
CREATE TABLE user_follow_artist (
    id INT AUTO_INCREMENT,
    user_id INT,
    artist_id INT,
    since DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (artist_id) REFERENCES artists(id)
);

-- Create Liked Songs Table
CREATE TABLE liked_songs (
    id INT AUTO_INCREMENT,
    user_id INT,
    song_id INT,
    since DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (song_id) REFERENCES songs(id)
);

-- Create Liked Albums Table
CREATE TABLE liked_albums (
    id INT AUTO_INCREMENT,
    user_id INT,
    album_id INT,
    since DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (album_id) REFERENCES albums(id)
);

-- Create Liked Playlists Table
CREATE TABLE liked_playlists (
    id INT AUTO_INCREMENT,
    user_id INT,
    playlist_id INT,
    since DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (playlist_id) REFERENCES playlists(id)
);

-- Add Indexes to User Follow Tables
CREATE INDEX idx_user1_id ON user_follow_user (user1_id);
CREATE INDEX idx_user2_id ON user_follow_user (user2_id);
CREATE INDEX idx_user_artist_user_id ON user_follow_artist (user_id);
CREATE INDEX idx_user_artist_artist_id ON user_follow_artist (artist_id);

-- Add Indexes to Like Tables
CREATE INDEX idx_liked_songs_user_id ON liked_songs (user_id);
CREATE INDEX idx_liked_songs_song_id ON liked_songs (song_id);
CREATE INDEX idx_liked_albums_user_id ON liked_albums (user_id);
CREATE INDEX idx_liked_albums_album_id ON liked_albums (album_id);
CREATE INDEX idx_liked_playlists_user_id ON liked_playlists (user_id);
CREATE INDEX idx_liked_playlists_playlist_id ON liked_playlists (playlist_id);

-- Set delimiter for triggers and procedures
DELIMITER //

-- Trigger: Before Deleting a User
CREATE TRIGGER before_user_delete
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    -- Delete related records
    DELETE FROM user_follow_user WHERE user1_id = OLD.id OR user2_id = OLD.id;
    DELETE FROM user_follow_artist WHERE user_id = OLD.id;
    DELETE FROM liked_songs WHERE user_id = OLD.id;
    DELETE FROM liked_albums WHERE user_id = OLD.id;
    DELETE FROM liked_playlists WHERE user_id = OLD.id;
END;

-- Procedure: Follow User with Error Handling
CREATE PROCEDURE follow_user(IN follower_id INT, IN followee_id INT)
BEGIN
    -- Check if the follow relationship already exists
    IF NOT EXISTS (SELECT 1 FROM user_follow_user WHERE user1_id = follower_id AND user2_id = followee_id) THEN
        INSERT INTO user_follow_user (user1_id, user2_id, since)
        VALUES (follower_id, followee_id, NOW());
    END IF;
END //

-- Procedure: Unfollow User
CREATE PROCEDURE unfollow_user(IN follower_id INT, IN followee_id INT)
BEGIN
    DELETE FROM user_follow_user
    WHERE user1_id = follower_id AND user2_id = followee_id;
END //

-- Procedure: Follow Artist with Error Handling
CREATE PROCEDURE follow_artist(IN user_ID INT, IN artist_ID INT)
BEGIN
    -- Check if the user is already following the artist
    IF NOT EXISTS (SELECT 1 FROM user_follow_artist WHERE user_id = user_ID AND artist_id = artist_ID) THEN
        INSERT INTO user_follow_artist (user_id, artist_id, since)
        VALUES (user_ID, artist_ID, NOW());
    END IF;
END //

-- Procedure: Unfollow Artist
CREATE PROCEDURE unfollow_artist(IN user_ID INT, IN artist_ID INT)
BEGIN
    DELETE FROM user_follow_artist
    WHERE user_id = user_ID AND artist_id = artist_ID;
END //

-- Procedure: Like Song with Error Handling
CREATE PROCEDURE like_song(IN user_ID INT, IN song_ID INT)
BEGIN
    -- Check if the song is already liked by the user
    IF NOT EXISTS (SELECT 1 FROM liked_songs WHERE user_id = user_ID AND song_id = song_ID) THEN
        INSERT INTO liked_songs (user_id, song_id, since)
        VALUES (user_ID, song_ID, CURDATE());
    END IF;
END //

-- Procedure: Unlike Song
CREATE PROCEDURE unlike_song(IN user_ID INT, IN song_ID INT)
BEGIN
    DELETE FROM liked_songs
    WHERE user_id = user_ID AND song_id = song_ID;
END //

-- Procedure: Like Album with Error Handling
CREATE PROCEDURE like_album(IN user_ID INT, IN album_ID INT)
BEGIN
    -- Check if the album is already liked by the user
    IF NOT EXISTS (SELECT 1 FROM liked_albums WHERE user_id = user_ID AND album_id = album_ID) THEN
        INSERT INTO liked_albums (user_id, album_id, since)
        VALUES (user_ID, album_ID, CURDATE());
    END IF;
END //

-- Procedure: Unlike Album
CREATE PROCEDURE unlike_album(IN user_ID INT, IN album_ID INT)
BEGIN
    DELETE FROM liked_albums
    WHERE user_id = user_ID AND album_id = album_ID;
END //

-- Procedure: Like Playlist with Error Handling
CREATE PROCEDURE like_playlist(IN user_ID INT, IN playlist_ID INT)
BEGIN
    -- Check if the playlist is already liked by the user
    IF NOT EXISTS (SELECT 1 FROM liked_playlists WHERE user_id = user_ID AND playlist_id = playlist_ID) THEN
        INSERT INTO liked_playlists (user_id, playlist_id, since)
        VALUES (user_ID, playlist_ID, CURDATE());
    END IF;
END //

-- Procedure: Unlike Playlist
CREATE PROCEDURE unlike_playlist(IN user_ID INT, IN playlist_ID INT)
BEGIN
    DELETE FROM liked_playlists
    WHERE user_id = user_ID AND playlist_id = playlist_ID;
END //

-- Reset delimiter
DELIMITER ;