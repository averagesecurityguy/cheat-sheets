#!/bin/sh

echo "Checking formatting..."
if [ "$(gofmt -w -l . | wc -l)" -gt 0 ]; then
        echo "Please run go fmt"
        exit 1
fi

echo "Checking tests..."
go test
