FROM tarantool/tarantool:2.1 as builder
COPY ./app /opt/tarantool/app
RUN apk add --no-cache git build-base \
    cmake make coreutils sed \
    autoconf automake libtool zlib-dev \
    readline-dev ncurses-dev openssl-dev \
    libunwind-dev
RUN cd /opt/tarantool && \
    tarantoolctl rocks install http

FROM tarantool/tarantool:2.1
COPY --from=builder /opt/tarantool/ /opt/tarantool/
CMD ["tarantool", "/opt/tarantool/app/app.lua"]
