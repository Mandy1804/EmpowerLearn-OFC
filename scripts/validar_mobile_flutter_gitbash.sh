#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.."

cd flutter

echo "=== Flutter pub get ==="
flutter pub get

echo ""
echo "=== Flutter analyze ==="
flutter analyze

echo ""
echo "=== Flutter test ==="
flutter test

echo ""
echo "=== INTERNET permission ==="
grep -n "android.permission.INTERNET" android/app/src/main/AndroidManifest.xml

echo ""
echo "=== API_BASE_URL ==="
grep -R "String.fromEnvironment" -n lib/services/api_service.dart

echo ""
echo "Validacao mobile concluida com sucesso."
