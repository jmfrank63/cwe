FROM rust:latest as builder

# Build stage already defined in the base Dockerfile instructions above.

# The final stage
FROM debian:buster-slim
ARG APP=/usr/src/app

EXPOSE 8080
ENV TZ=Etc/UTC \
    APP_USER=appuser

# Install dependencies and create a user
RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && useradd $APP_USER \
    && mkdir -p ${APP}

COPY --from=builder /app/target/release/server ${APP}/server
COPY --from=builder /app/server/static ${APP}/static

RUN chown -R $APP_USER:$APP_USER ${APP}

USER $APP_USER
WORKDIR ${APP}

CMD ["./server"]
