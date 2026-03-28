use worker::*;

mod spotify;

fn cors_headers(env: &Env) -> Result<Headers> {
    let allowed_origin = env
        .var("ALLOWED_ORIGIN")
        .map(|v| v.to_string())
        .unwrap_or_else(|_| "*".to_string());

    let headers = Headers::new();
    headers.set("Access-Control-Allow-Origin", &allowed_origin)?;
    headers.set("Access-Control-Allow-Methods", "GET, OPTIONS")?;
    headers.set("Access-Control-Allow-Headers", "Content-Type")?;
    headers.set("Access-Control-Max-Age", "86400")?;
    Ok(headers)
}

fn cors_preflight(env: &Env) -> Result<Response> {
    let headers = cors_headers(env)?;
    Ok(Response::empty()?.with_headers(headers).with_status(204))
}

#[event(fetch)]
async fn main(req: Request, env: Env, _ctx: Context) -> Result<Response> {
    if req.method() == Method::Options {
        return cors_preflight(&env);
    }

    let activity = match spotify::fetch_activity(&env).await {
        Ok(activity) => activity,
        Err(e) => {
            console_error!("Spotify API error: {e:?}");
            let mut response = Response::error(format!("Spotify API error: {e}"), 502)?;
            let headers = cors_headers(&env)?;
            response = response.with_headers(headers);
            return Ok(response);
        }
    };

    let json =
        serde_json::to_string(&activity).map_err(|e| Error::RustError(e.to_string()))?;

    let headers = cors_headers(&env)?;
    headers.set("Content-Type", "application/json")?;
    headers.set("Cache-Control", "public, max-age=30")?;

    Ok(Response::ok(json)?.with_headers(headers))
}
