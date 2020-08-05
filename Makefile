name = hello
image_name = hello-go
image_tag = latest

.PHONY: greet
greet:
	@printf "\n============= Hello =============\n"

# Binary build related targets
.PHONY: verify
verify:
	@printf "\n============= Verifying =============\n"
	GO111MODULE=on
	go mod download
	go mod verify

.PHONY: build
build: verify
	@printf "\n============= Building =============\n"
	go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o bin/$(name) cmd/main.go

.PHONY: run
run:
	@bin/$(name)

.PHONY: test
test: verify
	@printf "\n============= Running Tests =============\n"
	go test .

.PHONY: all
all: test build run

.PHONY: clean
clean:
	@rm -rf bin/ 2>/dev/null || true
	@rm go.sum 2>/dev/null || true
# End of binary build related outputs

# Docker build related targets
	
.PHONY: dockerbuild
dockerbuild: test
	@printf "\n============= Building Docker Image '$(image_name):$(image_tag)' =============\n"
	docker build -t $(image_name):$(image_tag) .
	@printf "\n============= Image Details =============\n"
	docker images --filter=reference='$(image_name)'

.PHONY: dockerrun
dockerrun:
	@docker run --rm $(image_name):$(image_tag)
# End of Docker build related targets

# Cross compilation
.PHONY: xcompile
xcompile:
	GOOS=linux GOARCH=386 go build -o bin/$(name)-linux-386 cmd/main.go

# Clean everything including the bin directory and docker images
.PHONY: clean_all
clean_all: clean
	@docker image rm $(image_name) 2>/dev/null || true