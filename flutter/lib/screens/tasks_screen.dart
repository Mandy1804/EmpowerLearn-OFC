import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedFilter = 0;
  String _userTipo = 'aluno';
  bool _carregando = true;
  String? _erro;
  List<dynamic> _tarefas = [];

  final List<Color> _paletaCores = [
    Colors.cyan,
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  final Map<String, Color> _coresPorMateria = {};

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  bool get _isProfessor {
    return _userTipo == 'professor' || _userTipo == 'admin';
  }

  List<String> get _filtros {
    if (_isProfessor) {
      return ['Todas', 'Criadas'];
    }

    return ['Todas', 'A Fazer', 'Enviadas'];
  }

  List<dynamic> get _tarefasFiltradas {
    if (_selectedFilter == 0) {
      return _tarefas;
    }

    final filtro = _filtros[_selectedFilter];

    if (_isProfessor && filtro == 'Criadas') {
      return _tarefas;
    }

    return _tarefas.where((tarefa) {
      final status = _statusTarefa(tarefa);
      return status == filtro;
    }).toList();
  }

  Future<void> _carregar() async {
    if (mounted) {
      setState(() {
        _carregando = true;
        _erro = null;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final tipo = prefs.getString('userTipo') ?? 'aluno';

      final tarefas = await ApiService.getTarefas(0);

      if (!mounted) return;

      setState(() {
        _userTipo = tipo.toLowerCase();
        _tarefas = tarefas;
        _selectedFilter = 0;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar tarefas.';
        _tarefas = [];
        _carregando = false;
      });
    }
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  int _parseId(dynamic valor) {
    if (valor is int) return valor;
    return int.tryParse(valor?.toString() ?? '') ?? 0;
  }

  String _statusTarefa(dynamic tarefa) {
    final status = tarefa['status']?.toString();

    if (status != null && status.trim().isNotEmpty) {
      return status;
    }

    if (_isProfessor) {
      return 'Criadas';
    }

    return 'A Fazer';
  }

  String _formatarPrazo(dynamic valor) {
    if (valor == null) {
      return 'Sem prazo';
    }

    try {
      final data = DateTime.parse(valor.toString());
      final dia = data.day.toString().padLeft(2, '0');
      final mes = data.month.toString().padLeft(2, '0');
      final ano = data.year.toString();

      return '$dia/$mes/$ano';
    } catch (_) {
      return valor.toString();
    }
  }

  String _nomeMateria(dynamic tarefa) {
    final materia = _asMap(tarefa['materia']);

    final nomeDireto = tarefa['materiaNome']?.toString();
    if (nomeDireto != null && nomeDireto.trim().isNotEmpty) {
      return nomeDireto.trim();
    }

    final nomeMateria = materia?['nome']?.toString();
    if (nomeMateria != null && nomeMateria.trim().isNotEmpty) {
      return nomeMateria.trim();
    }

    final tituloMateria = materia?['titulo']?.toString();
    if (tituloMateria != null && tituloMateria.trim().isNotEmpty) {
      return tituloMateria.trim();
    }

    final idMateria = _parseId(tarefa['materiaId']);
    if (idMateria > 0) {
      return 'Matéria $idMateria';
    }

    return 'Sem matéria';
  }

  String _nomeCurso(dynamic tarefa) {
    final materia = _asMap(tarefa['materia']);
    final cursoDireto = _asMap(tarefa['curso']);
    final cursoDaMateria = _asMap(materia?['curso']);

    final nomeDireto = tarefa['cursoNome']?.toString();
    if (nomeDireto != null && nomeDireto.trim().isNotEmpty) {
      return nomeDireto.trim();
    }

    final nomeCursoDireto = cursoDireto?['nome']?.toString();
    if (nomeCursoDireto != null && nomeCursoDireto.trim().isNotEmpty) {
      return nomeCursoDireto.trim();
    }

    final nomeCursoDireto2 = cursoDireto?['titulo']?.toString();
    if (nomeCursoDireto2 != null && nomeCursoDireto2.trim().isNotEmpty) {
      return nomeCursoDireto2.trim();
    }

    final nomeCursoMateria = cursoDaMateria?['nome']?.toString();
    if (nomeCursoMateria != null && nomeCursoMateria.trim().isNotEmpty) {
      return nomeCursoMateria.trim();
    }

    final nomeCursoMateria2 = cursoDaMateria?['titulo']?.toString();
    if (nomeCursoMateria2 != null && nomeCursoMateria2.trim().isNotEmpty) {
      return nomeCursoMateria2.trim();
    }

    return 'Curso não informado';
  }

  String _chaveMateria(dynamic tarefa) {
    final idMateria = _parseId(tarefa['materiaId']);
    if (idMateria > 0) {
      return 'materia_$idMateria';
    }

    final nome = _nomeMateria(tarefa).trim().toLowerCase();
    if (nome.isNotEmpty) {
      return nome;
    }

    return 'sem_materia';
  }

  Color _corDaMateria(dynamic tarefa) {
    final chave = _chaveMateria(tarefa);

    if (_coresPorMateria.containsKey(chave)) {
      return _coresPorMateria[chave]!;
    }

    final cor = _paletaCores[_coresPorMateria.length % _paletaCores.length];
    _coresPorMateria[chave] = cor;
    return cor;
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  Widget _campo(TextEditingController ctrl, String hint, {int linhas = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
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

  void _abrirSubmeter(dynamic tarefa) {
    final respostaCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.6,
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
              Text(
                tarefa['titulo']?.toString() ?? 'Tarefa',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tarefa['descricao']?.toString() ?? '',
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 20),
              _campo(respostaCtrl, 'Sua resposta...', linhas: 5),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final resposta = respostaCtrl.text.trim();

                    if (resposta.isEmpty) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(
                          content: Text('Informe sua resposta.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    final tarefaId = _parseId(tarefa['id']);

                    if (tarefaId <= 0) {
                      Navigator.pop(sheetContext);
                      _mostrarMensagem('Tarefa inválida.', Colors.redAccent);
                      return;
                    }

                    Navigator.pop(sheetContext);

                    try {
                      await ApiService.submeterTarefa(tarefaId, resposta);

                      if (!mounted) return;

                      _mostrarMensagem('Tarefa enviada!', Colors.green);
                      await _carregar();
                    } catch (e) {
                      if (!mounted) return;

                      _mostrarMensagem(
                        'Erro ao enviar tarefa: $e',
                        Colors.redAccent,
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
                    'Enviar Resposta',
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
    ).whenComplete(() {
      respostaCtrl.dispose();
    });
  }

  Widget _statCard(String titulo, String valor, {Color? valueColor}) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const Spacer(),
          Text(
            valor,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filtroChip(int index) {
    final selected = _selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6C63FF) : const Color(0xFF111C3D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          _filtros[index],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _estadoCarregando() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _estadoErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),
            Text(
              _erro ?? 'Erro ao carregar tarefas.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _carregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: Colors.white30,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _isProfessor
                ? 'Nenhuma tarefa criada.\nCrie tarefas pelo botão da matéria.'
                : 'Nenhuma tarefa disponível.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _cardTarefa(dynamic tarefa, int index) {
    final cor = _corDaMateria(tarefa);
    final titulo = tarefa['titulo']?.toString() ?? 'Tarefa sem título';
    final descricao = tarefa['descricao']?.toString() ?? '';
    final nomeMateria = _nomeMateria(tarefa);
    final nomeCurso = _nomeCurso(tarefa);
    final prazo = _formatarPrazo(tarefa['prazo']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: cor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    nomeMateria,
                    style: TextStyle(
                      color: cor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (descricao.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                descricao,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white38,
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  prazo,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.school_outlined,
                  color: Colors.white38,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    nomeCurso,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (!_isProfessor) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () => _abrirSubmeter(tarefa),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cor.withOpacity(0.22),
                    foregroundColor: cor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Responder',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _listaTarefas() {
    final tarefas = _tarefasFiltradas;

    if (tarefas.isEmpty) {
      return _estadoVazio();
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tarefas.length,
        itemBuilder: (_, index) {
          return _cardTarefa(tarefas[index], index);
        },
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return _estadoCarregando();
    }

    if (_erro != null) {
      return _estadoErro();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 30),
            const Text(
              'Atividades',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _carregar,
              icon: const Icon(Icons.refresh, color: Colors.white70),
              tooltip: 'Atualizar tarefas',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _statCard('Tarefas', _tarefas.length.toString())),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                _isProfessor ? 'Criadas' : 'Pendentes',
                _tarefasFiltradas.length.toString(),
                valueColor: const Color(0xFFFFB020),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filtros.length,
            itemBuilder: (_, index) {
              return _filtroChip(index);
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(child: _listaTarefas()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: _conteudo()),
      ),
    );
  }
}
