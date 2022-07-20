#!/usr/bin/env bash

PROTOC_TARGET_PATH="/usr/local"
if [ -f "$PROTOC_TARGET_PATH/bin/protoc" ]; then exit 0; fi
echo "Installing protoc..."

mkdir "$PROTOC_TARGET_PATH"
PROTOC_TEMP_DIR=".temp"
mkdir "$PROTOC_TEMP_DIR"

PROTOC_LINK="https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protoc-3.20.1-linux-x86_64.zip"
PROTOC_TEMP_FILE_PATH="$PROTOC_TEMP_DIR/protoc.zip"
sudo curl -L "$PROTOC_LINK" -o "$PROTOC_TEMP_FILE_PATH"

sudo unzip -o "$PROTOC_TEMP_FILE_PATH" -d "$PROTOC_TARGET_PATH"

rm -rf "$PROTOC_TEMP_DIR"
