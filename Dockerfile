FROM golang:1.20-alpine3.17 AS builder

ENV WALG_VERSION=v2.0.1

RUN apk add --no-cache brotli-dev libsodium-dev lzo-dev cmake git build-base bash && \
	git clone https://github.com/wal-g/wal-g/  $GOPATH/src/wal-g && \
	cd $GOPATH/src/wal-g/ && \
	git checkout $WALG_VERSION && \
	make deps && \
	make pg_build && \
	install main/pg/wal-g /usr/local/bin/wal-g


FROM docker.io/postgres:15.2-alpine

COPY --from=builder /usr/local/bin/wal-g /usr/local/bin/

ADD bin/* /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
ADD docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/

RUN \
	apk add --no-cache musl-locales tzdata && \
	chmod +x /usr/local/bin/docker-entrypoint.sh && \
	chmod +x /docker-entrypoint-initdb.d/* && \
	chmod +x /usr/local/bin/wal-g /usr/local/bin/backup /usr/local/bin/restore
