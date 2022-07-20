#!/usr/bin/env bash
SCRIPTS_DIR_PATH=$(dirname "$(realpath -s "$0")")
PROJECT_ROOT_PATH=$(realpath -s "$SCRIPTS_DIR_PATH/..")

PROTO_FILES_PATH="$PROJECT_ROOT_PATH/proto"
GENERATED_PATH="$PROJECT_ROOT_PATH/generated"

JVM_TARGET_ROOT_PATH="$GENERATED_PATH/jvm"
WEB_TARGET_ROOT_PATH="$GENERATED_PATH/web"
WEB_TARGET_SRC_PATH="$WEB_TARGET_ROOT_PATH/src"

JAVA_TARGET_PATH="$JVM_TARGET_ROOT_PATH/src/main/java"
KOTLIN_TARGET_PATH="$JVM_TARGET_ROOT_PATH/src/main/kotlin"
WEB_TARGET_PATH="$WEB_TARGET_SRC_PATH/generated"

WEB_TARGET_ENTRY_FILE_PATH="$WEB_TARGET_SRC_PATH/index.js"
WEB_TARGET_DECLARATION_TYPES_FILE_PATH="$WEB_TARGET_SRC_PATH/index.d.js"

function clear_dir() {
  rm -rf "$1" &>/dev/null
  mkdir -p "$1"
}

function clear_file() {
  rm "$1" &>/dev/null
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

function generate_grpc() {
  proto_file=$1
  echo "[$proto_file]"
  protoc -I="$PROTO_FILES_PATH" \
    \
    --js_out=import_style=commonjs,binary:"$WEB_TARGET_PATH" \
    --grpc-web_out=import_style=commonjs+dts,mode=grpcweb:"$WEB_TARGET_PATH" \
    \
    --grpc-java_out="$JAVA_TARGET_PATH" \
    --java_out="$JAVA_TARGET_PATH" \
    \
    --grpckt_out="$KOTLIN_TARGET_PATH" \
    --kotlin_out="$KOTLIN_TARGET_PATH" \
    \
    "$proto_file"
}

function append_web_entry_file() {
  relative_file_path=${1#"$WEB_TARGET_SRC_PATH"}
  file_name=${relative_file_path%.js}
  echo "export * from \".$file_name\";" >>"$WEB_TARGET_ENTRY_FILE_PATH"
  echo "export * from \".$file_name\";" >>"$WEB_TARGET_DECLARATION_TYPES_FILE_PATH"
}

function clean() {
  clear_dir "$JAVA_TARGET_PATH"
  clear_dir "$KOTLIN_TARGET_PATH"
  clear_dir "$WEB_TARGET_PATH"
  clear_file "$WEB_TARGET_ENTRY_FILE_PATH"
  clear_file "$WEB_TARGET_DECLARATION_TYPES_FILE_PATH"
}

function generate() {
  find "$PROTO_FILES_PATH" -type f -name "*.proto" | while read -r proto_file; do generate_grpc "$proto_file"; done
}

function generate_web_entry_files() {
  find "$WEB_TARGET_PATH" -type f -name "*.js" ! -name "*.d.ts" | while read -r js_file; do append_web_entry_file "$js_file"; done
  generate_web_entry_files
}

function publish_gradle() {
  version=$1
  gradle -p="$JVM_TARGET_ROOT_PATH" publish -Pversion="$version"
  echo "publishing gradle..."
}

function publish_npm() {
  version=$1
  npm --prefix "$WEB_TARGET_ROOT_PATH" version "$version"
  npm publish "$WEB_TARGET_ROOT_PATH"
}

function publish() {
  git fetch --all --tags
  version=$(git describe --tags)
  publish_gradle "$version"
  publish_npm "$version"
}

echo "Removing all previous generated files..."
clean

echo "Generating gRPC code from:"
generate

echo "Publishing..."
publish

exit 0
