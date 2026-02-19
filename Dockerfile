# Multi-stage build for ghcr.io/hanzoai/zrok
# Stage 1: Build zrok2 binary from source
FROM golang:1.25-alpine AS builder

RUN apk add --no-cache git gcc musl-dev

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /usr/local/bin/zrok2 ./cmd/zrok2/

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
