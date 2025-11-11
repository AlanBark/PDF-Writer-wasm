#!/bin/bash
# Build script for PDF-Writer WebAssembly compilation (Linux/macOS)
# This script automates the WebAssembly build process

set -e  # Exit on error

echo "========================================"
echo "PDF-Writer WebAssembly Build Script"
echo "========================================"
echo ""

# Check if Emscripten is available
if ! command -v emcc &> /dev/null; then
    echo "ERROR: Emscripten not found in PATH!"
    echo ""
    echo "Please install Emscripten:"
    echo "  1. git clone https://github.com/emscripten-core/emsdk.git"
    echo "  2. cd emsdk"
    echo "  3. ./emsdk install latest"
    echo "  4. ./emsdk activate latest"
    echo "  5. source ./emsdk_env.sh"
    echo ""
    exit 1
fi

echo "Found Emscripten:"
emcc --version
echo ""

# Create build directory
BUILD_DIR="build-wasm"
if [ ! -d "$BUILD_DIR" ]; then
    echo "Creating build directory: $BUILD_DIR"
    mkdir -p "$BUILD_DIR"
fi

cd "$BUILD_DIR"

echo "========================================"
echo "Configuring CMake with Emscripten..."
echo "========================================"
echo ""

# Configure with emcmake
emcmake cmake .. \
  -DUSE_BUNDLED=TRUE \
  -DPDFHUMMUS_NO_OPENSSL=TRUE \
  -DCMAKE_BUILD_TYPE=Release \
  -G "Unix Makefiles"

echo ""
echo "========================================"
echo "Building with Emscripten..."
echo "========================================"
echo ""

# Build with emmake
emmake cmake --build . --config Release -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo ""
echo "========================================"
echo "Build completed successfully!"
echo "========================================"
echo ""
echo "Output files are in: $BUILD_DIR"
echo "Look for .wasm and .js files"
echo ""

cd ..
