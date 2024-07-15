default:
  @just --list

dev:
  pnpm run dev

preview:
  pnpm run preview

check:
  pnpm run check
  cargo check

fix:
  pnpm run fix
  cargo fix

test:
  pnpm run test
  cargo test

build:
  pnpm run build
  cargo build

deploy:
  pnpm run deploy
