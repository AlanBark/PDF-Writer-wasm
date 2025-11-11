# Building PDF-Writer for WebAssembly

Complete guide for compiling PDF-Writer to WebAssembly using Emscripten.

## Quick Start

### 1. Install Emscripten (One-time Setup)

```bash
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
emsdk install latest
emsdk activate latest
```

### 2. Activate Emscripten (Every Build Session)

**IMPORTANT**: Run this in every new terminal before building:

```bash
# Windows
cd path\to\emsdk
emsdk_env.bat

# Linux/macOS
cd path/to/emsdk
source ./emsdk_env.sh
```

### 3. Build

```bash
cd c:\Users\Shado\Documents\Projects\PDF-Writer
build-wasm.bat        # Windows
./build-wasm.sh       # Linux/macOS
```

### 4. Test

```bash
python -m http.server 8000
# Open http://localhost:8000/examples/wasm-test.html
```

## What Gets Built

After a successful build:

```
build-wasm/
├── wasm/
│   ├── pdfwriter.js      ← JavaScript loader (import this in your code)
│   ├── pdfwriter.wasm    ← WebAssembly binary
│   └── ...
└── PDFWriter/
    └── libPDFWriter.a    ← Static library (used internally)
```

## Using in Your Code

### Basic Example

```javascript
import createPDFWriterModule from './build-wasm/wasm/pdfwriter.js';

// Initialize
const pdfWriter = await createPDFWriterModule();

// Test it works
console.log(pdfWriter.getVersion());        // "PDF-Writer 4.7.0 (WebAssembly)"
console.log(pdfWriter.testBindings());      // 42

// Create a PDF
const result = pdfWriter.createSimplePDF('/output.pdf');
if (result === 0) {
    // Success! Read from virtual filesystem
    const pdfData = pdfWriter.FS.readFile('/output.pdf');

    // Download it
    const blob = new Blob([pdfData], { type: 'application/pdf' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'document.pdf';
    a.click();
}
```

## Available Functions

Current bindings (see [wasm/pdfwriter_bindings.cpp](wasm/pdfwriter_bindings.cpp)):

- **`testBindings()`** - Returns 42 (for testing)
- **`getVersion()`** - Returns version string
- **`createSimplePDF(path)`** - Creates a blank PDF
  - Returns 0 on success, negative on error
  - Creates file in virtual filesystem

## Adding More Functions

Edit [wasm/pdfwriter_bindings.cpp](wasm/pdfwriter_bindings.cpp):

```cpp
// Add your function
int myFunction(const std::string& input) {
    // Implementation using PDFWriter API
    return 0;
}

// Add to bindings section
EMSCRIPTEN_BINDINGS(pdfwriter_module) {
    function("createSimplePDF", &createSimplePDF);
    function("getVersion", &getVersion);
    function("testBindings", &testBindings);
    function("myFunction", &myFunction);  // Add this
}
```

Rebuild with `build-wasm.bat` and use in JavaScript:
```javascript
const result = pdfWriter.myFunction("test");
```

## Troubleshooting

### "emcc not found"
You forgot to run `emsdk_env.bat` in this terminal session.

**Fix:**
```bash
cd path\to\emsdk
emsdk_env.bat
cd c:\Users\Shado\Documents\Projects\PDF-Writer
```

### Build fails with CMake errors
Clean and rebuild:
```bash
rmdir /s /q build-wasm    # Windows
rm -rf build-wasm         # Linux/macOS
build-wasm.bat
```

### Module fails to load in browser
- Must use HTTP server (not `file://`)
- Check browser console for errors
- Verify path to `pdfwriter.js` is correct

### Functions are undefined
Check available functions:
```javascript
const pdfWriter = await createPDFWriterModule();
console.log(Object.keys(pdfWriter));
```

## Technical Details

### Emscripten Compatibility

PDF-Writer uses `std::basic_string<unsigned char>` (ByteList) which requires a custom `char_traits` specialization for Emscripten. This is automatically provided via [wasm/emscripten_fixes.h](wasm/emscripten_fixes.h).

### Build Configuration

The build uses:
- Bundled dependencies (Zlib, FreeType, LibJpeg, LibPng, LibTiff)
- OpenSSL disabled (reduces size)
- Emscripten's virtual filesystem enabled
- ES6 module output

### File Structure

```
PDF-Writer/
├── wasm/                          ← WebAssembly bindings
│   ├── CMakeLists.txt            ← Build config
│   ├── pdfwriter_bindings.cpp    ← C++ ↔ JS bindings
│   └── emscripten_fixes.h        ← Compatibility fixes
├── build-wasm.bat                 ← Build script (Windows)
├── build-wasm.sh                  ← Build script (Linux/macOS)
├── examples/
│   ├── wasm-test.html            ← Interactive test page
│   └── wasm-example.js           ← Usage examples
└── WASM-README.md                 ← This file
```

## Next Steps

1. **Explore the test page** - [examples/wasm-test.html](examples/wasm-test.html)
2. **Add PDF features** - Edit [wasm/pdfwriter_bindings.cpp](wasm/pdfwriter_bindings.cpp)
3. **Optimize build** - Add Emscripten flags in [wasm/CMakeLists.txt](wasm/CMakeLists.txt)
4. **Integrate** - Use in your web application

## Resources

- [Emscripten Documentation](https://emscripten.org/docs/porting/connecting_cpp_and_javascript/embind.html)
- [PDF-Writer Wiki](https://github.com/galkahana/PDF-Writer/wiki)
- [PDF-Writer API](https://github.com/galkahana/PDF-Writer/tree/master/PDFWriter)
