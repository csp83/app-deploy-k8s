FROM golang:1.18-alpine3.15

RUN apk add build-base sudo

# add non-root user
RUN adduser -D -u 1001 gouser \
        && echo "gouser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/gouser \
        && chmod 0440 /etc/sudoers.d/gouser

USER gouser

WORKDIR /build/
COPY . .

RUN GOOS=linux
RUN sudo go build -o app .

ENTRYPOINT ["./app"]
