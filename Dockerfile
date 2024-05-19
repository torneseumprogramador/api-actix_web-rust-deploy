# Use the official Rust image as the base image
FROM rust:1.71 as builder

# Set the working directory
WORKDIR /usr/src/app

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml ./

# Copy the source code
COPY . .

# Build the application
RUN cargo build --release

# Use a smaller base image for the final stage
FROM debian:buster-slim

RUN apt-get update && apt-get install -y \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy the build artifact from the builder stage
COPY --from=builder /usr/src/app/target/release/console .

# Expose the port the app runs on
EXPOSE 8080

# Run the application
CMD ["./console"]
