# Documentação Mobile - EmpowerLearn.class

## Visão geral

O aplicativo mobile EmpowerLearn.class foi desenvolvido em Flutter/Dart e integra o ecossistema EmpowerLearn. O foco do app é apoiar o processo educacional com funcionalidades de login, cadastro, perfil, cursos, matérias, tarefas, submissões, fórum, comentários, notificações, vídeos, progresso, favoritos, notas e histórico.

## Framework

- Flutter
- Dart
- Android

## Integração

A integração é feita via backend API, usando URL base configurável:

```dart
String.fromEnvironment('API_BASE_URL')
```

Build utilizado:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://empowerlearn-ofc-production.up.railway.app
```

## Permissão Android

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## Pagamento

O app mobile não possui fluxo de pagamento. O pagamento da plataforma foi implementado na web/backend.

## Validação

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release --dart-define=API_BASE_URL=https://empowerlearn-ofc-production.up.railway.app
```

APK:

```txt
flutter/build/app/outputs/flutter-apk/app-release.apk
```
