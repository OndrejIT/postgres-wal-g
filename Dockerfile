FROM docker.io/golang:buster AS builder

ENV WALG_VERSION=v2.0.1

RUN apt-get update && \
	apt-get install -y \
		wget cmake git libbrotli-dev libsodium-dev curl liblzo2-dev && \
	git clone https://github.com/wal-g/wal-g/  $GOPATH/src/wal-g && \
	cd $GOPATH/src/wal-g/ && \
	git checkout $WALG_VERSION && \
	make install && \
	make deps && \
	make pg_build && \
	install main/pg/wal-g /usr/local/bin/wal-g


FROM docker.io/postgres:15.2-alpine

COPY --from=builder /usr/local/bin/wal-g /usr/local/bin/

ADD bin/* /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
ADD docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/

RUN \
	apk add -U gcompat musl-locales tzdata && \
	chmod +x /usr/local/bin/docker-entrypoint.sh && \
	chmod +x /docker-entrypoint-initdb.d/* && \
	chmod +x /usr/local/bin/wal-g /usr/local/bin/backup /usr/local/bin/restore && \
	rm -rf /var/cache/apk/*
