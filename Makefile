TOKEN = `cat .token`
REPO := envplate
USER := yawn
VERSION := "v0.0.2"

build:
	mkdir -p out/darwin out/linux
	GOOS=darwin go build -o out/darwin/ep -ldflags "-X main.build `git rev-parse --short HEAD`" bin/envplate.go
	GOOS=linux go build -o out/linux/ep -ldflags "-X main.build `git rev-parse --short HEAD`" bin/envplate.go

release:
	github-release release --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN)
	github-release upload --user yawn --repo envplate --tag $(VERSION) -s $(TOKEN) --name ep-osx --file out/darwin/ep
	github-release upload --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN) --name ep-linux --file out/linux/ep

test:
	DATABASE=db.example.com MODE=debug go test -cover