FROM golang:1.14.6-alpine as builder
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates
RUN adduser -D -g '' appuser

WORKDIR /build

COPY ./cmd ./cmd
COPY hello.go ./
COPY hello_test.go ./
COPY go.mod go.sum ./

ENV GO111MODULE=on
RUN	go mod download
RUN	go mod verify
RUN go test .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o bin/hello cmd/main.go

FROM scratch AS production
LABEL maintainer="udeshike@gmail.com"
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /build/bin ./bin
USER appuser
EXPOSE 8080
CMD ["./bin/hello","-http-port=8080", "-log-level=-1", "-log-time-format=2006-01-02T15:04:05.999Z"] --v