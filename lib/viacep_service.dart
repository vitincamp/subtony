import 'dart:convert';

import 'package:http/http.dart' as http;

/// Modelo com os dados retornados pela API ViaCEP.
class Endereco {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: (json['cep'] ?? '') as String,
      logradouro: (json['logradouro'] ?? '') as String,
      bairro: (json['bairro'] ?? '') as String,
      localidade: (json['localidade'] ?? '') as String,
      uf: (json['uf'] ?? '') as String,
    );
  }
}

/// Exceção para erros de consulta (CEP inválido, não encontrado, rede).
class CepException implements Exception {
  final String mensagem;
  const CepException(this.mensagem);

  @override
  String toString() => mensagem;
}

class ViaCepService {
  /// Consulta um CEP em https://viacep.com.br/ws/{cep}/json/
  Future<Endereco> buscarCep(String cep) async {
    final somenteNumeros = cep.replaceAll(RegExp(r'\D'), '');
    if (somenteNumeros.length != 8) {
      throw const CepException('O CEP deve conter 8 dígitos.');
    }

    final uri = Uri.parse('https://viacep.com.br/ws/$somenteNumeros/json/');

    try {
      final resposta = await http.get(uri);

      if (resposta.statusCode != 200) {
        throw const CepException('CEP inválido ou serviço indisponível.');
      }

      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;

      if (dados['erro'] == true || dados['erro'] == 'true') {
        throw const CepException('CEP não encontrado.');
      }

      return Endereco.fromJson(dados);
    } on CepException {
      rethrow;
    } catch (_) {
      throw const CepException('Erro de conexão. Tente novamente.');
    }
  }
}
