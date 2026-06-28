import 'package:flutter/material.dart';

import '../services/api_service.dart';

void showCreateTaskSheet({
  required BuildContext context,
  required int materiaId,
  required String materiaTitulo,
}) {
  final tituloCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  DateTime? prazo;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setModalState) {
          return Container(
            height: MediaQuery.of(sheetContext).size.height * 0.72,
            decoration: const BoxDecoration(
              color: Color(0xFF081225),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
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
                  'Matéria: $materiaTitulo',
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(height: 20),
                _campo(tituloCtrl, 'Título da tarefa'),
                const SizedBox(height: 12),
                _campo(descricaoCtrl, 'Descrição', linhas: 3),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: sheetContext,
                      initialDate: DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (picked == null || !sheetContext.mounted) return;

                    setModalState(() {
                      prazo = picked;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111C3D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          prazo != null
                              ? '${prazo!.day}/${prazo!.month}/${prazo!.year}'
                              : 'Selecionar prazo',
                          style: TextStyle(
                            color: prazo != null
                                ? Colors.white
                                : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final titulo = tituloCtrl.text.trim();
                      final descricao = descricaoCtrl.text.trim();

                      if (titulo.isEmpty || prazo == null) {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          const SnackBar(
                            content: Text('Informe o título e o prazo.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      final prazoIso = DateTime.utc(
                        prazo!.year,
                        prazo!.month,
                        prazo!.day,
                        12,
                      ).toIso8601String();

                      final messenger = ScaffoldMessenger.of(context);

                      Navigator.pop(sheetContext);

                      try {
                        await ApiService.createTarefa({
                          'titulo': titulo,
                          'descricao': descricao,
                          'materiaId': materiaId,
                          'prazo': prazoIso,
                        });

                        if (!context.mounted) return;

                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Tarefa criada!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Erro ao criar tarefa: $e'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Criar Tarefa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    tituloCtrl.dispose();
    descricaoCtrl.dispose();
  });
}

Widget _campo(TextEditingController controller, String hint, {int linhas = 1}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF111C3D),
      borderRadius: BorderRadius.circular(14),
    ),
    child: TextField(
      controller: controller,
      maxLines: linhas,
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
