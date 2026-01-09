FROM nixos/nix:latest AS build


WORKDIR /tmp/build
COPY Cargo.toml Cargo.lock flake.nix flake.lock /tmp/build

# Cache
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN nix \
  --extra-experimental-features "nix-command flakes" \
  --option filter-syscalls false \
  build
RUN rm -rf src

# Build artifact
COPY . /tmp/build

RUN nix \
  --extra-experimental-features "nix-command flakes" \
  --option filter-syscalls false \
  build

RUN mkdir /tmp/nix-store-closure
RUN cp -R $(nix-store -qR result/) /tmp/nix-store-closure

FROM debian:bookworm-slim AS app

WORKDIR /app

COPY --from=build /tmp/nix-store-closure /nix/store
COPY --from=build /tmp/build/result /app
EXPOSE 8000
CMD ["/app/bin/morioh-backend"]
