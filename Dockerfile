FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc make libc6-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY . .

RUN cd src && make clean && make python

WORKDIR /build/src
CMD ["./python"]
