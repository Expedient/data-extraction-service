# OCR-Enabled Data Extraction Service

This document explains how to use the OCR-enabled data extraction service for extracting text from PDFs and images, with automatic Markdown conversion.

## Overview

The repository now includes three data extraction services:

1. **Standard Data Extraction Service** (port 8090)
   - Basic text extraction without OCR capabilities
   - Useful for PDFs with embedded text

2. **Basic Tika OCR Service** (port 8093)
   - Uses Tesseract OCR to extract text from images and scanned PDFs
   - Can process images embedded in PDFs
   - Provides better results for documents with images or scanned content
   - Returns plain text results
   - Simpler implementation focused on core OCR functionality

3. **OCR-Enabled Data Extraction Service with Markdown** (port 8092)
   - Same OCR capabilities as the Basic Tika OCR Service
   - **Automatically converts output to Markdown format**
   - Preserves document structure and formatting
   - Acts as a drop-in replacement for the standard service with enhanced capabilities
   - Uses Microsoft's MarkItDown library for high-quality Markdown conversion

## Getting Started

### Starting the Services

```bash
# Start all services
docker-compose up -d

# Or start just the basic OCR service
docker-compose up -d tika-ocr

# Or start just the OCR service with Markdown conversion
docker-compose up -d ocr-markdown-service
```

### Extracting Text from PDFs

Use the provided script to extract text from PDFs:

```bash
./extract_pdf_text.sh
```

This script will:
1. Check if all services are running
2. Try to extract text using the standard service
3. Try to extract text using the basic Tika OCR service
4. Try to extract text using the OCR-enabled service with Markdown output
5. Display the results from all services for comparison

### Debugging OCR Issues

If you encounter issues with OCR extraction, use the debugging script:

```bash
./debug_ocr.sh
```

This script will:
1. Check if the OCR services are running
2. Test basic text extraction
3. Perform a performance test to measure OCR speed
4. Extract text from a sample PDF

## Manual Usage with curl

### Standard Service (Port 8090)

```bash
curl -X PUT http://localhost:8090/extract_text/ -T your-file.pdf
```

### Basic Tika OCR Service (Port 8093)

```bash
# Extract text with OCR (plain text output)
curl -X PUT http://localhost:8093/extract_text/ -T your-file.pdf
```

### OCR-Enabled Service with Markdown (Port 8092)

```bash
# Extract text with OCR and Markdown conversion
curl -X PUT http://localhost:8092/extract_text/ -T your-file.pdf
```

### Choosing Between OCR Services

- **Basic Tika OCR (8093)**: Faster and simpler, best for applications that need plain text output or will process the text programmatically.
- **OCR with Markdown (8092)**: Better for human readability, document structuring, and when integrating with Markdown-compatible systems.

## Technical Details of the OCR Markdown Service

The OCR Markdown service uses:
- **Python Middleware**: Acts as a proxy between client and Tika OCR service
- **Microsoft MarkItDown**: Converts extracted text to Markdown format
- **Flask**: Lightweight web framework for handling requests
- **Same API Endpoints**: Uses identical API endpoints as the original services

### Architecture

The OCR Markdown service:
1. Receives document extraction requests at `/extract_text/`
2. Forwards these requests to the Tika OCR service
3. Processes the OCR-extracted text through MarkItDown
4. Returns the Markdown-formatted text in the same JSON structure as the original service

This architecture ensures it works as a true drop-in replacement for the standard extraction service, with the added benefit of Markdown output.

### Response Format

The response maintains the same JSON structure as the original service, with the text field containing Markdown-formatted content and an additional `format` field set to "markdown".

Example:
```json
{
  "text": "# Document Title\n\nThis is a paragraph with **bold** and *italic* text.\n\n## Section Header\n\n- List item 1\n- List item 2",
  "format": "markdown",
  "metadata": {
    // Original metadata from Tika OCR
  }
}
```

## Kubernetes Deployment and Performance Optimization

### Optimizing OCR Performance in Kubernetes

The OCR service is optimized for Kubernetes deployment with the following performance enhancements:

1. **Tesseract Configuration Optimizations**:
   - Page Segmentation Mode (PSM) set to 1 for faster processing
   - OCR Engine Mode (OEM) set to 3 for best speed/accuracy balance
   - Maximum file size limitation to prevent resource exhaustion
   - Image preprocessing strategy for optimized recognition

2. **JVM Optimizations**:
   - G1 Garbage Collector for better memory management
   - Memory allocation tuning (Xms/Xmx)
   - String deduplication for reduced memory usage
   - Temp directory in fast memory storage

3. **Resource Management**:
   - Memory requests and limits appropriate for OCR workloads
   - CPU allocation optimized for Tesseract processing
   - In-memory temp storage for faster file operations

4. **Container Configuration**:
   - Alpine-based image for smaller footprint
   - Only necessary language data packages installed
   - Optimized startup parameters

### Scaling in Kubernetes

The service is designed to be horizontally scalable. To adjust based on workload:

```yaml
# In k8s-ocr-deployment.yaml
spec:
  replicas: 4  # Increase for higher throughput
```

For high-volume environments, consider using a Horizontal Pod Autoscaler:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ocr-markdown-service-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ocr-markdown-service
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Troubleshooting

If OCR or Markdown conversion fails:
1. Check if both the OCR service and the Markdown service are running correctly
2. Verify the communication between the services
3. Check if the PDF is corrupt or password-protected
4. Check logs with:
   ```bash
   docker-compose logs tika-ocr
   docker-compose logs ocr-markdown-service
   ```

### Common Issues with the Markdown Conversion

1. **Large Documents**: Very large documents may take longer to process through both OCR and Markdown conversion.
   - Consider setting appropriate timeouts in your client code

2. **Special Characters**: If the OCR text contains certain special characters, the Markdown conversion might handle them differently.
   - The conversion preserves most special characters but may format some differently

3. **Complex Layouts**: Documents with very complex layouts might not convert perfectly to Markdown.
   - The Markdown format has inherent limitations for representing complex layouts 