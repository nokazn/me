use base64::{engine::general_purpose::STANDARD as b64, Engine as _};
use serde::{Deserialize, Serialize};
use worker::*;

#[derive(Serialize)]
pub struct SpotifyActivity {
    pub currently_playing: Option<TrackInfo>,
    pub recently_played: Vec<TrackInfo>,
}

#[derive(Serialize)]
pub struct TrackInfo {
    pub name: String,
    pub artists: Vec<String>,
    pub album: String,
    pub image_url: String,
    pub url: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub played_at: Option<String>,
}

#[derive(Deserialize)]
struct TokenResponse {
    access_token: String,
}

#[derive(Deserialize)]
struct SpotifyImage {
    url: String,
    #[allow(dead_code)]
    width: Option<u32>,
    #[allow(dead_code)]
    height: Option<u32>,
}

#[derive(Deserialize)]
struct SpotifyArtist {
    name: String,
}

#[derive(Deserialize)]
struct SpotifyAlbum {
    name: String,
    images: Vec<SpotifyImage>,
}

#[derive(Deserialize)]
struct SpotifyExternalUrls {
    spotify: String,
}

#[derive(Deserialize)]
struct SpotifyTrack {
    name: String,
    artists: Vec<SpotifyArtist>,
    album: SpotifyAlbum,
    external_urls: SpotifyExternalUrls,
}

#[derive(Deserialize)]
struct CurrentlyPlayingResponse {
    is_playing: bool,
    item: Option<SpotifyTrack>,
}

#[derive(Deserialize)]
struct PlayHistoryItem {
    track: SpotifyTrack,
    played_at: String,
}

#[derive(Deserialize)]
struct RecentlyPlayedResponse {
    items: Vec<PlayHistoryItem>,
}

fn track_to_info(track: &SpotifyTrack, played_at: Option<String>) -> TrackInfo {
    let image_url = track
        .album
        .images
        .last()
        .map(|img| img.url.clone())
        .unwrap_or_default();

    TrackInfo {
        name: track.name.clone(),
        artists: track.artists.iter().map(|a| a.name.clone()).collect(),
        album: track.album.name.clone(),
        image_url,
        url: track.external_urls.spotify.clone(),
        played_at,
    }
}

async fn refresh_access_token(env: &Env) -> Result<String> {
    let client_id = env.secret("SPOTIFY_CLIENT_ID")?.to_string();
    let client_secret = env.secret("SPOTIFY_CLIENT_SECRET")?.to_string();
    let refresh_token = env.secret("SPOTIFY_REFRESH_TOKEN")?.to_string();

    let credentials = b64.encode(format!("{client_id}:{client_secret}"));
    let body = format!("grant_type=refresh_token&refresh_token={refresh_token}");

    let headers = Headers::new();
    headers.set("Authorization", &format!("Basic {credentials}"))?;
    headers.set("Content-Type", "application/x-www-form-urlencoded")?;

    let request = Request::new_with_init(
        "https://accounts.spotify.com/api/token",
        RequestInit::new()
            .with_method(Method::Post)
            .with_headers(headers)
            .with_body(Some(body.into())),
    )?;

    let mut response = Fetch::Request(request).send().await?;
    if response.status_code() != 200 {
        let text = response.text().await.unwrap_or_default();
        return Err(Error::RustError(format!(
            "Token refresh failed ({}): {}",
            response.status_code(),
            text
        )));
    }

    let token_response: TokenResponse = response.json().await?;
    Ok(token_response.access_token)
}

async fn fetch_currently_playing(access_token: &str) -> Result<Option<TrackInfo>> {
    let headers = Headers::new();
    headers.set("Authorization", &format!("Bearer {access_token}"))?;

    let request = Request::new_with_init(
        "https://api.spotify.com/v1/me/player/currently-playing",
        RequestInit::new()
            .with_method(Method::Get)
            .with_headers(headers),
    )?;

    let mut response = Fetch::Request(request).send().await?;

    // 204 = nothing currently playing
    if response.status_code() == 204 {
        return Ok(None);
    }
    if response.status_code() != 200 {
        return Ok(None);
    }

    let body = response.text().await?;
    if body.is_empty() {
        return Ok(None);
    }

    let parsed: CurrentlyPlayingResponse =
        serde_json::from_str(&body).map_err(|e| Error::RustError(e.to_string()))?;

    if !parsed.is_playing {
        return Ok(None);
    }

    Ok(parsed.item.as_ref().map(|track| track_to_info(track, None)))
}

async fn fetch_recently_played(access_token: &str) -> Result<Vec<TrackInfo>> {
    let headers = Headers::new();
    headers.set("Authorization", &format!("Bearer {access_token}"))?;

    let request = Request::new_with_init(
        "https://api.spotify.com/v1/me/player/recently-played?limit=10",
        RequestInit::new()
            .with_method(Method::Get)
            .with_headers(headers),
    )?;

    let mut response = Fetch::Request(request).send().await?;
    if response.status_code() != 200 {
        let text = response.text().await.unwrap_or_default();
        return Err(Error::RustError(format!(
            "Recently played failed ({}): {}",
            response.status_code(),
            text
        )));
    }

    let parsed: RecentlyPlayedResponse = response.json().await?;
    let tracks = parsed
        .items
        .iter()
        .map(|item| track_to_info(&item.track, Some(item.played_at.clone())))
        .collect();

    Ok(tracks)
}

pub async fn fetch_activity(env: &Env) -> Result<SpotifyActivity> {
    let access_token = refresh_access_token(env).await?;

    let (currently_playing, recently_played) = (
        fetch_currently_playing(&access_token).await?,
        fetch_recently_played(&access_token).await?,
    );

    Ok(SpotifyActivity {
        currently_playing,
        recently_played,
    })
}
