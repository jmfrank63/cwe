# Select a base image with Rust installed
FROM rust:latest as builder

# Create a new empty shell project
RUN cargo new --bin app
WORKDIR /app

# Copy over your manifests
COPY ./Cargo.toml ./Cargo.toml

# This trick will cache your dependencies
COPY core/Cargo.toml ./core/Cargo.toml
COPY db/Cargo.toml ./db/Cargo.toml
COPY frontend/Cargo.toml ./frontend/Cargo.toml
COPY server/Cargo.toml ./server/Cargo.toml
COPY tests/Cargo.toml ./tests/Cargo.toml

# Create dummy source files, otherwise cargo build will throw an error about missing lib.rs
RUN mkdir -p core/src && echo "fn main() {}" > core/src/main.rs
RUN mkdir -p db/src && echo "fn main() {}" > db/src/main.rs
RUN mkdir -p frontend/src && echo "fn main() {}" > frontend/src/main.rs
RUN mkdir -p server/src && echo "fn main() {}" > server/src/main.rs
RUN mkdir -p tests/src && echo "fn main() {}" > tests/src/main.rs

# Cache dependencies
RUN cargo build --release

# Remove dummy source files and copy real source files
RUN rm -f ./core/src/*.rs ./db/src/*.rs ./frontend/src/*.rs ./server/src/*.rs ./tests/src/*.rs
COPY . .

# Build real binaries
RUN cargo build --release
