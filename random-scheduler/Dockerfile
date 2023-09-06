# build stage
FROM golang:1.19.4 as builder

WORKDIR /workspace

# Copy the Go Modules manifests
COPY random-scheduler/go.mod go.mod
COPY random-scheduler/go.sum go.sum

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY random-scheduler/scheduler/main.go main.go

# Vet
RUN GOOS=linux GOARCH=amd64 GO111MODULE=on go vet ./...
# Test
RUN GOOS=linux GOARCH=amd64 GO111MODULE=on go test ./... -coverprofile cover.out -coverpkg=./...
# Build
RUN GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o random-scheduler -ldflags "-X main.Version=$VERSION" main.go

FROM centos:7

COPY --from=builder /workspace/random-scheduler random-scheduler
ENTRYPOINT ["/random-scheduler"]

