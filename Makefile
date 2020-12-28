### Makefile ---

## Author: Shell.Xu
## Version: $Id: Makefile,v 0.0 2017/01/17 03:44:24 shell Exp $
## Copyright: 2017, Eleme <zhixiang.xu@ele.me>, BizSeer <chengshiwen0103@gmail.com>
## License: MIT
## Keywords:
## X-URL:

export GO_BUILD=GO111MODULE=on CGO_ENABLED=0 GOPROXY=https://goproxy.cn,https://goproxy.io,direct go build -o bin/influx-proxy -a -ldflags "-s -w -X main.GitCommit=$(shell git rev-parse --short HEAD) -X 'main.BuildTime=$(shell date '+%Y-%m-%d %H:%M:%S')'"

.PHONY: build linux test bench run lint down tidy clean

all: build

build:
	$(GO_BUILD)

linux:
	GOOS=linux GOARCH=amd64 $(GO_BUILD)

test:
	rm -rf data/test && mkdir -p data/test
	go test -v github.com/chengshiwen/influx-proxy/backend

bench:
	go test -bench=. -run=none github.com/chengshiwen/influx-proxy/backend

run:
	go run main.go

lint:
	golangci-lint run --enable=golint --disable=errcheck --disable=typecheck && goimports -l -w . && go fmt ./... && go vet ./...

down:
	go list ./... && go mod verify

tidy:
	head -n 3 go.mod > go.mod.tmp && mv go.mod.tmp go.mod && rm -f go.sum && go mod tidy -v

clean:
	rm -rf bin data

### Makefile ends here
