CREATE TABLE IF NOT EXISTS genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE table if not exists artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE table if not exists artist_genre (
    artist_id INT REFERENCES artists (id),
    genre_id INT REFERENCES genres (id),
    PRIMARY key (artist_id, genre_id)
);

CREATE table if not exists albums (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT null,
    release_year INT NOT NULL
);

CREATE table if not exists album_artist (
    album_id INT REFERENCES albums(id),
    artist_id INT REFERENCES artists(id),
    PRIMARY KEY (album_id, artist_id)
);

CREATE table if not exists tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration TIME not NULL,
    album_id INT REFERENCES albums(id),
    artist_id INT REFERENCES artists(id)
);

CREATE table if not exists compilations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT not NULL
);

CREATE table if not exists compilation_track (
    compilation_id INT REFERENCES compilations(id),
    track_id INT REFERENCES tracks(id),
    PRIMARY KEY (compilation_id, track_id)
);


INSERT INTO artists (name) VALUES
('The Beatles'),
('Queen'),
('Nirvana'),
('Adele');


INSERT INTO genres (name) VALUES
('Rock'),
('Pop'),
('Grunge');

INSERT INTO albums (title, release_year) VALUES
('Abbey Road', 1969),
('A Night at the Opera', 1975),
('Nevermind', 1991),
('21', 2020);

INSERT INTO tracks (title, duration, album_id, artist_id) VALUES
('Come Together', '00:04:20', 1, 1),
('Bohemian Rhapsody', '00:05:55', 2, 2),
('Smells Like Teen Spirit', '00:05:01', 3, 3),
('Someone Like You', '00:04:45', 4, 4), 
('We Will Rock You', '00:02:59', 2, 2),
('Hey Jude', '00:07:11', 1, 1);

INSERT INTO compilations (title, release_year) VALUES
('Greatest Hits', 2018),
('Classic Rock Anthems', 2019),
('Pop Hits of the 21st Century', 2020),
('Ultimate Collection', 2021);

INSERT INTO artist_genre (artist_id, genre_id) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 2);

INSERT INTO album_artist (artist_id, album_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO compilation_track (compilation_id, track_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(2, 5),
(1, 6);


SELECT genres.name, COUNT(artist_genre.artist_id)
FROM genres
LEFT JOIN artist_genre ON genres.id = artist_genre.genre_id
GROUP BY genres.name;

SELECT COUNT(tracks.id)
FROM tracks
JOIN albums ON tracks.album_id = albums.id
WHERE albums.release_year BETWEEN 2019 AND 2020;

SELECT albums.title, AVG(EXTRACT(EPOCH FROM tracks.duration)) AS avg_duration_seconds
FROM albums
JOIN tracks ON albums.id = tracks.album_id
GROUP BY albums.title;

	
SELECT DISTINCT artists.name
FROM artists
WHERE artists.id NOT IN (
    SELECT DISTINCT album_artist.artist_id
    FROM album_artist
    JOIN albums ON album_artist.album_id = albums.id
    WHERE albums.release_year = 2020
);

SELECT compilations.title
FROM compilations
JOIN compilation_track ON compilations.id = compilation_track.compilation_id
JOIN tracks ON compilation_track.track_id = tracks.id
JOIN album_artist ON tracks.album_id = album_artist.album_id
JOIN artists ON album_artist.artist_id = artists.id
WHERE artists.name = 'Queen';

SELECT title, duration
FROM tracks
ORDER BY duration DESC
LIMIT 1;

SELECT title
FROM tracks
WHERE duration >= INTERVAL '3 minutes 30 seconds';

SELECT title
FROM compilations
WHERE release_year BETWEEN 2018 AND 2020;

SELECT name
FROM artists
WHERE name NOT LIKE '% %';

SELECT title
FROM tracks
WHERE title ILIKE '%мой%' OR title ILIKE '%my%';
