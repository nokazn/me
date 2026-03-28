#!/usr/bin/env bun
// Get Spotify refresh token via OAuth Authorization Code Flow.
//
// Usage:
//   bun scripts/get-spotify-token.mts CLIENT_ID CLIENT_SECRET
//   SPOTIFY_CLIENT_ID=xxx SPOTIFY_CLIENT_SECRET=xxx bun scripts/get-spotify-token.mts
//
// Prerequisites:
//   Register http://127.0.0.1:8888/callback as a redirect URI in
//   https://developer.spotify.com/dashboard

const [clientId, clientSecret] = (() => {
  const args = process.argv.slice(2);
  const id = args[0] || process.env['SPOTIFY_CLIENT_ID'];
  const secret = args[1] || process.env['SPOTIFY_CLIENT_SECRET'];
  if (!id) {
    console.error("Error: CLIENT_ID is required (arg or SPOTIFY_CLIENT_ID env var)");
    process.exit(1);
  }
  if (!secret) {
    console.error("Error: CLIENT_SECRET is required (arg or SPOTIFY_CLIENT_SECRET env var)");
    process.exit(1);
  }
  return [id, secret];
})();

const PORT = 8888;
const REDIRECT_URI = `http://127.0.0.1:${PORT}/callback`;
const SCOPE = "user-read-currently-playing user-read-recently-played";

const authUrl = `https://accounts.spotify.com/authorize`
  + `?client_id=${clientId}`
  + `&response_type=code`
  + `&redirect_uri=${encodeURIComponent(REDIRECT_URI)}`
  + `&scope=${encodeURIComponent(SCOPE)}`;

console.log(`1. Redirect URI to register in Spotify Dashboard:\n   ${REDIRECT_URI}\n`);
console.log("2. Opening Spotify auth page in browser...");
Bun.spawn(["open", authUrl]);
console.log(`   (If it didn't open: ${authUrl})\n`);
console.log(`3. Waiting for callback on ${REDIRECT_URI} ...`);

const code = await new Promise<string>((resolve, reject) => {
  const server = Bun.serve({
    port: PORT,
    hostname: "127.0.0.1",
    fetch(req) {
      const url = new URL(req.url);
      const error = url.searchParams.get("error");
      const code = url.searchParams.get("code");

      if (error) {
        server.stop();
        reject(new Error(`Spotify auth error: ${error}`));
        return new Response(`Error: ${error}`, { status: 400 });
      }

      if (code) {
        server.stop();
        resolve(code);
        return new Response(
          "<h1>OK</h1><p>Authorization successful. You can close this tab.</p>",
          { headers: { "Content-Type": "text/html; charset=utf-8" } },
        );
      }

      return new Response("Not found", { status: 404 });
    },
  });
});

console.log("   Got authorization code.\n");
console.log("4. Exchanging code for tokens...");

const tokenRes = await fetch("https://accounts.spotify.com/api/token", {
  method: "POST",
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    Authorization: `Basic ${btoa(`${clientId}:${clientSecret}`)}`,
  },
  body: new URLSearchParams({
    grant_type: "authorization_code",
    code,
    redirect_uri: REDIRECT_URI,
  }),
});

const tokenData = (await tokenRes.json()) as Record<string, string>;

if (!tokenData["refresh_token"]) {
  console.error(`Error: ${tokenData["error"] ?? JSON.stringify(tokenData)}`);
  process.exit(1);
}

const devVarsPath = "packages/worker/.dev.vars";
const devVarsContent = [
  `SPOTIFY_CLIENT_ID=${clientId}`,
  `SPOTIFY_CLIENT_SECRET=${clientSecret}`,
  `SPOTIFY_REFRESH_TOKEN=${tokenData["refresh_token"]}`,
].join("\n") + "\n";

await Bun.write(devVarsPath, devVarsContent);

console.log(`5. Written secrets to ${devVarsPath}\n`);
console.log(`Done! Run \`just dev\` to start the local server.`);
