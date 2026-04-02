# Build Stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git

# Update paths to point to Server/MuchToDo
COPY Server/MuchToDo/go.mod Server/MuchToDo/go.sum ./
RUN go mod download

# Copy the specific server source code
COPY Server/MuchToDo/ .

# Build from the main entry point path
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o main ./cmd/api/main.go

# Final Stage
FROM alpine:3.19

# Security: Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app

# Install runtime dependencies for healthchecks
RUN apk add --no-cache curl

# Copy only the binary from builder
COPY --from=builder /app/main .

# Use non-root user
USER appuser

# Documentation
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["./main"]