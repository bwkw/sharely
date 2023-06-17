##
## Build
##
FROM golang:1.20.5-alpine AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o main .

##
## Deploy
##
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /app/main /app/main

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/app/main"]
