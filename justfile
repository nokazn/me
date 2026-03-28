default:
  @just --list

dev:
  pnpm run dev

dev-web:
  pnpm --filter @nokazn.me/web run dev

dev-worker:
  pnpm --filter @nokazn.me/worker run dev

check:
  pnpm run check
  cargo check

fmt check="":
  if [[ "{{check}}" == "--check" ]]; then \
    just fmt-rust --check; \
    just fmt-nix --check; \
    just fmt-dprint --diff; \
  else \
    just fmt-rust; \
    just fmt-nix; \
    just fmt-dprint; \
  fi

fmt-rust *flags:
  cargo fmt {{flags}}

fmt-nix *flags:
  find . -type f -iname '*.nix' |  grep -v 'node_modules' | xargs nixpkgs-fmt {{flags}}

fmt-dprint *flags:
    dprint fmt {{flags}}

fix:
  pnpm run fix
  cargo fix

test:
  pnpm run test
  cargo test

build:
  pnpm run build
  cargo build

preview: build
  pnpm run preview

deploy:
  pnpm run deploy

update: update-flake update-npm

update-flake:
  nix flake update

update-npm:
  pnpm update

# Get Spotify refresh token via OAuth (requires CLIENT_ID and CLIENT_SECRET)
spotify-token client_id="" client_secret="":
  bun scripts/get-spotify-token.mts "{{client_id}}" "{{client_secret}}"
