# Relatório de Validação Mobile e APK - EmpowerLearn.class

## Objetivo

Registrar a validação técnica do aplicativo mobile antes da entrega do APK.

## Escopo validado

- Framework Flutter/Dart.
- Permissão INTERNET no Android.
- API configurável por API_BASE_URL.
- Análise estática com flutter analyze.
- Teste automatizado com flutter test.
- Build APK release.

## Teste automatizado

Arquivo:

```txt
flutter/test/widget_test.dart
```

Cenário:

- Inicia o app sem sessão salva.
- Verifica exibição da tela de login.
- Confirma presença dos campos Email e Senha.
- Confirma presença dos botões Entrar e Criar conta gratuita.

## Comandos

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release --dart-define=API_BASE_URL=https://empowerlearn-ofc-production.up.railway.app
```

## Resultado esperado

```txt
flutter analyze: No issues found
flutter test: All tests passed
flutter build apk: Built app-release.apk
```

## Caminho do APK

```txt
flutter/build/app/outputs/flutter-apk/app-release.apk
```
