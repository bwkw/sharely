##
## Build
##
FROM golang:1.20.5-alpine AS build

WORKDIR /app

COPY server/go.mod ./
COPY server/go.sum ./
RUN go mod download

COPY server/*.go ./

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
