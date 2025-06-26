#!/bin/bash

# Make sure the script is executable with:
# chmod +x extract_pdf_text.sh

# Set a longer timeout for OCR processing
OCR_TIMEOUT=180

# Check if the standard service is running
echo "Checking if the standard data extraction service is running..."
if ! curl -s http://localhost:8090/ping/ | grep -q "Running!"; then
  echo "Warning: Standard data extraction service is not running or not responding."
  echo "Please ensure the service is up with: docker-compose up -d"
  STANDARD_SERVICE_RUNNING=false
else
  STANDARD_SERVICE_RUNNING=true
fi

# Check if the Tika-OCR service is running
echo "Checking if the basic Tika-OCR service is running..."
if ! curl -s http://localhost:8093/ping/ | grep -q "Running!"; then
  echo "Warning: Basic Tika-OCR service is not running or not responding."
  echo "Please ensure the service is up with: docker-compose up -d tika-ocr"
  TIKA_OCR_SERVICE_RUNNING=false
else
  TIKA_OCR_SERVICE_RUNNING=true
fi

# Exit if no service is running
if [ "$STANDARD_SERVICE_RUNNING" = false ] && [ "$TIKA_OCR_SERVICE_RUNNING" = false ]; then
  echo "Error: No extraction services are running. Exiting."
  exit 1
fi

# Try to extract text using the standard service first
if [ "$STANDARD_SERVICE_RUNNING" = true ]; then
  echo "Attempting to extract text from big.pdf using standard service..."
  echo "===== STANDARD SERVICE RESULTS ====="
  STANDARD_RESULT=$(curl -s -X PUT http://localhost:8090/extract_text/ -T big.pdf)
  echo "$STANDARD_RESULT"
  echo "======================================"
fi

# Then try the basic Tika-OCR service
if [ "$TIKA_OCR_SERVICE_RUNNING" = true ]; then
  echo "Attempting to extract text from big.pdf using Tika-OCR service..."
  echo "===== TIKA-OCR SERVICE RESULTS ====="
  TIKA_OCR_RESULT=$(curl -s --max-time $OCR_TIMEOUT -X PUT http://localhost:8093/extract_text/ -T big.pdf)
  echo "$TIKA_OCR_RESULT"
  echo "======================================"
fi

echo -e "\nText extraction completed."
echo "The OCR service provides better results for images and scanned PDFs."
echo "If OCR extraction fails, try running ./debug_ocr.sh for diagnostic information." 