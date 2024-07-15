default:
  @just --list

dev:
  pnpm run dev

preview:
  pnpm run preview

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

deploy:
  pnpm run deploy
