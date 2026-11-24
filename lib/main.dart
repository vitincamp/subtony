import 'package:flutter/material.dart';

import 'viacep_service.dart';

void main() => runApp(const ViaCepApp());

class ViaCepApp extends StatelessWidget {
  const ViaCepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de CEP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ConsultaCepPage(),
    );
  }
}

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final _service = ViaCepService();

  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _localidadeController = TextEditingController();
  final _ufController = TextEditingController();

  bool _carregando = false;

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _localidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  void _limparCampos() {
    _logradouroController.clear();
    _bairroController.clear();
    _localidadeController.clear();
    _ufController.clear();
  }

  Future<void> _consultar() async {
    FocusScope.of(context).unfocus();
    setState(() => _carregando = true);
    _limparCampos();

    try {
      final endereco = await _service.buscarCep(_cepController.text);
      _logradouroController.text = endereco.logradouro;
      _bairroController.text = endereco.bairro;
      _localidadeController.text = endereco.localidade;
      _ufController.text = endereco.uf;
    } on CepException catch (e) {
      _mostrarMensagem(e.mensagem);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarMensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Widget _campo(String rotulo, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: rotulo,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de CEP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              maxLength: 9,
              decoration: const InputDecoration(
                labelText: 'CEP',
                hintText: 'Ex.: 79400000',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _consultar(),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _carregando ? null : _consultar,
              icon: _carregando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: const Text('Consultar'),
            ),
            _campo('Logradouro', _logradouroController),
            _campo('Bairro', _bairroController),
            _campo('Localidade', _localidadeController),
            _campo('UF', _ufController),
          ],
        ),
      ),
    );
  }
}
