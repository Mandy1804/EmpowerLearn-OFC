import 'package:flutter/material.dart';

import '../services/api_service.dart';

void showCreateTaskSheet({
  required BuildContext context,
  required int materiaId,
  required String materiaTitulo,
}) {
  final parentContext = context;

  showModalBottomSheet<bool>(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _CreateTaskSheet(
        materiaId: materiaId,
        materiaTitulo: materiaTitulo,
      );
    },
  ).then((criou) {
    if (criou != true || !parentContext.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(parentContext);

    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Tarefa criada!'),
        backgroundColor: Colors.green,
      ),
    );
  });
}

class _CreateTaskSheet extends StatefulWidget {
  final int materiaId;
  final String materiaTitulo;

  const _CreateTaskSheet({
    required this.materiaId,
    required this.materiaTitulo,
  });

  @override
  State<_CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<_CreateTaskSheet> {
  final TextEditingController _tituloCtrl = TextEditingController();
  final TextEditingController _descricaoCtrl = TextEditingController();

  DateTime? _prazo;
  bool _salvando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarPrazo() async {
    final hoje = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: hoje.add(const Duration(days: 7)),
      firstDate: DateTime(hoje.year, hoje.month, hoje.day),
      lastDate: hoje.add(const Duration(days: 365)),
    );

    if (!mounted || picked == null) {
      return;
    }

    setState(() {
      _prazo = picked;
    });
  }

  Future<void> _criarTarefa() async {
    if (_salvando) {
      return;
    }

    final titulo = _tituloCtrl.text.trim();
    final descricao = _descricaoCtrl.text.trim();

    if (titulo.isEmpty || _prazo == null) {
      _mostrarMensagem('Informe o título e o prazo.', Colors.orange);
      return;
    }

    final prazoIso = DateTime.utc(
      _prazo!.year,
      _prazo!.month,
      _prazo!.day,
      12,
    ).toIso8601String();

    setState(() {
      _salvando = true;
    });

    try {
      await ApiService.createTarefa({
        'titulo': titulo,
        'descricao': descricao,
        'materiaId': widget.materiaId,
        'prazo': prazoIso,
      });

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _salvando = false;
      });

      _mostrarMensagem('Erro ao criar tarefa: $e', Colors.redAccent);
    }
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  String _formatarPrazo() {
    if (_prazo == null) {
      return 'Selecionar prazo';
    }

    final dia = _prazo!.day.toString().padLeft(2, '0');
    final mes = _prazo!.month.toString().padLeft(2, '0');
    final ano = _prazo!.year.toString();

    return '$dia/$mes/$ano';
  }

  Widget _campo(
    TextEditingController controller,
    String hint, {
    int linhas = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        maxLines: linhas,
        enabled: !_salvando,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _seletorPrazo() {
    return GestureDetector(
      onTap: _salvando ? null : _selecionarPrazo,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111C3D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _formatarPrazo(),
                style: TextStyle(
                  color: _prazo != null ? Colors.white : Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoCriar() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _salvando ? null : _criarTarefa,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6CFF),
          disabledBackgroundColor: const Color(0xFF26345F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _salvando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Criar Tarefa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height * 0.72;
    final teclado = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: Container(
        height: altura,
        decoration: const BoxDecoration(
          color: Color(0xFF081225),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: teclado + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Criar Tarefa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Matéria: ${widget.materiaTitulo}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    _campo(_tituloCtrl, 'Título da tarefa'),
                    const SizedBox(height: 12),
                    _campo(_descricaoCtrl, 'Descrição', linhas: 3),
                    const SizedBox(height: 12),
                    _seletorPrazo(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _botaoCriar(),
          ],
        ),
      ),
    );
  }
}
