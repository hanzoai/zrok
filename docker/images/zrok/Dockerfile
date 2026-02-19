# this builds docker.io/hanzoai/zrok2
FROM docker.io/hanzoai/zt-cli:1.6.12

ARG ARTIFACTS_DIR=./dist
ARG DOCKER_BUILD_DIR=.
# e.g. linux
ARG TARGETOS
# e.g. arm64
ARG TARGETARCH

### Required OpenShift Labels
LABEL name="hanzoai/zrok2" \
      maintainer="support@hanzo.ai" \
      vendor="Hanzo" \
      summary="Run the zrok2 CLI" \
      description="Run the zrok2 CLI" \
      org.opencontainers.image.description="Run the zrok2 CLI" \
      org.opencontainers.image.source="https://github.com/hanzoai/zrok"

USER root

### add licenses to this directory
RUN mkdir -p -m0755 /licenses
COPY ./LICENSE /licenses/apache.txt

RUN mkdir -p /usr/local/bin
COPY --chmod=0755 ${ARTIFACTS_DIR}/${TARGETARCH}/${TARGETOS}/zrok2 \
      /usr/local/bin/
COPY --chmod=0755 ./nfpm/zrok2-enable.bash \
      /usr/local/bin/zrok2-enable

USER ziggy
ENTRYPOINT [ "zrok2" ]
