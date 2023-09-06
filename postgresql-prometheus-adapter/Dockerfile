# Build the manager binary
FROM golang:1.19.4 as builder
ARG VERSION

WORKDIR /workspace

# Copy the Go Modules manifests
COPY postgresql-prometheus-adapter/go.mod go.mod
COPY postgresql-prometheus-adapter/go.sum go.sum

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY postgresql-prometheus-adapter/main.go main.go
COPY postgresql-prometheus-adapter/pkg/postgresql pkg/postgresql

# Vet
RUN GOOS=linux GOARCH=amd64 GO111MODULE=on go vet ./...
# Test
RUN GOOS=linux GOARCH=amd64 GO111MODULE=on go test ./... -coverprofile cover.out -coverpkg=./...
# Build
RUN GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o postgresql-prometheus-adapter -ldflags "-X main.Version=$VERSION" main.go

FROM centos:7

COPY --from=builder /workspace/postgresql-prometheus-adapter postgresql-prometheus-adapter
COPY postgresql-prometheus-adapter/start.sh /

ENTRYPOINT ["/start.sh"]

