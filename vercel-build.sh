#!/bin/bash

# Install Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

export PATH="$PATH:$(pwd)/flutter/bin"

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web
flutter build web --release

# Copy build files to web folder
mkdir -p web
cp -r build/web/* web/
