# Stage 1: Build the binary
FROM rust:latest AS builder

# Create app directory
WORKDIR /app

# Copy manifests
COPY server/Cargo.toml ./server/Cargo.toml

RUN mkdir -p server/src && echo "fn main() {}" > server/src/main.rs

# Remove dummy source files
RUN rm -f ./server/src/*.rs

# Copy real source files
COPY . .

# Build the specified workspace
RUN cargo build --release --manifest-path=server/Cargo.toml

# Stage 2: Create a minimal image with OpenSSL 3.0
FROM debian:testing-slim
ARG APP=/usr/src/app

EXPOSE 8443
ENV TZ=Etc/UTC \
    APP_USER=appuser

# Install dependencies and create a user
RUN apt-get update \
    && apt-get install -y ca-certificates tzdata libssl-dev gosu \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd ssl-cert \
    && useradd $APP_USER \
    && usermod -aG ssl-cert $APP_USER \
    && mkdir -p ${APP} \
    && mkdir -p /etc/ssl/private \
    && chmod 0750 /etc/ssl/private \
    && chown root:ssl-cert /etc/ssl/private

COPY --from=builder /app/target/release/server ${APP}/server
COPY --from=builder /app/server/static ${APP}/static
COPY ./server/entrypoint.sh /entrypoint.sh

RUN chown -R $APP_USER:$APP_USER ${APP} && chmod +x /entrypoint.sh

WORKDIR ${APP}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["./server"]
