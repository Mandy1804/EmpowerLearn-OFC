#!/usr/bin/env bash
set -e

API_BASE_URL="${API_BASE_URL:-https://empowerlearn-ofc-production.up.railway.app}"

cd "$(dirname "$0")/.."
cd flutter

echo "Gerando APK release com API_BASE_URL=$API_BASE_URL"
flutter build apk --release --dart-define=API_BASE_URL="$API_BASE_URL"

echo ""
echo "APK gerado em:"
echo "flutter/build/app/outputs/flutter-apk/app-release.apk"
