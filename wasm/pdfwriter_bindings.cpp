/**
 * PDF-Writer WebAssembly Bindings
 * This file creates JavaScript-accessible bindings for the PDF-Writer library
 */

// IMPORTANT: Include Emscripten fixes BEFORE any PDF-Writer headers
#include "emscripten_fixes.h"

#include <emscripten/bind.h>
#include <emscripten/val.h>
#include "../PDFWriter/PDFWriter.h"
#include "../PDFWriter/PDFPage.h"
#include "../PDFWriter/PageContentContext.h"
#include "../PDFWriter/PDFUsedFont.h"

using namespace emscripten;

/**
 * Simple PDF creation example function
 * Creates a basic "Hello World" PDF (simplified version without text)
 */
int createSimplePDF(const std::string& outputPath) {
    PDFWriter pdfWriter;
    EStatusCode status;

    // Start PDF with default settings
    status = pdfWriter.StartPDF(outputPath, ePDFVersion13);
    if (status != eSuccess) {
        return -1;
    }

    // Create a simple blank page
    PDFPage* page = new PDFPage();
    page->SetMediaBox(PDFRectangle(0, 0, 595, 842)); // A4 size

    // Write the page
    status = pdfWriter.WritePage(page);
    delete page;
    if (status != eSuccess) {
        return -4;
    }

    // Finalize the PDF
    status = pdfWriter.EndPDF();
    if (status != eSuccess) {
        return -5;
    }

    return 0; // Success
}

/**
 * Get library version information
 */
std::string getVersion() {
    return "PDF-Writer 4.7.0 (WebAssembly)";
}

/**
 * Test function to verify bindings are working
 */
int testBindings() {
    return 42;
}

// Emscripten bindings
EMSCRIPTEN_BINDINGS(pdfwriter_module) {
    function("createSimplePDF", &createSimplePDF);
    function("getVersion", &getVersion);
    function("testBindings", &testBindings);

    // You can add more bindings here for other PDF-Writer functionality
    // Example:
    // class_<PDFWriter>("PDFWriter")
    //     .constructor<>()
    //     .function("StartPDF", &PDFWriter::StartPDF)
    //     .function("EndPDF", &PDFWriter::EndPDF);
}
