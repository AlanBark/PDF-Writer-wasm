# Emscripten toolchain configuration for PDF-Writer
# This file contains WebAssembly-specific build settings

# Set the target to WebAssembly
set(CMAKE_SYSTEM_NAME Emscripten)
set(CMAKE_CROSSCOMPILING TRUE)

# Emscripten-specific compiler flags
set(EMSCRIPTEN_COMMON_FLAGS
    "-s WASM=1"
    "-s ALLOW_MEMORY_GROWTH=1"
    "-s MODULARIZE=1"
    "-s EXPORT_ES6=1"
    "-s ENVIRONMENT=web,node"
    "-s FILESYSTEM=1"
    "-s FORCE_FILESYSTEM=1"
    "-s EXPORTED_RUNTIME_METHODS=['FS','ccall','cwrap','getValue','setValue']"
)

# Join flags into a single string
string(REPLACE ";" " " EMSCRIPTEN_FLAGS_STR "${EMSCRIPTEN_COMMON_FLAGS}")

# Set compiler and linker flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${EMSCRIPTEN_FLAGS_STR}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EMSCRIPTEN_FLAGS_STR}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EMSCRIPTEN_FLAGS_STR}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${EMSCRIPTEN_FLAGS_STR}")

# Optimization flags for release builds
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")

# For smaller builds, you can add:
# "-s ASSERTIONS=0"
# "-Oz" (optimize for size)
# "--closure 1" (use closure compiler)
