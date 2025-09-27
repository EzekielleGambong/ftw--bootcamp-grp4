{{ config(materialized="table", schema="clean") }}

WITH playlist_tracks AS (
    SELECT DISTINCT track_id FROM {{ source('raw', 'playlist_track') }}
)
SELECT
    t.track_id      AS track_key,
    t.name          AS track_name,
    a.title         AS album_title,
    art.name        AS artist_name,
    g.name          AS genre_name,
    mt.name         AS media_type_name,
    CASE WHEN pt.track_id IS NOT NULL THEN TRUE ELSE FALSE END AS is_on_playlist
FROM {{ source('raw', 'track') }} t
LEFT JOIN {{ source('raw', 'album') }} a ON t.album_id = a.album_id
LEFT JOIN {{ source('raw', 'artist') }} art ON a.artist_id = art.artist_id
LEFT JOIN {{ source('raw', 'genre') }} g ON t.genre_id = g.genre_id
LEFT JOIN {{ source('raw', 'media_type') }} mt ON t.media_type_id = mt.media_type_id
LEFT JOIN playlist_tracks pt ON t.track_id = pt.track_id