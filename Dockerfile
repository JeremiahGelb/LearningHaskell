# syntax=docker/dockerfile:1
# --- STAGE 1: Build Environment ---
FROM haskell:9.10-bookworm AS builder

WORKDIR /opt/build

# Update package index and install system deps
RUN apt-get update && apt-get install -y libgmp-dev && rm -rf /var/lib/apt/lists/*
RUN cabal update

# Install ghcup for vs code haskell plugin
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Cache dependencies separately
COPY . .
RUN --mount=type=cache,target=/root/.cabal/store \
    cabal build --only-dependencies -j

# Copy source and run tests
FROM builder AS tester
COPY . .
RUN --mount=type=cache,target=/root/.cabal/store \
    make test

# Build and install the production binary
RUN --mount=type=cache,target=/root/.cabal/store \
    cabal install --install-method=copy --installdir=./bin

# --- STAGE 2: Runtime ---
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y libgmp10 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /opt/build/bin/learning-haskell-exe /usr/local/bin/learning-haskell-exe

ENTRYPOINT ["learning-haskell-exe"]
CMD ["10"]