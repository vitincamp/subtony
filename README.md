# ViaCEP App

Aplicativo Flutter que consulta um CEP na API [ViaCEP](https://viacep.com.br/)
e exibe `logradouro`, `bairro`, `localidade` e `uf` em campos de texto separados.

## Como executar

```bash
flutter create .   # gera as pastas android/ios/web (apenas na primeira vez)
flutter pub get
flutter run
```

## Dependência

- [http](https://pub.dev/packages/http) (`flutter pub add http`)
