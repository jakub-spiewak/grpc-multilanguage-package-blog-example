#!/usr/bin/env bash

KOTLIN_PLUGIN_LINK=https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-kotlin/1.3.0/protoc-gen-grpc-kotlin-1.3.0-jdk8.jar
JAVA_PLUGIN_LINK=https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.47.0/protoc-gen-grpc-java-1.47.0-linux-x86_64.exe
JS_PLUGIN_LINK=https://github.com/grpc/grpc-web/releases/download/1.3.1/protoc-gen-grpc-web-1.3.1-linux-x86_64

TARGET_PLUGINS_DIR="/usr/local/bin"

TARGET_KOTLIN_PLUGIN_JAR_PATH="$TARGET_PLUGINS_DIR/protoc-gen-grpc-kotlin.jar"
TARGET_KOTLIN_PLUGIN_PATH="$TARGET_PLUGINS_DIR/protoc-gen-grpckt"
TARGET_JAVA_PLUGIN_PATH="$TARGET_PLUGINS_DIR/protoc-gen-grpc-java"
TARGET_JS_PLUGIN_PATH="$TARGET_PLUGINS_DIR/protoc-gen-grpc-web"

if [ ! -f "$TARGET_KOTLIN_PLUGIN_PATH" ]; then
  echo "Installing protoc Kotlin plugin..."
  echo "java -jar $TARGET_KOTLIN_PLUGIN_JAR_PATH" >"$TARGET_KOTLIN_PLUGIN_PATH"
  curl -L "$KOTLIN_PLUGIN_LINK" -o "$TARGET_KOTLIN_PLUGIN_JAR_PATH"
  chmod +x "$TARGET_KOTLIN_PLUGIN_PATH"
fi

if [ ! -f "$TARGET_JAVA_PLUGIN_PATH" ]; then
  echo "Installing protoc Java plugin..."
  curl -L "$JAVA_PLUGIN_LINK" -o "$TARGET_JAVA_PLUGIN_PATH"
  chmod +x "$TARGET_JAVA_PLUGIN_PATH"
fi

if [ ! -f "$TARGET_JS_PLUGIN_PATH" ]; then
  echo "Installing protoc JS plugin..."
  curl -L "$JS_PLUGIN_LINK" -o "$TARGET_JS_PLUGIN_PATH"
  chmod +x "$TARGET_JS_PLUGIN_PATH"
fi
