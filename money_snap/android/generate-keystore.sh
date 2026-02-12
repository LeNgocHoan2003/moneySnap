#!/bin/bash

# Script to generate release keystore for Money Snap
# Run this script from the android directory: cd android && ./generate-keystore.sh

echo "Generating release keystore for Money Snap..."
echo ""

# Check if Java is available
if ! command -v keytool &> /dev/null; then
    echo "Error: keytool not found. Please install Java JDK."
    echo "On macOS, you can install it with: brew install openjdk"
    exit 1
fi

# Navigate to app directory
cd app || exit 1

# Generate keystore
keytool -genkey -v \
    -keystore upload-keystore.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias upload \
    -storetype JKS \
    -dname "CN=Money Snap, OU=Development, O=Money Snap, L=City, ST=State, C=VN" \
    -storepass android \
    -keypass android

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Keystore generated successfully!"
    echo "  Location: android/app/upload-keystore.jks"
    echo ""
    echo "⚠️  IMPORTANT:"
    echo "  1. Change the default passwords in android/key.properties"
    echo "  2. Keep the keystore file secure and backed up"
    echo "  3. Do NOT commit the keystore file to version control"
    echo ""
else
    echo ""
    echo "✗ Failed to generate keystore"
    exit 1
fi
