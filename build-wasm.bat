@echo off
REM Build script for PDF-Writer WebAssembly compilation
REM This script automates the WebAssembly build process

echo ========================================
echo PDF-Writer WebAssembly Build Script
echo ========================================
echo.

REM Check if Emscripten is available
where emcc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Emscripten not found in PATH!
    echo.
    echo Please install Emscripten:
    echo   1. git clone https://github.com/emscripten-core/emsdk.git
    echo   2. cd emsdk
    echo   3. emsdk install latest
    echo   4. emsdk activate latest
    echo   5. emsdk_env.bat
    echo.
    pause
    exit /b 1
)

echo Found Emscripten:
REM Only show version line to avoid license display
for /f "tokens=*" %%a in ('emcc --version 2^>^&1 ^| findstr /C:"emcc"') do echo %%a
echo.

REM Create build directory
set BUILD_DIR=build-wasm
if not exist "%BUILD_DIR%" (
    echo Creating build directory: %BUILD_DIR%
    mkdir "%BUILD_DIR%"
)

cd "%BUILD_DIR%"

echo ========================================
echo Configuring CMake with Emscripten...
echo ========================================
echo.

REM Configure with emcmake
REM Try Ninja first, fallback to NMake or MinGW Makefiles if Ninja is not available
call emcmake cmake .. ^
  -DUSE_BUNDLED=TRUE ^
  -DPDFHUMMUS_NO_OPENSSL=TRUE ^
  -DCMAKE_BUILD_TYPE=Release

REM Alternative: Explicitly specify generator if above fails
REM Uncomment one of these if needed:
REM -G "MinGW Makefiles"
REM -G "NMake Makefiles"
REM -G "Unix Makefiles"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: CMake configuration failed!
    cd ..
    pause
    exit /b 1
)

echo.
echo ========================================
echo Building with Emscripten...
echo ========================================
echo.

REM Build the library first
echo Building PDFWriter library...
cmake --build . --target PDFWriter --config Release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Library build failed!
    cd ..
    pause
    exit /b 1
)

echo.
echo Building WebAssembly bindings...
cmake --build . --target PDFWriterWASM --config Release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: WASM bindings build failed!
    cd ..
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Output files are in: %BUILD_DIR%
echo Look for .wasm and .js files
echo.

cd ..
pause
