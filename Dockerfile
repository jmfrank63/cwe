# Select a base image with Rust installed
FROM rust:latest as builder

# Create a new empty shell project
RUN cargo new --bin app
WORKDIR /app

# Copy over your manifests
COPY ./Cargo.toml ./Cargo.toml

# This trick will cache your dependencies
COPY common/Cargo.toml ./common/Cargo.toml
COPY db/Cargo.toml ./db/Cargo.toml
COPY server/Cargo.toml ./server/Cargo.toml

# Create dummy source files, otherwise cargo build will throw an error about missing lib.rs
RUN mkdir -p common/src && echo "fn main() {}" > common/src/main.rs
RUN mkdir -p db/src && echo "fn main() {}" > db/src/main.rs
RUN mkdir -p server/src && echo "fn main() {}" > server/src/main.rs

# Cache dependencies
RUN cargo build --release

# Remove dummy source files
RUN rm -f ./common/src/*.rs ./db/src/*.rs ./server/src/*.rs

# Copy real source files
COPY ./common ./common
COPY ./db ./db
COPY ./server ./server

# Build real binaries
RUN cargo build --release
