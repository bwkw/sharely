## What is
Calendar

## How to start Go http server
1. Build docker image 

```
docker build -t go-test -f infra/docker/server/Dockerfile .
````

2. Run docker image

```
docker run -p 8080:8080 go-test
```
