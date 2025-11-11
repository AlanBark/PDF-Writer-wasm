/**
 * PDF-Writer WebAssembly Example
 * This example demonstrates how to use the PDF-Writer library compiled to WebAssembly
 */

// Import the WASM module (adjust path as needed)
import createPDFWriterModule from '../build-wasm/PDFWriter/PDFWriter.js';

/**
 * Initialize the PDF-Writer WebAssembly module
 * @returns {Promise} Resolves with the initialized WASM module
 */
async function initPDFWriter() {
    try {
        console.log('Loading PDF-Writer WASM module...');
        const Module = await createPDFWriterModule();
        console.log('PDF-Writer WASM module loaded successfully!');
        return Module;
    } catch (error) {
        console.error('Failed to load PDF-Writer WASM module:', error);
        throw error;
    }
}

/**
 * Example: Create a simple PDF file
 * @param {Object} Module - The initialized WASM module
 */
async function createSimplePDF(Module) {
    try {
        console.log('Creating simple PDF...');

        // The actual implementation will depend on how PDF-Writer exports its API
        // This is a template showing the general pattern

        // Example pattern using ccall/cwrap:
        // const createPDF = Module.cwrap('CreatePDF', 'number', ['string']);
        // const result = createPDF('/output.pdf');

        // Or using the filesystem:
        // Module.FS.writeFile('/input.txt', 'Hello from WebAssembly!');
        // ... perform PDF operations ...
        // const pdfData = Module.FS.readFile('/output.pdf');

        console.log('PDF created successfully!');

    } catch (error) {
        console.error('Error creating PDF:', error);
        throw error;
    }
}

/**
 * Example: Read and manipulate an existing PDF
 * @param {Object} Module - The initialized WASM module
 * @param {ArrayBuffer} pdfData - The PDF file data
 */
async function manipulatePDF(Module, pdfData) {
    try {
        console.log('Manipulating PDF...');

        // Write the PDF data to the virtual filesystem
        const uint8Array = new Uint8Array(pdfData);
        Module.FS.writeFile('/input.pdf', uint8Array);

        // Perform PDF operations (example - adjust based on actual API)
        // const result = Module.ccall('ProcessPDF', 'number',
        //     ['string', 'string'],
        //     ['/input.pdf', '/output.pdf']
        // );

        // Read the result
        // const outputData = Module.FS.readFile('/output.pdf');

        console.log('PDF manipulation completed!');

        // Return the processed PDF data
        // return outputData.buffer;

    } catch (error) {
        console.error('Error manipulating PDF:', error);
        throw error;
    }
}

/**
 * Helper: Convert File object to ArrayBuffer
 * @param {File} file - The file to convert
 * @returns {Promise<ArrayBuffer>}
 */
function fileToArrayBuffer(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = reject;
        reader.readAsArrayBuffer(file);
    });
}

/**
 * Helper: Download blob as file
 * @param {Blob} blob - The blob to download
 * @param {string} filename - The filename for download
 */
function downloadBlob(blob, filename) {
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

/**
 * Main function demonstrating usage
 */
async function main() {
    try {
        // Initialize the WASM module
        const Module = await initPDFWriter();

        // Example 1: Create a simple PDF
        await createSimplePDF(Module);

        // Example 2: If you have a PDF file input
        // const fileInput = document.getElementById('pdfInput');
        // if (fileInput.files.length > 0) {
        //     const pdfData = await fileToArrayBuffer(fileInput.files[0]);
        //     const processedPDF = await manipulatePDF(Module, pdfData);
        //
        //     // Download the result
        //     const blob = new Blob([processedPDF], { type: 'application/pdf' });
        //     downloadBlob(blob, 'output.pdf');
        // }

    } catch (error) {
        console.error('Error in main:', error);
    }
}

// Export functions for use in other modules
export {
    initPDFWriter,
    createSimplePDF,
    manipulatePDF,
    fileToArrayBuffer,
    downloadBlob,
    main
};

// Auto-run if this is the main module
if (import.meta.url === new URL(document.currentScript?.src || '', location.href).href) {
    main();
}
