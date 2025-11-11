# WebAssembly bindings for PDF-Writer

# Create an executable (which will become the WASM module)
add_executable(PDFWriterWASM pdfwriter_bindings.cpp)

# Link against the PDFWriter library
target_link_libraries(PDFWriterWASM PDFWriter)

# Emscripten-specific settings
if(EMSCRIPTEN)
    # Set output file names
    set_target_properties(PDFWriterWASM PROPERTIES
        OUTPUT_NAME "pdfwriter"
        SUFFIX ".js"
    )

    # Emscripten linker flags
    set(EMSCRIPTEN_LINK_FLAGS
        "-lembind"  # Enable embind for C++ bindings
        "-s WASM=1"
        "-s MODULARIZE=1"
        "-s EXPORT_ES6=1"
        "-s EXPORT_NAME='createPDFWriterModule'"
        "-s ALLOW_MEMORY_GROWTH=1"
        "-s FILESYSTEM=1"
        "-s FORCE_FILESYSTEM=1"
        "-s EXPORTED_RUNTIME_METHODS=['FS','ccall','cwrap']"
        "-s ENVIRONMENT=web,node"
        "--bind"  # Enable embind
    )

    # Join flags
    string(REPLACE ";" " " EMSCRIPTEN_LINK_FLAGS_STR "${EMSCRIPTEN_LINK_FLAGS}")

    # Apply link flags
    set_target_properties(PDFWriterWASM PROPERTIES
        LINK_FLAGS "${EMSCRIPTEN_LINK_FLAGS_STR}"
    )
endif()

# Installation (optional)
install(TARGETS PDFWriterWASM
    RUNTIME DESTINATION wasm
)
