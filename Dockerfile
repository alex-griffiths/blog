# Builder stage
FROM lukemathwalker/cargo-chef as chef

WORKDIR /app
RUN apt update && apt install lld clang -y

FROM chef as planner
COPY . .

RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /app/recipe.json recipe.json

RUN cargo chef cook --release --recipe-path recipe.json

COPY . .
ENV SQLX_OFFLINE true

RUN cargo build --release --bin blog

# Runtime stage
from debian:trixie-slim as runtime

WORKDIR /app

# Install OpenSSL
# Install ca-certificates

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


# Copy the compiled binary from the builder env.
COPY --from=builder /app/target/release/blog blog

COPY configuration configuration
ENV APP_ENVIRONMENT production

ENTRYPOINT ["./blog"]