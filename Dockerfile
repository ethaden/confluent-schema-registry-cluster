ARG CP_VERSION="7.9.0"
FROM confluentinc/cp-schema-registry:${CP_VERSION} AS schema-registry-image-builder
ARG FAKETIME_TAG="v0.9.10"
USER root
RUN dnf install -y make gcc git

# Get the sources and checkout at stable release 0.98
# see https://github.com/wolfcw/libfaketime/releases
RUN cd / && git clone https://github.com/wolfcw/libfaketime.git -b ${FAKETIME_TAG} && \
    cd libfaketime && \
    make

ARG CP_VERSION="7.9.0"
FROM confluentinc/cp-schema-registry:${CP_VERSION} AS schema-registry-faketime

COPY --from=schema-registry-image-builder /libfaketime/src/libfaketime.so.1 /usr/local/lib
COPY --from=schema-registry-image-builder /libfaketime/src/libfaketimeMT.so.1 /usr/local/lib
ENV LD_PRELOAD=/usr/local/lib/libfaketime.so.1
ENV FAKETIME=""
