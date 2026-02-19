# Multi-stage build for ghcr.io/hanzoai/zrok
# Stage 1: Build Node UI
FROM node:22-alpine AS ui-builder

WORKDIR /src

# Build main console UI
COPY ui/package*.json ui/
RUN cd ui && npm ci
COPY ui/ ui/
RUN cd ui && npm run build

# Build agent UI
COPY agent/agentUi/package*.json agent/agentUi/
RUN cd agent/agentUi && npm ci
COPY agent/agentUi/ agent/agentUi/
RUN cd agent/agentUi && npm run build

# Stage 2: Build zrok2 binary from source (Debian for CGO/sqlite3 compat)
FROM golang:1.25-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
COPY --from=ui-builder /src/ui/dist ui/dist
COPY --from=ui-builder /src/agent/agentUi/dist agent/agentUi/dist
RUN CGO_ENABLED=1 go build -tags sqlite_foreign_keys -ldflags '-s -w -extldflags "-static"' -o /usr/local/bin/zrok2 ./cmd/zrok2/

# Stage 2: Runtime image
FROM docker.io/openziti/ziti-cli:latest

LABEL name="hanzoai/zrok" \
      maintainer="dev@hanzo.ai" \
      vendor="Hanzo" \
      summary="zrok - zero-trust sharing platform" \
      description="zrok - zero-trust sharing platform by Hanzo" \
      org.opencontainers.image.description="zrok - zero-trust sharing platform" \
      org.opencontainers.image.source="https://github.com/hanzoai/zrok"

USER root

RUN mkdir -p -m0755 /licenses /usr/local/bin
COPY --from=builder /usr/local/bin/zrok2 /usr/local/bin/zrok2
COPY --chmod=0755 ./nfpm/zrok2-enable.bash /usr/local/bin/zrok2-enable
COPY ./LICENSE /licenses/apache.txt

# symlink zrok -> zrok2 for convenience
RUN ln -sf /usr/local/bin/zrok2 /usr/local/bin/zrok

USER ziggy
ENTRYPOINT [ "zrok2" ]
